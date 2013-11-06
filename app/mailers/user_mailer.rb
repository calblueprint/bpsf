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
    @url = 'http://bpsf-staging.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @user.email, subject: 'Thank you for pledging a donation!')
  end

  def user_crowdsuccess(user,grant)
    @user = user
    @grant = grant
    mail(to: @user.email, subject: 'A grant you donated to has been successfully crowdfunded!')
  end

  def grant_submitted(grant)
    @grant = grant
    @recipient = @grant.recipient
    @url = 'http://bpsf-staging.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @recipient.email, subject: 'Your grant has been submitted!')
  end

  def grant_rejected(grant)
    @grant = grant
    @recipient = @grant.recipient
    mail(to: @recipient.email, subject: 'Your grant has been rejected.')
  end

  def grant_funded(grant)
    @grant = grant
    @recipient = @grant.recipient
    mail(to: @recipient.email, subject: 'Your grant has been funded!')
  end

  def grant_crowdfunding(grant)
    @grant = grant
    @recipient = @grant.recipient
    @url = 'http://bpsf-staging.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @recipient.email, subject: 'Your grant is crowdfunding.')
  end

  def grant_crowdfailed(grant)
    @grant = grant
    @recipient = @grant.recipient
    mail(to: @recipient.email, subject: 'Your grant did not reach its crowdfund goal.')
  end

  def admin_grantsubmitted(grant, admin)
    @grant = grant
    @recipient = @grant.recipient
    @admin = admin
    @url = 'http://bpsf-staging.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @admin.email, subject: 'A grant has just been submitted for review.')
  end

  def admin_crowdsuccess(grant, admin)
    @grant = grant
    @recipient = @grant.recipient
    @admin = admin
    @url = 'http://bpsf-staging.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @admin.email, subject: 'A grant has reached its crowdfund goal!')
  end

  def admin_crowdfailed(grant, admin)
    @grant = grant
    @recipient = @grant.recipient
    @admin = admin
    @url = 'http://bpsf-staging.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @admin.email, subject: 'A grant has failed to reach its crowdfund goal.') 
  end

end
