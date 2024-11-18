require 'rails_helper'

RSpec.describe "Api::V1::Tasks", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, owner: user) }
  let(:task) { create(:task, project: project, users: [user]) }
  let(:other_user) { create(:user) }
  let(:headers) { valid_headers }

  before do
    project.users << user
  end

  describe 'GET /api/v1/projects/:project_id/tasks' do
    before { allow(controller).to receive(:current_user).and_return(user) }
    context 'when user has access to the project' do
      before do
        create_list(:task, 3, project: project, users: [user])
        get api_v1_project_tasks_path(project), headers: headers
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all tasks for the project' do
        expect(json_response['tasks'].size).to eq(3)
      end

      it 'returns tasks with correct structure' do
        expect(json_response['tasks'].first).to include(
          'id',
          'title',
          'description',
          'completed_at',
          'due_date',
          'users'
        )
      end
    end

    context 'when user does not have access to the project' do
      let(:other_project) { create(:project) }

      before do
        get api_v1_project_tasks_path(other_project), headers: headers
      end

      it 'returns http not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    before { allow(controller).to receive(:current_user).and_return(user) }
    context 'when accessing own task' do
      before do
        get  api_v1_task_path(task), headers: headers
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the correct task' do
        expect(json_response['task']['id']).to eq(task.id)
      end

      it 'includes task details' do
        expect(json_response['task']).to include(
          'title' => task.title,
          'description' => task.description
        )
      end
    end
  end

  describe 'PATCH /api/v1/projects/:project_id/tasks/:id' do
    before { allow(controller).to receive(:current_user).and_return(user) }
    let(:update_attributes) do
      {
        task: {
          title: 'Updated Title',
          description: 'Updated Description'
        }
      }
    end

    context 'when updating own task' do
      before do
        patch api_v1_project_task_path(project, task),
              params: update_attributes.to_json,
              headers: headers
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'updates the task' do
        expect(json_response['task']['title']).to eq('Updated Title')
        expect(json_response['task']['description']).to eq('Updated Description')
      end
    end
  end

  describe 'DELETE /api/v1/tasks/:id' do
    before { allow(controller).to receive(:current_user).and_return(user) }
    let(:invite) { create(:invite, project: project, user: user) }

    context 'when deleting own task' do
      it 'returns http no content' do
        delete api_v1_task_path(task), headers: headers
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe 'completing a task' do
    before { allow(controller).to receive(:current_user).and_return(user) }
    let(:completion_attributes) do
      {
        task: {
          completed_at: Time.current
        }
      }
    end

    before do
      patch api_v1_project_task_path(project, task),
            params: completion_attributes.to_json,
            headers: headers
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'marks the task as completed' do
      expect(json_response['task']['completed']).to be true
    end
  end

  describe 'error handling' do
    before { allow(controller).to receive(:current_user).and_return(user) }
    context 'when project does not exist' do
      before do
        get api_v1_project_tasks_path(0), headers: headers
      end

      it 'returns http not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(json_response['error']).to eq('Project not found')
      end
    end
  end
end
