source 'http://gemcutter.org'

gem "rails", :git => "git://github.com/rails/rails.git", :ref => "master"
gem "bluecloth"

group :test do
  gem "sqlite3-ruby", :require => "sqlite3"
end

custom = File.join(File.dirname(__FILE__), "config/Gemfile")
eval(File.read(custom)) if File.exists?(custom)
