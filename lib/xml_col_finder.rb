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

  private

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

          puts "path.join('/'): " + path.join('/').inspect
          puts 'txt:' + txt.inspect

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
