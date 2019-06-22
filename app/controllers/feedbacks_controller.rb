class FeedbacksController < ApplicationController
    def create
        @feedback = current_user.feedback.build(feedback_params)
        @feedback.interview_id = params[:interview_id]
        if @feedback.save
            flash[:success] = "Posted comment"
        else
            flash[:danger] = "Failed to post comment"
        end
        redirect_to application_path(id: params[:id], interview: params[:interview_id])
    end

    private
        def feedback_params
            params.require(:feedback).permit(:content)
        end
end
