require 'rails_helper'

RSpec.describe 'Api::V1::Invites', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project_with_owner, owner: user) }
  let(:headers) { valid_headers }

  describe 'GET /api/v1/projects/:project_id/invites' do
    let(:user2) { create(:user) }
    let!(:invites) do
      projects = create_list(:project_with_owner, 3, owner: user2)
      projects.map { |proj| create(:invite, project: proj, user: user) }
    end

    it 'returns project invites' do
      get api_v1_project_invites_path(project), headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response['invites'].length).to eq(3)
    end
  end

  describe 'POST /api/v1/projects/:project_id/invites' do
    let(:new_user) { create(:user) }
    let(:valid_params) { { invite: { email: new_user.email, role: 'member' } } }

    it 'creates a new invite' do
      expect {
        post api_v1_project_invites_path(project),
             params: valid_params.to_json,
             headers: headers
      }.to change(Invite, :count).by(2)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'POST /api/v1/projects/:project_id/invites' do
    let(:new_user) { create(:user) }
    let(:valid_params) { { invite: { email: new_user.email, role: 'owner' } } }

    it 'does not creates a new invite' do
      post api_v1_project_invites_path(project), params: valid_params.to_json, headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/projects/:project_id/invites/:id/accept' do
    let(:user2) { create(:user) }
    let(:invite) { create(:invite, project: project, user: user2) }
    it 'accepts the invite' do
      post accept_api_v1_project_invite_path(project, invite), headers: headers
      expect(response).to have_http_status(:ok)
      expect(invite.reload).to be_accepted
    end
  end
end
