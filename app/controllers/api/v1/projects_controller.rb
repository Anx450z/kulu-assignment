module Api
  module V1
    class ProjectsController < Api::V1::BaseController
      before_action :set_project, only: [ :show, :update, :destroy ]
      before_action :ensure_owner!, only: [ :update, :destroy ]

      def index
        @projects = current_user.projects.includes(:invites)
      end

      def show
        @members = @project.invites.includes(:user).accepted
        @pending_invites = @project.invites.includes(:user).pending
      end

      def create
        @project = Project.new(project_params)

        if @project.save
          @project.invites.create!(
            user: current_user,
            role: :owner,
            status: :accepted
          )
          render :show, status: :created
        else
          render_error(@project.errors.full_messages)
        end
      end

      def update
        if @project.update(project_params)
          render :show
        else
          render_error(@project.errors.full_messages)
        end
      end

      def destroy
        @project.destroy
        head :no_content
      end

      private

      def set_project
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(:title, :description)
      end

      def ensure_owner!
        unless @project.invites.owner.exists?(user: current_user)
          render_error("Only project owners can perform this action.", :forbidden)
        end
      end
    end
  end
end
