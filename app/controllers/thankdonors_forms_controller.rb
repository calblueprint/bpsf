class ThankdonorsFormsController < ApplicationController

  def new
    @thankdonors_form = ThankdonorsForm.new
  end

  def create
    if !params[:thankdonors_form][:subject].blank? && !params[:thankdonors_form][:message].blank?
      @grant = Grant.find params[:id]
      @payments_by_user = @grant.crowdfunder.payments.group_by(&:user)
      @payments_by_user.keys.each do |u|
        @thankdonors_form = ThankdonorsForm.new(
          subject: params[:thankdonors_form][:subject],
          message: params[:thankdonors_form][:message],
          to: u.email,
          from: @grant.recipient.email,
          recipient: @grant.recipient.name)
        @thankdonors_form.request = request
        ThankDonorsJob.new.async.perform(@thankdonors_form)
      end
      flash.now[:notice] = 'Your email to thank the donors has been sent!'
    else
      flash.now[:error] = 'Please fill out both subject and message fields.'
      render :new, id: params[:id]
    end
  end
end
