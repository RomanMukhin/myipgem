module Myip
  class IPAddr
    def initialize
      begin
        @@db = []
        spec = Gem::Specification.find_by_name("myip")
        gem_root = spec.gem_dir
        @gem_lib = gem_root + "/lib"
      rescue
        @gem_lib = "./lib"
      ensure
        read_the_db if @@db.empty?
      end
    end
    
    method_names = ["ctry", "cntry", "country", "region", "city"]
    method_names.each_with_index do |name, index|
      define_method "#{name}_by_ip" do |ip|
        begin 
          if (0..2).to_a.include?(index)
            @@db.find{|l| l[1].to_i >= ip_numeric(ip)}[2 + index]
          else
            find_it = /<#{name}>([^<]*)/
            response = parse_ipgeobase(ip)
            response.scan(find_it).first[0]
          end
        rescue
          "Database is damaged or invalid ip"
        end
      end
    end

    def update_ip_database
      download_db
      unzip_db
      read_the_db
    end

    private
    def ip_numeric(ip)
      numeric_ip = 0
      ip.split('.').each_with_index do |part, i|
        numeric_ip += part.to_i * (256 ** (3-i))
      end
      numeric_ip
    end

    def download_db
      begin   
        http = Net::HTTP.start("software77.net")
        resp = http.get("/geo-ip/?DL=1 -O /path/IpToCountry.csv.gz")
        open(@gem_lib + "/IpToCountry.csv.gz", "wb") do |file|
          file.write(resp.body)
        end
      rescue
        puts "Connection to database website failed."
      end
    end

    def unzip_db
      begin
        Zlib::GzipReader.open(@gem_lib + '/IpToCountry.csv.gz') do |gz|
          g = File.new(@gem_lib + "/IpToCountry.csv", "wb") 
          g.write gz.read
          g.close
        end
      rescue
        puts "Unzipping failed."
      end
    end

    def read_the_db
      open(@gem_lib + '/IpToCountry.csv') do |file| 
        @@db = file.read.scan(/^"(\d*)","(\d*)","(?:\w*)","(?:\d*)","(\w*)","(\w*)","(\w*)"/) 
      end
    end

    def parse_ipgeobase ip
      result = Net::HTTP.get(URI.parse("http://ipgeobase.ru:7020/geo?ip=#{ip}"))
      result.encode('UTF-8', 'WINDOWS-1251')
    end
  end
end
