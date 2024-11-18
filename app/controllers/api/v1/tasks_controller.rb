module Api
  module V1
    class TasksController < Api::V1::BaseController
      before_action :authenticate_user!
      before_action :set_project, only: [:index, :create, :update]
      before_action :set_task, only: [:show, :update, :destroy]
      before_action :authorize_task_access!, only: [:show, :update, :destroy]

      def index
        @tasks = @project.tasks
                        .includes(:users)
                        .order(created_at: :desc)
      end

      def show
      end

      def create
        @task = @project.tasks.build(task_params)

        if @task.save
          @task.users << current_user unless @task.users.include?(current_user)
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
        @task = if params[:project_id]
                  @project.tasks.find(params[:id])
                else
                  Task.joins(:users)
                      .where(users: { id: current_user.id })
                      .find(params[:id])
                end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Task not found' }, status: :not_found
      end

      def authorize_task_access!
        unless @task.users.include?(current_user)
          render json: { error: 'Unauthorized access' }, status: :forbidden
        end
      end

      def task_params
        params.require(:task).permit(
          :title,
          :description,
          :due_date,
          :completed_at,
          user_ids: []
        )
      end
    end
