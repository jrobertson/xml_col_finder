#!/usr/bin/env ruby

# file: xml_col_finder.rb

require 'rexle'


class XMLColFinder

  attr_reader :to_a

  def initialize(s, debug: false)

    @debug = debug
    doc = Rexle.new(s)

    a = []
    doc.root.each_recursive do |node|

      if node.text then
        a << [BacktrackXPath.new(node, ignore_id: true).to_xpath.split('/'),
              node.text]
      end

    end

    #@to_a = a
    h = group_by_xpath(a)
    @to_a = truncate_xpath(h).flatten(1)

  end

  def to_code()

    @tags = {}

    xpath, remaining = @to_a

    eid = getid(xpath)
    linex = formatline('doc', eid, xpath)
    a = scan(remaining, eid)

    a.flatten.compact.prepend linex

  end

  private

  def formatline(pid, eid=nil, key=nil, tail=nil, index: nil)

    if eid then
      line = "%s = %s.element(\"%s\")" % [eid, pid, key]
      line += '.text' if tail.is_a? String
    else
      line = index ? ("%s[%d].text" % [pid, index]) : ("%s.text" % pid)
    end

    return line
  end


  def getid(rawtag)

    rawtagx = rawtag.split('/').last[/\w+/]

    tag = case rawtagx.to_sym
    when :a
      'link'
    else
      rawtagx
    end

    if @tags.include?(tag) then
      @tags[tag] =~ /\d+$/ ? @tags[tag].succ! : @tags[tag] += '1'
    else
      @tags[tag] = tag
    end

  end


  # Groups xpath by matching branches
  #
  def group_by_xpath(a)

    h = Hash.new
    h.default = 0

    a.each do |path, txt|

      stickypath = ''
      path.each do |name|
        xpath = stickypath += '/' + name
        h[xpath] += 1
      end

    end

    h2 = {}

    a.each do |path,txt|

      stickypath = ''

      n = 0
      while n < path.length

        name = path[n]

        if h[stickypath + '/' + name] > 1

          stickypath += '/' + name

          if (n == path.length - 1) then

            h2[stickypath.sub(/^\//,'')] ||= []
            h2[stickypath.sub(/^\//,'')] << txt

          end

        else


          h2[stickypath.sub(/^\//,'')] ||= []
          h2[stickypath.sub(/^\//,'')] << [path.join('/'), txt]
          break

        end
        n += 1
      end

    end

    if h2.length > 1 then

      a2 = h2.map {|k,v| [k.split('/'), v]}
      group_by_xpath(a2)

    else

      return h2

    end

  end

  def scan(a, eid='doc', pid=eid.clone)

    #puts 'a: ' + a.inspect if @debug

    a.map do |row|

      head, tail = row

      if head.is_a? Array then

        hline = scan(row, eid, pid)

      elsif head

        if head[0] == '/' then

          key = head[1..-1]
          puts 'key: ' + key.inspect if @debug

          eid = getid(key)

          hline = if tail.is_a? Array and tail.all? {|x| x.is_a? String } then
            @prev_xpath = true
            "%s = %s.xpath(\"%s\")" % [eid, pid, key]
          else
            @prev_xpath = false
            formatline(pid, eid, key, tail)
          end

        else

          hline = formatline(pid=eid)
        end
      end

      if tail.is_a? Array then

        if tail.compact[0].is_a? Array then

          puts 'tail: ' + tail.inspect if @debug

          tline = scan(tail, eid)

        elsif tail.all? {|x| x.is_a? String} and tail[0][0] != '/'
          puts '_tail: ' + tail.inspect if @debug
          tline = tail.map.with_index do |x,i|
            formatline(pid=eid, index: i)
          end.join("\n")

        end
      end

      [hline, tline]
    end

  end


  def truncate_xpath(records, offset=0)

    records.map do |record|

      next unless record
      if record.is_a? Array and (record[0].is_a? Array or record.length > 2) then

        truncate_xpath(record, offset)

      else

        if record.is_a? String then

          value = record
          puts 'valuex: ' + value.inspect if @debug
          value

        else

          key, value = record
          puts 'key: ' + key.inspect if @debug

          new_key = key[offset..-1]
          puts 'new_key: ' + new_key.inspect if @debug

          next unless new_key
          len = new_key.length

          if value.is_a? Array then

            [new_key, truncate_xpath(value, offset+len)]

          else

            puts 'value: ' + value.inspect if @debug
            [new_key, value]

          end
        end
      end

    end

  end

end
