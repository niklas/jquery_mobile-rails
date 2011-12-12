require 'rubygems'
require 'bundler/setup'
require 'capybara'
require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/core_ext/string/output_safety'

$:.unshift Pathname.new(__FILE__).join('../../app')

RSpec.configure do |config|
end
