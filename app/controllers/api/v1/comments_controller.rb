module Api
  module V1
    class CommentsController < Api::V1::BaseController
      before_action :set_task , only: [:create, :update]
      before_action :set_comment, only: [:show, :update, :destroy, :like]

      def index
        @comments = @task.comments
      end

      def show
        @comment
      end

      def create
        @comment = @task.comments.build(comment_params)
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
    end
  end
