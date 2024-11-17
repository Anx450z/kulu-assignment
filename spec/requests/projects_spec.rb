require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :request do
  let(:owner) { create(:user) }
  let(:user) { create(:user) }
  let!(:project) { create(:project, owner: owner) }
  let(:headers) { valid_headers }

  describe "GET /api/v1/projects" do
    before { project.users << user }

    it "returns a list of projects for the current user" do
      get "/api/v1/projects", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(1)
    end
  end

  describe "GET /api/v1/projects/:id" do
    it "returns the project details" do
      get "/api/v1/projects/#{project.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(project.id)
    end

    it "returns 404 if the project is not found" do
      get "/api/v1/projects/99999", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/projects" do
    let(:user) { create(:user) }
    let(:valid_params) { { project: { title: "New Project", description: "Project description" } } }
    let(:invalid_params) { { project: { title: "" } } }
    before { allow(controller).to receive(:current_user).and_return(user) }
    it "creates a project successfully" do
      expect {
        post "/api/v1/projects", params: valid_params.to_json, headers: headers
      }.to change(Project, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_response["title"]).to eq("New Project")
    end

    it "returns an error when parameters are invalid" do
      post "/api/v1/projects", params: invalid_params.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response["error"]).to include("Title can't be blank")
    end
  end

  describe "PUT /api/v1/projects/:id" do
    let(:valid_params) { { project: { title: "Updated Title" } } }
    let(:project) { create(:project, owner: user) }
    context "when the user is the owner" do
      before { allow(controller).to receive(:current_user).and_return(user) }
      it "updates the project successfully" do
        put "/api/v1/projects/#{project.id}", params: valid_params.to_json, headers: headers
        expect(response).to have_http_status(:ok)
        expect(json_response["title"]).to eq("Updated Title")
      end
    end

    context "when the user is not the owner" do
      let(:project) { create(:project, owner: owner) }
      before { allow(controller).to receive(:current_user).and_return(user) }
      it "returns a forbidden error" do
        put "/api/v1/projects/#{project.id}", params: valid_params.to_json, headers: headers
        expect(response).to have_http_status(:forbidden)
        expect(json_response["error"]).to include("Only project owners can perform this action.")
      end
    end
  end

  describe "DELETE /api/v1/projects/:id" do
    let(:project) { create(:project, owner: user) }
    context "when the user is the owner" do
      before { allow(controller).to receive(:current_user).and_return(user) }
      it "deletes the project successfully" do
        expect {
          delete "/api/v1/projects/#{project.id}", headers: headers
        }.to change(Project, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the user is not the owner" do
      let(:project) { create(:project, owner: owner) }
      before { allow(controller).to receive(:current_user).and_return(user) }
      it "returns a forbidden error" do
        delete "/api/v1/projects/#{project.id}", headers: headers
        expect(response).to have_http_status(:forbidden)
        expect(json_response["error"]).to include("Only project owners can perform this action.")
      end
    end
  end
end
