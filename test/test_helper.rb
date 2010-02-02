ENV['RAILS_ENV'] = 'test' 
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'

require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'

# Load the Rails Environment #
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))

# Run our plugin Init #
require File.dirname(__FILE__) + '/../init.rb'