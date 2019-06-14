class FeedbacksController < ApplicationController
    def create
        @feedback = current_user.feedback.build(feedback_params)
        @feedback.interview_id = params[:interview_id]
        if @feedback.save
            flash[:success] = "Posted comment"
            @feedback.send_interview_activity_mail
        else
            flash[:danger] = "Failed to post comment"
        end
        redirect_to application_interview_path(id: params[:id], interview_id: params[:interview_id])
    end

    private
        def feedback_params
            params.require(:feedback).permit(:content)
        end
end
