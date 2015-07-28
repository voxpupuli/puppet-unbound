begin
  require 'ipaddr'
rescue => e
  puts e.message
  puts e.backtrace.inspect
end

module PuppetX
  module Unbound
    class ValidateAddrs
      attr_reader :ip_list, :name_list

      def initialize(address_list)
        @address_list = Array(address_list).flatten
        @ip_list = []
        @name_list = []
        validate()
      end

      def validate
        @address_list.each {|a|
          if a =~ /@.*@/
            raise Puppet::ParseError, "Too many @ signs in #{a}"
          elsif a =~ /@/
            addr, port = a.split('@')
            begin
              Integer(port)
            rescue
              raise Puppet::ParseError, "Specifed port is not numeric in #{port}"
            end
            if is_ip?(addr)
              @ip_list << a
            else
              @name_list << a
            end
          else
            if is_ip?(a)
              @ip_list << a
            else
              @name_list << a
            end
          end
        }
      end

      def is_ip?(address)
        begin
          IPAddr.new address
          return true
        rescue
          return false
        end
      end
    end
  end
end
