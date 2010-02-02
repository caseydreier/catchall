require 'test_helper'

class DeliverToDeveloperTest < ActionMailer::TestCase
  

  test "that the email address is changed properly when delivery method is appended with 'to_developer'" do
    # Use our 'to_developer' delivery method to catch outgoing email.
    ActionMailer::Base.delivery_method = :test_to_developer
    
    DeliverToDeveloper.developer_emails = 'casey@casey.com'

    # Setup our test email
    prepare_test_email
  
    ActionMailer::Base.deliver(@expected)

    # Make sure something was sent #
    assert ActionMailer::Base.deliveries.size == 1
    
    # Make sure that the email was changed the the netid's SHA email address #
    assert_equal 'casey@casey.com',ActionMailer::Base.deliveries.first.to.first
    
    # Make sure the "from" field was unchanged #
    assert_equal 'test@test.com',ActionMailer::Base.deliveries.first.from.first
  end
  
  test "that the developer_emails setting will accept an array of email addresses" do
    # Use our 'to_developer' delivery method to catch outgoing email.
    ActionMailer::Base.delivery_method = :test_to_developer
    
    prepare_test_email
    
    DeliverToDeveloper.developer_emails = %w(casey@casey.com huminahowwa@casey.com)
    
    ActionMailer::Base.deliver(@expected)

    # Make one email was sent #
    assert ActionMailer::Base.deliveries.size == 1
    
    # Make sure that the outgoing email's "to" address was changed properly #
    assert_equal ['casey@casey.com','huminahowwa@casey.com'].sort,ActionMailer::Base.deliveries.first.to.sort
    
    # Make sure the "from" field was unchanged #
    assert_equal 'test@test.com',ActionMailer::Base.deliveries.first.from.first
    
  end
  
  test "that deliver to developer will wipe out any bcc or cc fields from the email" do
    # Use our 'to_developer' delivery method to catch outgoing email.
    ActionMailer::Base.delivery_method = :test_to_developer
    
    prepare_test_email
    @expected.bcc = 'dangerous@aol.com'
    @expected.cc  = %w(boss@aol.com vp@aol.com)
    
    DeliverToDeveloper.developer_emails = 'casey@casey.com'
    
    # "send" email
    ActionMailer::Base.deliver(@expected)
    
    assert ActionMailer::Base.deliveries.first.cc.blank?
    assert ActionMailer::Base.deliveries.first.bcc.blank?
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
