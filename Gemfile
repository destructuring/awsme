source "https://rubygems.org"

gemspec

require "development"

gem "tvd-tvdinner" unless File.exists?(File.expand_path("../tvd-tvdinner.gemspec", __FILE__))
gem "chefspec"
gem "minitest-chef-handler"
gem "foodcritic", :platforms => :ruby_19

gem "aws-sdk"

gem "tvd-vagrant"

group :virtualbox do
  gem "vagrant", "1.0.6"
end
