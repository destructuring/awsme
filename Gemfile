source "https://rubygems.org"

gemspec

def dev(nm_gem, workarea)
  gem nm_gem, (
    File.exists?(File.expand_path("../#{workarea}/#{nm_gem}", __FILE__)) ? 
      { :path => "#{workarea}/#{nm_gem}" } : 
      Dir["vendor/cache/#{nm_gem}-*.gem"].collect {|x| [x.gsub(/\d+/) {|num| sprintf("%011d", num) }, x] }.sort[0][1].split(/-/)[-1].gsub(/\.gem$/,"")
  )
end

gem "tvd-tvdinner" unless File.exists?(File.expand_path("../tvd-tvdinner.gemspec", __FILE__))
gem "chefspec"
gem "minitest-chef-handler"
gem "foodcritic", :platforms => :ruby_19

gem "aws-sdk"

dev "tvd-vagrant", "git"
