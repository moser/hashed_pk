# Load the environment
ENV['RAILS_ENV'] ||= 'test'
require File.dirname(__FILE__) + '/rails_root/config/environment.rb'
 
# Load the testing framework
require 'test_help'
silence_warnings { RAILS_ENV = ENV['RAILS_ENV'] }
 
# Run the migrations
ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate")

