class UserMailer < ActionMailer::Base
  default from: "notifications@bpsf-staging.herokuapp.com"

  def welcome_email(user)
    @user = user
    @url = 'http://bpsf-staging.herokuapp.com/users/sign_in'
    mail(to: @user.email, subject: 'Thanks for registering with the Schools Fund!')
  end

  def user_pledge(user,grant)
    @user = user
    @grant = grant
    @url = 'http://bpsf-staging.herokuapp.com/grants/' + @grant.id
    mail(to: @user.email, subject: 'Thank you for pledging a donation!')
  end

  def grant_submitted(grant)
    @recipient = Recipient.find(grant.recipient_id)
    @grant = grant
    @url = 'http://bpsf-staging.herokuapp.com/grants/' + @grant.id
    mail(to: @recipient.email, subject: 'Your grant has been submitted!')
  end

  def grant_rejected(grant)
    @recipient = Recipient.find(grant.recipient_id)
    @grant = grant
    mail(to: @recipient.email, subject: 'Your grant has been rejected.')
  end

  def grant_funded(grant)
    @recipient = Recipient.find(grant.recipient_id)
    @grant = grant
    mail(to: @recipient.email, subject: 'Your grant has been funded!')
  end

  def grant_crowdfunding(grant)
    @recipient = Recipient.find(grant.recipient_id)
    @grant = grant
    @url = 'http://bpsf-staging.herokuapp.com/grants/' + @grant.id
    mail(to: @recipient.email, subject: 'Your grant is crowdfunding.')
  end

  def grant_crowdfailed(grant)
    @recipient = Recipient.find(grant.recipient_id)
    @grant = grant
    mail(to: @recipient.email, subject: 'Your grant did not reach its crowdfund goal.')
  end

  def admin_crowdsuccess(grant)
    @recipient = Recipient.find(grant.recipient_id)
    @grant = grant
    @url = 'http://bpsf-staging.herokuapp.com/grants/' + @grant.id
    mail(to: Proc.new {Admin.pluck(:email)}, subject: 'A grant has reached its crowdfund goal!')
  end

  def admin_crowdfailed(grant)
    @recipient = grant.recipient
    @grant = grant
    @url = 'http://bpsf-staging.herokuapp.com/grants/' + @grant.id
    mail(to: Proc.new {Admin.pluck(:email)}, subject: 'A grant has failed to reach its crowdfund goal.') 
  end

end
