module Api
  module V1
    class TasksController < Api::V1::BaseController
      before_action :set_project, only: [:index, :create, :update]
      before_action :set_task, only: [:show, :update, :destroy]

      def index
        @tasks = @project.tasks
                        .includes(:users)
                        .order(created_at: :desc)
      end

      def show
        @task
      end

      def create
        @task = @project.tasks.build(task_params)
        if @task.save
          @task.users << current_user
          render :show, status: :created
        else
          render json: { errors: @task.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        if @task.update(task_params)
          render :show
        else
          render json: { errors: @task.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        if @task.destroy
          head :no_content
        else
          render json: { errors: @task.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      private

      def set_project
        @project = current_user.projects.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Project not found' }, status: :not_found
      end

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.require(:task).permit(
          :title,
          :description,
          :due_date,
          :completed_at,
          :project_id,
          user_ids: [],
        )
      end
    end
  end
end
