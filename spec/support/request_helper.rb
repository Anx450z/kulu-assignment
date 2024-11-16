module RequestHelper
  def json_response
    JSON.parse(response.body)
  end

  def valid_headers
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{Token.token_for_user(user)}"
    }
  end
end

RSpec.configure do |config|
  config.include RequestHelper, type: :request
end
