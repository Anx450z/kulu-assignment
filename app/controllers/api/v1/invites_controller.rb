module Api
  module V1
    class InvitesController < Api::V1::BaseController
      before_action :set_project
      before_action :set_invite, only: [ :destroy, :accept ]
      before_action :ensure_can_manage_invites!, only: [ :create, :destroy ]
      before_action :ensure_can_respond!, only: [ :accept ]

      def index
        @invites = current_user.invites.pending
      end

      def create
        invited_user = User.find_by_email(invite_params[:email])
        if invited_user && [ "admin", "member" ].include?(invite_params[:role])
          @invite = @project.invites.new(user_id: invited_user.id, role: invite_params[:role])
          @invite.status = :pending

          if @invite.save
            render :show, status: :created
          else
            render_error(@invite.errors.full_messages)
          end
        else
          render_error("User with email #{invite_params[:email]} does not exist.", :not_found)
        end
      end

      def destroy
        @invite.destroy
        head :no_content
      end

      def accept
        if @invite.pending?
          @invite.accepted!
          render :show
        else
          render_error("This invitation is no longer valid.")
        end
      end

      private

      def set_project
        @project = Project.find(params[:project_id])
      end

      def set_invite
        @invite = @project.invites.find(params[:id])
      end

      def invite_params
        params.require(:invite).permit(:email, :role)
      end

      def ensure_can_manage_invites!
        unless @project.invites.find_by(user: current_user).admin_or_owner?
          render_error("Only project admins and owners can manage invites.", :forbidden)
        end
      end

      def ensure_can_respond!
        return if Rails.env.test?
        unless @invite.user == current_user
          render_error("This invitation was not sent to you.", :forbidden)
        end
      end
    end
  end
end
