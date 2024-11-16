module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!, :set_default_format!
      protect_from_forgery with: :null_session
      respond_to :json

      def set_default_format!
        request.format = :json
        @camel_case = true if !Rails.env.test?
      end

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
    end
  end
end
