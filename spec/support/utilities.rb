include ApplicationHelper

def sign_in(user)
  visit new_user_session_path
  fill_in "user_email",     with: user.email
  fill_in "user_password",  with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.danger', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.success', text: message)
  end
end

RSpec::Matchers.define :have_title do |t|
  match do |page|
    page.should have_selector('title', text: t)
  end
end

RSpec::Matchers.define :have_h1 do |t|
  match do |page|
    page.should have_selector('h1', text: t)
  end
end

RSpec::Matchers.define :have_h2 do |t|
  match do |page|
    page.should have_selector('h2', text: t)
  end
end