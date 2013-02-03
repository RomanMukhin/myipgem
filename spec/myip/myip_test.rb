module Myip
  describe IPAddr  do 
    let(:ipaddr){ IPAddr.new }
    before(:each) do
      WebMock.disable_net_connect!
    end

    context "#update_ip_database" do
      let(:db_url){ "http://software77.net/geo-ip/?DL=1%20-O%20/path/IpToCountry.csv.gz" }
      let(:file){ double('file').as_null_object}

      before(:all) do
        @dir = ipaddr.instance_variable_get(:@gem_lib)
      end
      before(:each) do
        file.stub(:write)
      end
      
      it "should download the database archive and unzip it" do
        ipaddr.stub!(:download_db)
        ipaddr.stub!(:unzip_db)
        ipaddr.should_receive(:download_db).ordered
        ipaddr.should_receive(:unzip_db).ordered
        ipaddr.update_ip_database
      end

      context "#download_db" do
        before(:each) do
          ipaddr.stub!(:unzip_db)
        end
        
        it "should download the database" do
          WebMock.stub_request(:get,db_url).to_return(:body => "*Database content*")
          described_class.any_instance.stub(:open).and_yield(file)
          file.should_receive(:write).with("*Database content*")
          ipaddr.update_ip_database
        end
        
        it "should tell, if connection failed" do
          WebMock.stub_request(:get, db_url).to_timeout
          ipaddr.should_receive(:puts).with("Connection to database website failed.")
          ipaddr.update_ip_database
        end
      end

      context "#unzip_db" do
        before(:each) do
          ipaddr.stub!(:download_db)
        end

        let(:archive){ double('archive').as_null_object}
        
        it "should unzip the file" do
          Zlib::GzipReader.stub(:open).and_yield( archive )
          archive.stub(:read).and_return( "test" )
          File.stub!(:new).and_return( file )
          File.should_receive(:new).with( @dir + "/IpToCountry.csv", "wb" )
          file.should_receive(:write).with("test")
          ipaddr.update_ip_database
        end
        
        it 'should tell, if unzippin failed' do
          File.stub!(:new)
          Zlib::GzipReader.stub!(:open).and_yield(NilClass)
          ipaddr.should_receive(:puts).with( "Unzipping failed." )
          ipaddr.update_ip_database
        end
      end
    end

    context "country name by ip from database" do
      let(:ips){['91.193.232.39', '175.33.22.11', '0.0.0.1']}
      let(:ctry){['UA', 'AU', 'ZZ']}
      let(:cntry){['UKR', 'AUS', 'ZZZ']}
      let(:country){['Ukraine', 'Australia', 'Reserved']}
      let(:not_valid){ 0101 }
      
      ["ctry","cntry","country"].each_with_index do |name, i|
        send(:it,"##{name}_by_ip") do
          ips.each_with_index do |ip, index|
            ipaddr.send("#{name}_by_ip", ip).should == (eval name)[index]
          end
        end
      end

      it "should tell if something is wrong with database or ip" do
        ipaddr.ctry_by_ip(not_valid).should == "Database is damaged or invalid ip"
      end
    end

    context "#parse_ipgeobase" do 
      let(:sng_ips){['91.193.232.39', '92.22.11.44']}
      let(:sng_cities){['Dnepropetovsk', 'Kharkov']}
      let(:sng_regions){['Dnepropetrovkskaya oblast', 'Kharkovskaya oblast']}
      let(:xml_body){[]}
      let(:ipgeobase_url){"http://ipgeobase.ru:7020/geo?ip="}
      before(:all) do
        sng_cities.size.times do |i|
          xml_body << "<ip-answer>
          <ip value=\"91.193.232.39\">
          <inetnum>91.193.232.0 - 91.193.235.255</inetnum>
          <country>UA</country><city>#{sng_cities[i]}</city>
          <region>#{sng_regions[i]}</region>
          <district>Vostochnaya Ukraina</district>
          <lat>48.450001</lat>
          <lng>34.983334</lng></ip>
          </ip-answer>"
        end
      end
      
      it "should parse the given xml for city and region" do
        sng_ips.each_with_index do |ip, i|
          stub_request(:get, "#{ipgeobase_url}#{ip}").to_return(:body => xml_body[i])
          ipaddr.city_by_ip(ip).should   == sng_cities[i]
          ipaddr.region_by_ip(ip).should == sng_regions[i]
        end
      end
    end
  end
end
