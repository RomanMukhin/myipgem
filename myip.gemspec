# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'myip/version'

Gem::Specification.new do |gem|
  gem.name          = "myip"
  gem.version       = Myip::VERSION
  gem.authors       = ["Roman Mukhin"]
  gem.email         = ["roman11mukhin@gmail.com"]
  gem.description   = %q{This gem is used to find country by ip}
  gem.summary       = %q{ip_to_country}
  gem.homepage      = ""

  gem.files         = Dir['lib/**/*'] + Dir['bin/*']
  gem.files         += Dir['[A-Z]*'] + Dir['test/**/*']
  gem.executables   = ["ctry_by_ip", "cntry_by_ip", "country_by_ip",
                       "update_ip_database", "city_by_ip", "region_by_ip"]
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
end
