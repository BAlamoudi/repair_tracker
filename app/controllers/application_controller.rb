class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session


  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render json: { error: 'Record not found' }, status: :not_found
  end
end