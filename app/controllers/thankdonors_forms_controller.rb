class ThankdonorsFormsController < ApplicationController

  def new
    @thankdonors_form = ThankdonorsForm.new(p.email)
  end

  def create
    begin
      @thankdonors_form = ThankdonorsForm.new(params[:thankdonors_form])
      @thankdonors_form.request = request
      if @thankdonors_form.deliver
        flash.now[:notice] = 'Your email to thank the donors has been sent!'
      else
        render :new
      end
    rescue ScriptError
      flash[:error] = 'Sorry, this email was not delivered.'
    end
  end
end
