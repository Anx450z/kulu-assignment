class AuthenticateTokenService
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def call
    begin
      raise "Not Authenticated" if !user_id_in_token?
      validate_token
      get_response(true)
    rescue JWT::VerificationError, JWT::DecodeError, ActiveRecord::RecordNotFound
      get_response(false, "Not Authenticated")
    rescue => msg
      get_response(false, msg)
    end
  end

  private

  def get_response(success, message = nil)
    if success
      user = token.user
    else
      user = nil
    end
    {
      success: success,
      message: message,
      user:    user
    }
  end

  def token
    @token ||= Token.active.where(content: http_token, user_id: auth_token[:user_id]).last
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end

  def http_token
    @http_token ||= if request.headers["Authorization"].present?
                      request.headers["Authorization"].split(" ").last
    end
  end

  def auth_token
    @auth_token ||= decode_token
  end

  def decode_token
    JsonWebToken.decode(http_token)
  end

  def validate_token
    if !token
      raise "Invalid token"
    end
  end
end
