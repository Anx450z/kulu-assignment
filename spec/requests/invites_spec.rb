require 'rails_helper'

RSpec.describe 'Api::V1::Invites', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, owner: user) }
  let(:headers) { valid_headers }

  describe 'GET /api/v1/projects/:project_id/invites' do
    let(:user2) { create(:user) }
    let!(:invites) do
      projects = create_list(:project, 3, owner: user2)
      projects.map { |proj| create(:invite, project: proj, user: user2, email: user.email) }
    end

    it 'returns pending invites for the current user' do
      get api_v1_invites_path, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response['invites']).to all(include('status' => 'pending'))
    end
  end

  describe 'POST /api/v1/projects/:project_id/invites' do
    context 'with valid parameters' do
      let(:new_user) { create(:user) }
      let(:valid_params) { { invite: { email: new_user.email, role: 'member', project_id: project.id } } }

      it 'creates a new invite' do
        expect {
          post api_v1_project_invites_path(project),
               params: valid_params.to_json,
               headers: headers
        }.to change(Invite, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(Invite.last.email).to eq(new_user.email)
      end
    end

    context 'with invalid role' do
      let(:invalid_params) { { invite: { email: 'invalidrole@example.com', role: 'invalid', project_id: project.id } } }

      it 'returns a forbidden error' do
        post api_v1_project_invites_path(project), params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:forbidden)
        expect(json_response['error']).to eq('Invalid role')
      end
    end

    context 'with duplicate email for the same project' do
      let!(:existing_invite) { create(:invite, email: 'duplicate@example.com', project_id: project.id) }
      let(:duplicate_params) { { invite: { email: 'duplicate@example.com', role: 'member', project_id: project.id } } }

      it 'returns an error for duplicate email within the project' do
        post api_v1_project_invites_path(project), params: duplicate_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to include('Email is already invited to this project')
      end
    end
  end

  describe 'DELETE /api/v1/projects/:project_id/invites/:id' do
    let!(:invite) { create(:invite, project_id: project.id, user: user, email: 'todelete@example.com') }

    it 'destroys the invite' do
      expect {
        delete "/api/v1/projects/#{project.id}/invites/#{invite.id}", headers: headers
      }.to change(Invite, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'POST /api/v1/projects/:project_id/invites/:id/accept' do
    let(:invitee) { create(:user) }
    let!(:invite) { create(:invite, project_id: project.id, user: invitee, email: invitee.email, status: 'pending') }
    let(:invite_headers) do
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{Token.token_for_user(invitee)}"
      }
    end

    it 'accepts the invite' do
      post accept_api_v1_project_invite_path(project, invite), headers: invite_headers
      expect(response).to have_http_status(:ok)
      expect(invite.reload.status).to eq('accepted')
      expect(project.reload.users).to include(invitee)
    end

    context 'when the invite is already accepted' do
      before { invite.update!(status: 'accepted') }

      it 'returns an error' do
        post accept_api_v1_project_invite_path(project, invite), headers: invite_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq('This invitation is no longer valid.')
      end
    end
  end
end
