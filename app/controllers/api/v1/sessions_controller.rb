module Api
  module V1
    class SessionsController < Api::V1::BaseController
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
    end
  end
end
