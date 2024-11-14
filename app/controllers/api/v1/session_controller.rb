class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: %i[create]

  # def create
  #   @user = User.find_by(email: login_params[:email]&.downcase)
  #   if @user && @user.valid_password?(login_params[:password])
  #     @token = Token.token_for_user(@user)
  #     @current_user = @user
  #     @message = 'Login Successful.'
  #   else
  #     render json: {
  #       success: false,
  #       error: "Signin unsuccessful. Invalid Email or Password"
  #     }, status: :bad_request
  #   end
  # end

  def destroy
    if Token.invalidate_token_for_user(current_user, http_token)
      render json: {
        success: true,
        message: "Logout was Successful."
      }, status: :ok
    else
      render json: {
        success: false,
        error: "Invalid request"
      }, status: :bad_request
    end
  end

  private

  def http_token
    @http_token ||= if request.headers["Authorization"].present?
                      request.headers["Authorization"].split(" ").last
    end
  end

  def login_params
    params.require(:login).permit(:email, :password)
  end
end
