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
        @invite = @project.invites.new(invite_params)
        @invite.status = :pending

        if @invite.save
          # You might want to send an email notification here
          render :show, status: :created
        else
          render_error(@invite.errors.full_messages)
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
        params.require(:invite).permit(:user_id, :role)
      end

      def ensure_can_manage_invites!
        unless @project.invites.where(user: current_user).admin_or_owner.exists?
          render_error("Only project admins and owners can manage invites.", :forbidden)
        end
      end

      def ensure_can_respond!
        unless @invite.user == current_user
          render_error("This invitation was not sent to you.", :forbidden)
        end
      end
    end
  end
end
