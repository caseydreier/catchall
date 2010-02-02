require 'test_helper'

class ApplicationController < ActionController::Base
  
end


class DeliverToDeveloperTest < ActionMailer::TestCase
  
  test "that the email address is changed properly when delivery method is appended with 'to_developer'" do
    
    DeliverToDeveloper.developer_emails = 'casey@casey.com'

    # Setup our test email
    prepare_test_email
  
    # Append with "to_developer" to trigger the code #
    ActionMailer::Base.delivery_method = :test_to_developer
    ActionMailer::Base.deliver(@expected)

    # Make sure something was sent #
    assert ActionMailer::Base.deliveries.size == 1
    
    # Make sure that the email was changed the the netid's SHA email address #
    assert_equal 'casey@casey.com',ActionMailer::Base.deliveries.first.to.first
    
    # Make sure the "from" field was unchanged #
    assert_equal 'test@test.com',ActionMailer::Base.deliveries.first.from.first
  end
  
  test "that the developer_emails setting will accept an array of email addresses" do
    prepare_test_email
    DeliverToDeveloper.developer_emails = %w(casey@casey.com huminahowwa@casey.com)
    
    # Append with "to_developer" to trigger the code #
    ActionMailer::Base.delivery_method = :test_to_developer
    ActionMailer::Base.deliver(@expected)

    # Make one email was sent #
    assert ActionMailer::Base.deliveries.size == 1
    
    # Make sure that the outgoing email's "to" address was changed properly #
    assert_equal ['casey@casey.com','huminahowwa@casey.com'].sort,ActionMailer::Base.deliveries.first.to.sort
    
    # Make sure the "from" field was unchanged #
    assert_equal 'test@test.com',ActionMailer::Base.deliveries.first.from.first
    
  end
  
  def prepare_test_email
    # Setup our test email
    @expected.from    = 'test@test.com'
    @expected.to      = 'original@receiver.com'
    @expected.subject = 'Test Subject'
    @expected.body    = 'blah'
    @expected.date    = Time.now
  end
end
