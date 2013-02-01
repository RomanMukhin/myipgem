# Myip

My ipgeolocation gem.
The rails part is under construction.

## Installation

Add this line to your application's Gemfile:

    gem 'myip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install myip

## Usage

  To use commands in console after install:
  update_ip_database
  city_by_ip    your ip,
  region_by_ip  your ip,
  ctry_by_ip    your ip,
  cntry_by_ip   your ip,
  country_by_ip your ip.
  
  To use gem functions in programm:
  Myip::IPAddr.new.update_ip_database,
  Myip::IPAddr.new.city_by_ip 'your ip',    #in Ukraine and Russia
  Myip::IPAddr.new.region_by_ip 'your ip',   #in Ukraine and Russia
  Myip::IPAddr.new.ctry_by_ip 'your ip',     #everywhere
  Myip::IPAddr.new.cntry_by_ip 'your ip',
  Myip::IPAddr.new.country_by_ip 'your ip'
  
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
