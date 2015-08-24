require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = User.new(name: "Example User", email: "user@example.com",
            password: "foobar", password_confirmation: "foobar", admin: false) }
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) } 
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_digest) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }

  it { should be_valid }
  it { should_not be_admin }

  pending "remember_digest" do
    before { @user.save }
    it { expect(subject.remember_digest).not_to be_blank }
  end

  describe "when name is not present" do
  	before { @user.name = " " }
  	it { should_not be_valid }
  end

  describe "when name is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "when a name is to long" do
  	before { @user.name = "a" * 51 }
  	it { should_not be_valid }
  end

  describe "when an email address is already taken" do
  	before do 
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	end

  	it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user = User.new(name: "Example User", email: "user@example.com",
            password: " ", password_confirmation: " ") }
    it { should_not be_valid }
  end

  describe "test for invalid password" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to eq false }
    end
  end

  pending "authenticated? should return false for a user with nil digest" do
    expect(subject.authenticated?("")).to be_false 
  end

  describe "with admin set to 'true'" do
    before do
      @user.save
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end
end
