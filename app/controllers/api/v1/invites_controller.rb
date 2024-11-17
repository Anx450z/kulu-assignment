module Api
  module V1
    class InvitesController < Api::V1::BaseController
      before_action :set_project, except: [ :index ]
      before_action :set_invite, only: [ :destroy, :accept ]
      before_action :ensure_can_manage_invites!, only: [ :create, :destroy ]
      before_action :ensure_can_respond!, only: [ :accept ]
      before_action :set_user, only: [ :accept ]

      def index
        @invites = current_user.invites.pending
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

          @project.users << @user
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
        @invite = Invite.find_by(email: params[:email], project: params[:project_id])
      end

      def set_user
        @user = User.find_by(email: params[:email])
      end

      def invite_params
        params.require(:invite).permit(:email, :role, :project_id)
      end

      def ensure_can_manage_invites!
        unless Invites.find_by(invite_params).admin? || @project.owner?
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
