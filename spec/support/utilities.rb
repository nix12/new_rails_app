include ApplicationHelper
def login(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.

    remember_token = User.new_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_digest, User.digest(remember_token))
  else
    visit login_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Login"
  end
end