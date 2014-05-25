class ThankdonorsFormsController < ApplicationController

  def new
    @thankdonors_form = ThankdonorsForm.new
  end

  def create
    begin
      @grant = Grant.find params[:id]
      @grant.crowdfunder.payments.each do |p|
        @user = User.find(p.user_id)
        @thankdonors_form = ThankdonorsForm.new(
          :subject => params[:subject], 
          :message => params[:message],
          :to => @user.email, 
          :from => @grant.recipient.email, 
          :recipient => @grant.recipient.name)
        @thankdonors_form.request = request
        ThankDonorsJob.new.async.perform(@thankdonors_form)
      end
      flash.now[:notice] = 'Your email to thank the donors has been sent!'
    rescue Exception
      flash.now[:error] = 'Something went wrong.'
    end
  end
end
