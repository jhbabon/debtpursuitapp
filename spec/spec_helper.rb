ENV['RACK_ENV'] = 'test'

require File.dirname( __FILE__ ) + '/../debt_pursuit'
require File.dirname( __FILE__ ) + '/../lib/expense'
require File.dirname( __FILE__ ) + '/../lib/account'
require 'minitest/spec'
require 'minitest/autorun'
require 'rack/test'
