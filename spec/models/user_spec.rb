require 'spec_helper'

describe User do
  it "should create a new instance given a valid attribute" do
    create(:user)
  end

  it "should require an email address" do
    build(:user, email: '').should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      build(:user, email: address).should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      build(:user, email: address).should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    user = create(:user)
    build(:user, email: user.email).should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    user = create(:user)
    build(:user, email: user.email.upcase).should_not be_valid
  end

  describe "passwords" do
    subject { build(:user) }

    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }

  end

  it "should have a name" do
    build(:user).should respond_to :name
  end

  describe "password validations" do

    it "should require a password" do
      build(:user, password: "", password_confirmation: "").should_not be_valid
    end

    it "should require a matching password confirmation" do
      build(:user, password_confirmation: "invalid").should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      build(:user, password: short, password_confirmation: short).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = create(:user)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end

end
