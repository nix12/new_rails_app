require 'rails_helper'

RSpec.describe "AuthenticationPages", type: :request do
  subject { page }

  describe "login page" do
  	before { visit login_path }

  	it { should have_content("Login") }
  	it { should have_title("Login") }
  end

  describe "login" do
  	before { visit login_path }

  	describe "with invalid information" do
  		before { click_button "Login" }

  		it { should have_title("Login") }
  		it { should have_selector("div.alert.alert-danger") }

  		describe "after visiting another page" do
  			before { click_link "Home" }
  			it { should_not have_selector("div.alert.alert-danger") }
  		end
  	end

  	describe "with valid information" do
  		let(:user) { FactoryGirl.create(:user) }
  		before do 
  			fill_in "Email", with: user.email.upcase
  			fill_in "Password", with: user.password
  			click_button "Login"
  		end

  		it { should have_title(user.name) }
      it { should have_link('Users', href: users_path) }
  		it { should have_link('Profile', href: user_path(user)) }
      it { should have_link("Settings", href: edit_user_path(user)) }
  		it { should have_link("Logout"), href: logout_path }
  		it { should_not have_link("Login", href: login_path) }

		  describe 'logout' do
		  	before { click_link "Logout" }

		  	it { should have_link("Login", href: login_path) }
		  	it { should_not have_link("Logout", href: logout_path) }
		  	it { should_not have_link("Profile", href: user_path(user)) }
		  end
  	end
  end

  describe "authorization" do
    
    describe "for non signed in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title("Login") }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to login_path }
        end

        describe "visitng the user index" do
          before { visit users_path }
          it { should have_title('Login') }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { login user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }

        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(login_url) }
      end

      describe "submitting a PATCH request to Users#update action" do
        before { patch user_path(:wrong_user) }

        specify { expect(response).to redirect_to(login_url) }
      end

      describe "when attempting to visit a protected page" do 
      before do
        visit edit_user_path(user)
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Login"
      end

      describe "after logging in" do
        it "should render desired protect page" do
          expect(page).to have_title("Edit user")
        end
      end
    end
    end
  end
end
  