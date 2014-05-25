class ThankdonorsFormsController < ApplicationController

  def new
    @thankdonors_form = ThankdonorsForm.new
  end

  def create
    begin
      @grant = Grant.find params[:id]
      @payments_by_user = @grant.crowdfunder.payments.group_by(&:user)
      @payments_by_user.keys.each do |u|
        @thankdonors_form = ThankdonorsForm.new(
          :subject => params[:subject], 
          :message => params[:message],
          :to => u.email, 
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
