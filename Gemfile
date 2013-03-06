source "https://rubygems.org"

gemspec

gem "tvd-tvdinner" unless File.exists?(File.expand_path("../tvd-tvdinner.gemspec", __FILE__))
gem "chefspec"
gem "minitest-chef-handler"
gem "foodcritic", :platforms => :ruby_19

gem "aws-sdk"
gem "tvd-vagrant", (ENV['EDIT_tvd_vagrant'] ? { :github => "destructuring/tvd-vagrant" } : {})
