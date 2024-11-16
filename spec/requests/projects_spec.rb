require 'rails_helper'

RSpec.describe 'Api::V1::Projects', type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers } # You'll need to define this in spec/support

  describe 'GET /api/v1/projects' do
    before do
      create_list(:project_with_members, 3)
      create(:invite, :accepted, user: user, project: Project.first)
    end

    it 'returns user projects' do
      get api_v1_projects_path, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response['projects'].length).to eq(1)
    end
  end

  describe 'POST /api/v1/projects' do
    let(:valid_params) { { project: { title: 'New Project', description: 'Description' } } }

    it 'creates a new project' do
      expect {
        post api_v1_projects_path, params: valid_params.to_json, headers: headers
      }.to change(Project, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json_response['title']).to eq('New Project')
    end

    it 'creates an owner invite for the current user' do
      post api_v1_projects_path, params: valid_params.to_json, headers: headers
      project = Project.last
      expect(project.invites.owner.first.user).to eq(user)
    end
  end

  describe 'PUT /api/v1/projects/:id' do
    let(:project) { create(:project_with_owner, owner: user) }
    let(:update_params) { { project: { title: "Updated Title" } } }

    it 'updates the project' do
      put api_v1_project_path(project), params: update_params.to_json, headers: headers
      expect(response).to have_http_status(:ok)
      expect(project.reload.title).to eq('Updated Title')
    end
  end
end
