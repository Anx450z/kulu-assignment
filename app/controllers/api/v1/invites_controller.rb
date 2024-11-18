module Api
  module V1
    class InvitesController < Api::V1::BaseController
      before_action :set_project, except: %i[ index accept destroy ]
      before_action :set_invite, only: [ :destroy, :accept ]
      before_action :ensure_can_manage_invites!, only: [ :create ]
      before_action :ensure_can_respond!, only: [ :accept ]
      before_action :set_user, only: [ :accept ]

      def index
        @invites = Invite.where(email: current_user.email).pending
      end

      def create
        if [ "admin", "member" ].include?(invite_params[:role])
          @invite = current_user.invites.new(invite_params)
          @invite.status = :pending

          if @invite.save
            render :show, status: :created
          else
            render_error(@invite.errors.full_messages)
          end
        else
          render_error("Invalid role", :forbidden)
        end
      end

      def destroy
        @invite.destroy
        head :no_content
      end

      def accept
        if @invite.pending?
          @invite.accepted!
          @invite.project.users << @user
          render :show, status: :ok
        else
          render_error("This invitation is no longer valid.", :unprocessable_entity)
        end
      end

      private

      def set_project
        @project = Project.find(params[:project_id])
      end

      def set_invite
        @invite = Invite.find(params[:id])
      end

      def set_user
        @user = User.find_by(email: @invite.email)
      end

      def invite_params
        params.require(:invite).permit(:email, :role, :project_id)
      end

      def ensure_can_manage_invites!
        unless @project.owner?(current_user) || @project.invites.find_by(email: params[:email]).admin?
          render_error("Only project admins and owners can manage invites.", :forbidden)
        end
      end

      def ensure_can_respond!
        unless @invite.email == current_user.email
          render_error("This invitation was not sent to you.", :forbidden)
        end
      end
    end
  end
end
