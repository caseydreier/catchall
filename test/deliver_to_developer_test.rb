require 'test_helper'

class ApplicationController < ActionController::Base
  
end


class DeliverToDeveloperTest < ActionMailer::TestCase
  
  test "intended delivery method returns the proper delivery types" do
    assert @expected.respond_to? :intended_delivery_method
  end
  
  test "that the email address is changed properly when delivery method is appended with 'to_developer'" do
    
    DeliverToDeveloper.developer_emails = %w(cjd47@sha.cornell.edu)

    # Make a mock object of the request object for the ApplicationController
    # It only needs to respond like the subdomain call does, with an array of subdomains.
    ap = ApplicationController.new
    ap.request = mock()
    
    @expected.from    = 'test@test.com'
    @expected.to      = 'original@receiver.com'
    @expected.subject = 'Test Subject'
    @expected.body    = 'blah'
    @expected.date    = Time.now
  
    # Append with "to_developer" to trigger the code #
    ActionMailer::Base.delivery_method = :test_to_developer
    ActionMailer::Base.deliver(@expected)

    # Make sure something was sent #
    assert ActionMailer::Base.deliveries.size > 0
    
    # Make sure that the email was changed the the netid's SHA email address #
    assert_equal 'cjd47@sha.cornell.edu',ActionMailer::Base.deliveries.first.to.first
    
    # Make sure the "from" field was unchanged #
    assert_equal 'test@test.com',ActionMailer::Base.deliveries.first.from.first
    
  end
end
