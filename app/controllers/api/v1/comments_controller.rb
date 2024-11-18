module Api
  module V1
    class CommentsController < Api::V1::BaseController
      before_action :set_task , only: [:create, :update]
      before_action :set_comment, only: [:show, :update, :destroy, :like]

      def index
        @comments = @task.comments.limit(25)
      end

      def show
        @comment
      end

      def create
        @comment = @task.comments.build(comment_params.merge(user: current_user))
        if @comment.save
          render :show, status: :created
        else
          render_error(@comment.errors.full_messages)
        end
      end

      def update
        if @comment.update(comment_params)
          render :show
        else
          render_error(@comment.errors.full_messages)
        end
      end

      def destroy
        if @comment.user != current_user
          render_error("You are not authorized to delete this comment", :forbidden)
        end
        @comment.destroy
        head :no_content
      end

      def like
        @comment.update_likes!(current_user)
      end

      private

      def set_task
        @task = Task.find(params[:task_id])
      end

      def set_comment
        @comment = @task.comments.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:body, :task_id)
      end
    end
  end
