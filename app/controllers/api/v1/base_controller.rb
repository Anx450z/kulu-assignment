module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!
      protect_from_forgery with: :null_session
      respond_to :json

      def authenticate_user!
        token_details = AuthenticateTokenService.new(request).call
        if token_details[:success]
          @current_user = token_details[:user]
        else
          render json: {
            error: [
              (token_details[:message] || "Not Authenticated")
            ]
          }, status: :unauthorized
        end
      end

      private

      def render_error(message, status = :unprocessable_entity)
        render json: { error: message }, status: status
      end
    end
  end
end
