class UserMailer < ActionMailer::Base
  default from: "notifications@schoolsfund-friendsandfamily.herokuapp.com"

  def welcome_email(user)
    @user = user
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/users/sign_in'
    mail(to: @user.email, subject: 'Thanks for registering with the Schools Fund!')
  end

  def welcome_admin(user)
    @user = user
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/users/sign_in'
    mail(to: @user.email, subject: 'Thanks for registering with the Schools Fund!')
  end

  def approve_admin(user)
    @user = user
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/users/sign_in'
    mail(to: @user.email, subject: 'Your account with the Schools Fund has been approved!')
  end

  def goal_met(grant, admin)
    @grant = grant
    @admin = admin
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @admin.email, subject: "A grant has reached its crowdfund goal!")
  end

  def user_pledge(user,grant,payment)
    @user = user
    @grant = grant
    @amount = payment.amount
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @user.email, subject: 'Thank you for pledging a donation!')
  end

  def user_crowdsuccess(user,grant)
    @user = user
    @grant = grant
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @user.email, subject: 'A grant you donated to has been successfully crowdfunded!')
  end

  def user_crowdfailed(user,grant)
    @user = user
    @grant = grant
    mail(to: @user.email, subject: 'A grant you donated to has not met its goal and your card will not be charged')
  end

  def grant_submitted(grant)
    @grant = grant
    @recipient = @grant.recipient
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/grants/' + (@grant.id).to_s
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
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/grants/' + (@grant.id).to_s
    @subject = 'Your grant has been approved for crowdfunding by the Schools Fund.'
    mail(to: @recipient.email, subject: @subject)
  end

  def grant_ending(grant)
    @grant = grant
    @recipient = @grant.recipient
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @recipient.email, subject: 'Your grant is reaching its deadline.')
  end

  def grant_crowdfailed(grant)
    @grant = grant
    @recipient = @grant.recipient
    mail(to: @recipient.email, subject: 'Your grant did not reach its crowdfund goal.')
  end

  def donor_nearend(grant, user)
    @grant = grant
    @user = user
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @user.email, subject: 'A grant you have donated to is at 80% completion!')
  end

  def admin_grantsubmitted(grant, admin)
    @grant = grant
    @recipient = @grant.recipient
    @admin = admin
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @admin.email, subject: 'A grant has just been submitted for review.')
  end

  def super_crowdending(grant, admin)
    @grant = grant
    @recipient = @grant.recipient
    @admin = admin
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @admin.email, subject: 'A grant is reaching its deadline.')
  end

  def admin_crowdsuccess(grant, admin)
    @grant = grant
    @recipient = @grant.recipient
    @admin = admin
    @recprof = @recipient.profile
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @admin.email, subject: 'A grant has been successfully funded!')
  end

  def admin_crowdfailed(grant, admin)
    @grant = grant
    @recipient = @grant.recipient
    @admin = admin
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/grants/' + (@grant.id).to_s
    mail(to: @admin.email, subject: 'A grant has failed to reach its crowdfund goal.')
  end

  def admin_newuser(user,admin)
    @user = user
    @admin = admin
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/user/' + (@user.id).to_s
    mail(to: @admin.email, subject: 'A new user has registered an account!')
  end

  def admin_newadmin(user,admin)
    @user = user
    @admin = admin
    @url = 'http://schoolsfund-friendsandfamily.herokuapp.com/admin'
    mail(to: @admin.email, subject: 'A new administrator account needs your approval')
  end

  def weekly_digest(user,grants)
    @user = user
    @grants = grants
    mail(to: @user.email, subject: 'Your weekly digest for the Schools Fund Friends and Family Grant Portal')
  end
end
