class Token < ApplicationRecord
  belongs_to :user

  validates_presence_of :user, :content

  default_scope { order(created_at: :desc) }

  enum active_status: { active: 0, inactive: 1 }

  def self.token_for_user(user)
    last_token = user.tokens.active.first
    if last_token.present? && (Time.now - last_token.created_at) < 2.seconds
      token_value = last_token.content
    else
      data = {
        user_id: user.id,
        generated_at: Time.now,
        random: SecureRandom.base64
      }

      token_value = JsonWebToken.encode(data)
      user.tokens.create(content: token_value)
    end
    token_value
  end

  def self.invalidate_token_for_user(user, input_token)
    tokens = user.tokens.where(content: input_token)
    tokens.update_all(active_status: "inactive", updated_at: Time.now)
  end

  def self.invalidate_all_tokens_for_user(user)
    user.tokens.active.update_all(active_status: "inactive")
  end
end
