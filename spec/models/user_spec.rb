require 'spec_helper'



describe User do

  before(:each) do
    @attr = { :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid e-mail addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end 

    it "should reject duplicate email addresses" do
    #put a user with given email address into the database
      User.create!(@attr)
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end

    it "should reject email addresses identical up to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end

describe "password validations" do

    #test the PRESENCE, LENGTH, and CONFIRMATION of passwords:

      it "should require a password" do
        User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
      end

      it "should require a matching password confirmation" do
        User.new(@attr.merge(:password_confirmation => "")).should_not be_valid
      end

      it "should reject short passwords" do
        User.new(@attr.merge(:password => "12345")).should_not be_valid
      end

      it "should reject long passwords" do
        short = "a" * 41
        User.new(@attr.merge(:password => short)).should_not be_valid
      end
    end

describe "password encryption" do

      before(:each) do
        @user = User.create!(@attr)
      end

      it "should have an encrypted password attribute" do
        @user.should respond_to(:encrypted_password)
      end

      it "should not have a blank encrypted password" do
      @user.encrypted_password.should_not be_blank
      end
 end

end

#with Rspec:
#just adding 'it "something"' assumes the call to the pending method

#no_name_user.should_not be_valid is Rspec for:
#no_name_user.valid?.should_not == true

# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
