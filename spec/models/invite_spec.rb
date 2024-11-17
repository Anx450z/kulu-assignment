require 'rails_helper'

RSpec.describe Invite, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  subject do
    described_class.new(
      user: user,
      status: "pending",
      role: "member",
      email: "test@example.com",
      project_id: project.id
    )
  end

  describe 'Enums' do
    it { is_expected.to define_enum_for(:status).with_values(pending: 0, accepted: 1) }
    it { is_expected.to define_enum_for(:role).with_values(member: 0, admin: 1) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:role) }
    it do
      is_expected.to validate_uniqueness_of(:email)
        .scoped_to(:project_id)
        .with_message("is already invited to this project")
    end

    it 'does not allow duplicate invites for the same project and email' do
      invite = create(:invite, email: "test@example.com", project_id: project.id)
      duplicate_invite = build(:invite, email: "test@example.com", project_id: project.id)
      expect(duplicate_invite).not_to be_valid
      expect(duplicate_invite.errors[:email]).to include("is already invited to this project")
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Scopes' do
    let!(:pending_invite) { create(:invite, project_id: project.id, user: user, status: :pending) }
    let!(:accepted_invite) { create(:invite, status: :accepted) }

    it 'returns only pending invites' do
      expect(Invite.pending).to include(pending_invite)
      expect(Invite.pending).not_to include(accepted_invite)
    end

    it 'returns only accepted invites' do
      expect(Invite.accepted).to include(accepted_invite)
      expect(Invite.accepted).not_to include(pending_invite)
    end
  end
end
