class SessionsController < Devise::SessionsController

  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end

  private

  def use_https?
    false
  end
end
