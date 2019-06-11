class FeedbacksController < ApplicationController
    def show

    end

    def create
        @feedback = current_user.feedback.build(feedback_params)
        @feedback.interview_id = params[:interview_id]
        if @feedback.save
            flash[:success] = "Successfully added comment"
            redirect_to application_interview_path(id: params[:id], interview_id: params[:interview_id])
        else
            flash[:danger] = "Failed to post comment"
        end
    end

    private
        def feedback_params
            params.require(:feedback).permit(:content)
        end
end
