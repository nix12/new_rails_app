require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  subject { page }

  describe "Home page" do 
    before { visit root_path }

  	it { should have_title("Ruby on Rails Tutorial Sample App") }
	  it { should_not have_title("Home") }
	  it { should have_content("Sample App") }
  end

  describe "Help page" do
    before { visit help_path } 
  	
    it { should have_title("Help | Ruby on Rails Tutorial Sample App") }
  	it { should have_content("Help") }
  end

  describe "About page" do
    before { visit about_path }

  	it { should have_title("About | Ruby on Rails Tutorial Sample App") }
  	it { should have_content("About") }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { expect(page).to have_title("Contact | Ruby on Rails Tutorial Sample App") }
    it { expect(page).to have_title("Contact") }
  end
end