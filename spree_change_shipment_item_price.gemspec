# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_change_shipment_item_price'
  s.version     = '2.4.4.beta'
  s.summary     = 'Allow arbitrary changes to shipment item price'
  s.description = "This extension allows administrators to make changes to the price of a shipment's line item"
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Mike State'
  s.email     = 'mstate@gmail.com'
  s.homepage  = 'http://github.com/mstate'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.4.4.beta'
  s.add_dependency 'spree_product_assembly'

  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
