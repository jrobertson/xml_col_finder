#!/usr/bin/env ruby

# file: xml_col_finder.rb

require 'rexle'
require 'clipboard'

# how to use this gem?
#
# 1. Find a web page to fetch values from
# 2. Press F12 to invoke developer tools
# 3. right-click on the element containing the
#    child elements containing the values
# 4. select copy > copy outerHTML
# 5. paste the test into a file
# 6. File.read the txt file and pass it to XMLColFinder.new

# note: There's a to_code method which makes it convenient to fetch the
#       values from the generated code.

class XMLColFinder

  attr_reader :to_a

  def initialize(obj, debug: false)

    @debug = debug
    @doc = obj.is_a?(Rexle) ? obj : Rexle.new(obj)

    a = []
    @doc.root.each_recursive do |node|

      if node.text and node.text.strip.length >= 1 then
        a << [BacktrackXPath.new(node, ignore_id: true).to_xpath.split('/'),
              node.text]
      end

    end

    @to_a = a
    h = group_by_xpath(a)
    @to_a = truncate_xpath(h).flatten(1)

  end

  def to_code(nametip: true)

    @nametip = nametip
    @tags = {}

    xpath, remaining = @to_a

    eid = getid(xpath)
    linex = formatline('doc', eid, xpath)
    a = scan(remaining, eid)

    lines = a.flatten.compact.prepend linex
    lines2 = lines.join("\n").lines\
        .map {|line|  line =~ /.text$/ ? 'puts ' + line : line }
    lines2[0].sub!(/(?<=\")div/,'//div')
    s = "require 'nokorexi'

url = 'https://insert-your-url'
doc = Nokorexi.new(url).to_doc
" + lines2.join

    Clipboard.copy s
    return s

  end

  def to_doc()
    @doc
  end

  private

  def formatline(pid, eid=nil, key=nil, tail=nil, index: nil)

    if eid then

      nametip = @nametip && tail.is_a?(String)
      klass = nametip ? key.scan(/@class=['"]([^'"]+)/).last : nil

      line = if klass then
        desc = klass[0][/^[^\-]+/].gsub(/(?=[A-Z])/,' ').downcase
        desc += " (e.g. %s)" % [tail.length < 50 ? tail : tail[0..46] + '...']
        "\n# " + desc + "\n"
      elsif nametip
        "\n# e.g. %s\n" % [tail.length < 50 ? tail : tail[0..46] + '...']
      else
        ''
      end

      key.gsub!("[@class='']",'') # Rexle XPath bug solution!
      line += "%s = %s.element(\"%s\")" % [eid, pid, key]
      if tail.is_a? String
        line += '.text'
        #line += "\n" if nametip
      end

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
    when :p
      'para'
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
          end

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
