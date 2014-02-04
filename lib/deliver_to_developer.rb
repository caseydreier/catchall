class DeliverToDeveloper
  VERSION = '0.1.0'.freeze
  
  cattr_accessor :developer_emails
  
  module InstanceMethods
    
   # Catch any delivery methods that contain the trigger ("to_developer")
   # and deliver it using the catchall method below.
   def method_missing(delivery_method, *args)
     if delivery_method.to_s =~ /\Aperform_delivery_(\w+)to_developer\Z/
       send("perform_delivery_to_developer", *args)
     else
       super
     end
   end
 
   # Redirect any outgoing mail to the developer based on the URL as specified
   # in the class variable, developer_emails.
   # 
   # This method is called when the delivery method is appended with
   # <tt>_to_developer</tt>, such as:
   # 
   #   config.actionmailer.delivery_method = :smtp_to_developer
   def perform_delivery_to_developer(mail)
     begin
       previous_delivery_method = ActionMailer::Base.delivery_method
       
       # Determine the intended delivery method.
       ActionMailer::Base.delivery_method = intended_delivery_method(ActionMailer::Base.delivery_method)
       
       # Set the new email based on the development environment's subdomain #
       mail.to = DeliverToDeveloper.developer_emails
       mail.cc = '' # no cc
       mail.bcc = '' # no bcc
     
       # Now send the mail to the specific user (if no specific user, the entire webteam gets the message) #
       ActionMailer::Base.deliver(mail)
     
       # Reset the delivery method to the original version
       ActionMailer::Base.delivery_method = previous_delivery_method
     
     rescue Exception => e
       # if an exception occurs, record the specific error
       error_info = e.inspect + "\n" + e.message + "\n\t" + e.backtrace.join("\n\t")
       logger.info(error_info)
     end
   
   end

   # Determines the intended delivery method.
   # 
   # Examples:
   #   intended_delivery_method(:smtp_to_developer)     #=> :smtp
   #   intended_delivery_method(:sendmail_to_developer) #=> :sendmail
   def intended_delivery_method(method)
     if method.to_s =~ /\A(\w+)_to_developer\Z/
       method = $1
     end
     method.to_sym
   end
     
  end
end
