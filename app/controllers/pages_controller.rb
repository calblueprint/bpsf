class PagesController < ApplicationController
  def home
    @grants = Grant.all
  end
end
