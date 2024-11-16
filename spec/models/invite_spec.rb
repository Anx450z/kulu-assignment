require 'rails_helper'

RSpec.describe Invite, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:role) }

    it 'validates uniqueness of user per project' do
      invite = create(:invite)
      duplicate_invite = build(:invite, project: invite.project, user: invite.user)
      expect(duplicate_invite).not_to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
  end

  describe 'scopes' do
    let!(:pending_invite) { create(:invite, status: :pending) }
    let!(:accepted_invite) { create(:invite, :accepted) }

    it 'filters pending invites' do
      expect(Invite.pending).to include(pending_invite)
    end

    it 'filters accepted invites' do
      expect(Invite.accepted).to include(accepted_invite)
    end
  end
end
