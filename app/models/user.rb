require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  #accessible tells Rails which attributes can be modified by outside users
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true,
                   :length => { :maximum => 50 }
  
  validates :email, :presence => true,
                    :format => {:with => email_regex },
                    :uniqueness => { :case_sensitive => false }
                    
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }
                       
  before_save :encrypt_password
             
    #Determines if a given password matches the saved encrypted password               
    def has_password?(submitted_password)
      encrypted_password == encrypt(submitted_password)
    end
  
  private
  
    #declares how to securely hash a string
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
  
   #create a user's salt by combining a timestamp with the user's password string  
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
  
   #resets and saves a new salt if the user changes their password and the before save callback is calle
    def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end
    
    #performs the one-way encryption of a given string
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
                   
end





# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

