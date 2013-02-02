require 'myip/version'
require 'net/http' 
require 'rubygems'
require 'zlib'
require File.dirname(__FILE__)+'/myip/command'


module Myip
  class Chatter
    ["ctry", "cntry", "country", "region", "city"].each_with_index do |name, index|
      define_method "#{name}_by_ip" do
        puts IPAddr.new.send("#{name}_by_ip", ARGV[0]) 
      end
    end

    def update_ip_database
      IPAddr.new.update_ip_database
    end
  end
end
