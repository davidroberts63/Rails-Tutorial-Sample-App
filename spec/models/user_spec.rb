require 'spec_helper'

describe User do
  before :each do
		@attr = {:name => 'Example User', 
						:email => 'user@example.com',
						:password => 'foobar',
						:password_confirmation => 'foobar'
					}
	end
	
	it "should create a new instance given valid attributes" do
		User.create! @attr
	end
	
	it "should require a name" do
		noNameUser = User.new @attr.merge(:name=>'')
		noNameUser.should_not be_valid
	end
	
	it "should reject names that are too long" do
		long_name = 'a' * 51
		long_name_user = User.new @attr.merge(:name => long_name)
		long_name_user.should_not be_valid
	end
	
	it "should require an email" do
	  no_email_user = User.new @attr.merge(:email=>'')
		no_email_user.should_not be_valid
	end
	
	it "should accept vaild email addresses" do
		addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
		addresses.each do |e|
			valid_user = User.new @attr.merge(:email => e)
			valid_user.should be_valid
		end
	end
	
	it "should reject invalid email addresses" do
		addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
		addresses.each do |e|
			bad_user = User.new @attr.merge(:email => e)
			bad_user.should_not be_valid
		end
	end
	
	it "should reject duplicate email addresses" do
		User.create! @attr
		duplicate = User.new @attr
		duplicate.should_not be_valid
	end
	
	it "should reject duplicate email addresses up to case" do
		uppercase = @attr[:email].upcase
		User.create! @attr.merge(:email => uppercase)
		duplicate = User.new @attr
		duplicate.should_not be_valid
	end
	
	it "should require a password" do
		User.new(@attr.merge(:password => '', :password_confirmation => ''))
			.should_not be_valid
	end
	
	it "should require a matching password confirmation" do
		User.new(@attr.merge(:password_confirmation => 'nomatch'))
			.should_not be_valid
	end
	
	it "should reject short password" do
		User.new(@attr.merge(:password => 'short', :password_confirmation => 'short'))
			.should_not be_valid
	end
	
	it "should reject long password" do
		long = 'a' * 256
		User.new(@attr.merge(:password => long, :password_confirmation => long))
			.should_not be_valid
	end
	
	describe "password encryption" do
		before :each do
			@user = User.create!(@attr)
		end
		
		it "should have an encrypted password attribute" do
	    @user.should respond_to(:encrypted_password)
		end
		
		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
		end
		
		it "should be true if the passwords match" do
			@user.has_password?(@attr[:password]).should be_true
		end
		
		it "should be false if the passwords don't match" do
			@user.has_password?('invalid').should be_false
		end
	end

	describe "authentication" do
		before :each do
			@user = User.create!(@attr)
		end
		
		it "should return nil on email/password mismatch" do
			User.authenticate(@attr[:email],'password123').should be_nil
		end
		
		it "should return nil for an email with no matching user" do
			User.authenticate('nouser',@attr[:password]).should be_nil
		end
		
		it "should return user on email and password match" do
			User.authenticate(@attr[:email], @attr[:password]).should == @user
		end
	end
end
