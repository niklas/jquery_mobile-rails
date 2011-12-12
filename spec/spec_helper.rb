require 'rubygems'
require 'bundler/setup'
require 'capybara'

$:.unshift Pathname.new(__FILE__).join('../../app')

RSpec.configure do |config|
end
