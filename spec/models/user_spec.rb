require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is not valid without parameters' do
    expect(User.new).to_not be_valid
  end

  describe '.from_omniauth' do
    let(:auth_hash) do
      double(
        info: {
          'email' => 'test@example.com'
        }
      )
    end

    context 'when user exists' do
      let!(:existing_user) { create(:user, email: 'test@example.com') }

      it 'returns existing user' do
        user = described_class.from_omniauth(auth_hash)
        expect(user).to eq(existing_user)
      end
    end

    context 'when user does not exist' do
      it 'creates new user' do
        expect {
          described_class.from_omniauth(auth_hash)
        }.to change(User, :count).by(1)
      end

      it 'sets correct email' do
        user = described_class.from_omniauth(auth_hash)
        expect(user.email).to eq('test@example.com')
      end

      it 'sets random password' do
        allow(Devise).to receive(:friendly_token).and_return('random_token')
        user = described_class.from_omniauth(auth_hash)
        expect(user.password).to eq('random_token')
      end
    end
  end

  describe 'omniauth configuration' do
    it 'includes google_oauth2 as provider' do
      expect(User.omniauth_providers).to include(:google_oauth2)
    end
  end
end
