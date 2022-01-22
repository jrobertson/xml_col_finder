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

    h = group_by_xpath(a)
    @to_a = truncate_xpath(h).flatten(1)

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

    n = 0
    while n < a.length

      path, txt = a[n]
      stickypath = ''

      path.each do |name|

        if @debug then
          puts "h[+ stickypath + '/' + name]: " \
              + h[stickypath + '/' + name].inspect
        end

        if h[stickypath + '/' + name] > 1 then

          stickypath += '/' + name
          next

        else

          h2[stickypath] ||= []
          h2[stickypath] << [path.join('/'), txt]
          break

        end

      end

      n += 1

    end


    if h2.length > 1 then

      a2 = h2.map {|k,v| [k.split('/'), v]}
      group_by_xpath(a2)

    else

      return h2

    end
  end

  def truncate_xpath(records, offset=0)

    records.map do |key, value|

      new_key = key.sub(/^\/+/,'')[offset..-1]
      len = new_key.length
      #puts len.inspect
      puts 'new_key: ' + new_key.inspect if @debug

      new_value = value.map do |k2, v2|

        puts 'k2: ' + k2.inspect if @debug
        new_k2 = k2.sub(/^\/+/,'')[offset+len..-1]
        new_len = new_k2.length
        puts 'new_k2: ' + new_k2.inspect if @debug
        puts 'v2: ' + v2.inspect if @debug

        v2b = v2.is_a?(Array) ? truncate_xpath(v2, offset+len+new_len) : v2

        [new_k2, v2b]

      end

      [new_key, new_value]

    end

  end

end
