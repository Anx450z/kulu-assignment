require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { create(:user) }
  let(:project) { build(:project, owner_id: user.id) }

  describe 'Associations' do
    it { is_expected.to have_many(:users) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
  end
end
