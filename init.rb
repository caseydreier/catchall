require File.dirname(__FILE__) + '/lib/deliver_to_developer'
ActionMailer::Base.send :include, DeliverToDeveloper::InstanceMethods