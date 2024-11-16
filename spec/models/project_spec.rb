require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'associations' do
    it { should have_many(:invites).dependent(:destroy) }
    it { should have_many(:users).through(:invites) }
  end

  describe 'members management' do
    let(:project) { create(:project_with_owner) }
    let(:user) { create(:user) }

    it 'has one owner' do
      expect(project.invites.owner.count).to eq(1)
    end

    it 'can add members' do
      invite = create(:invite, :accepted, project: project, user: user)
      expect(project.users).to include(user)
    end
  end
end
