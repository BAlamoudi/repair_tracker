class Auth::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      message: 'Logged in successfully',
      #to take the token
      token: request.env['warden-jwt_auth.token'],
      user: {
        id: resource.id,
        email: resource.email,
        role: resource.role
      }
    }
  end

  def respond_to_on_destroy(*args)
    render json: { message: 'Logged out successfully' }
  end
end