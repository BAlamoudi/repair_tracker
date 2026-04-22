class PagesController < ApplicationController
  #added this
  skip_before_action :authenticate_user!

  def login
  end

  def customer
  end

  def workshop
  end

  def admin
  end
  
end