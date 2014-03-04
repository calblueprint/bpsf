require "spec_helper"

describe UserMailer do
  describe 'welcome email' do
    let(:user) { mock_model(User, :first_name => 'Test', :email => 'test@email.com') }
    let(:mail) { UserMailer.welcome_email(user) }

    it 'renders the subject' do
      mail.subject.should == 'Thanks for registering with the Schools Fund!'
    end

    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end

    it 'renders the sender email' do
      mail.from.should == ['notifications@schoolsfund-friendsandfamily.herokuapp.com']
    end

    it 'assigns first name' do
      mail.body.encoded.should match(user.first_name)
    end

    it 'assigns sign-in url' do
      mail.body.encoded.should match("http://schoolsfund-friendsandfamily.herokuapp.com/users/sign_in")
    end
  end
end
