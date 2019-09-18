class TopicFeedbacksController < ApplicationController
    def create
        interview = Interview.find(params[:interview_id])
        @errors = []

        params[:round].each do |topic, feedbacks|
            TopicFeedback.new(feedback_params(topic)).tap do |topic_feedback|
                topic_feedback.name = topic
                topic_feedback.interview_id = interview.id
                @errors << topic_feedback.errors.full_messages unless topic_feedback.save
            end
        end

        if @errors.present?
            render json: { html: render_to_string(partial: 'topic_feedback_errors', errors: @errors) }, status: :bad_request   
        else
            interview_topic_feedbacks = TopicFeedback.where(interview_id: interview.id)
            render_show_view_as_json(interview_topic_feedbacks, interview)
        end
    end

    def edit
        interview_topic_feedbacks = TopicFeedback.where(interview_id: params[:interview_id])
        render json: { 
            html: render_to_string(partial: 'edit', 
                locals: {
                    interview_topic_feedbacks: interview_topic_feedbacks, 
                    interview_id: params[:interview_id]
                    }) 
                }
    end

    def update
        @errors = []

        params[:round].each do |topic_name, feedbacks|
            topic_feedback = TopicFeedback.find_by(name: topic_name, interview_id: params[:interview_id])
            is_updated = topic_feedback.update_attributes(feedback_params(topic_name))
            @errors << topic_feedback.errors.full_messages unless is_updated
        end

        if @errors.present?
            render json: { html: render_to_string(partial: 'topic_feedback_errors', errors: @errors) }, status: :bad_request 
        else
            interview_topic_feedbacks = TopicFeedback.where(interview_id: params[:interview_id])
            interview = interview_topic_feedbacks.first.interview
            render_show_view_as_json(interview_topic_feedbacks, interview)
        end
    end

    private
        def feedback_params(topic)
            params.require(:round).require(topic.to_sym).permit(:positives, :negatives, :candidate_level)
        end

        def render_show_view_as_json(interview_topic_feedbacks, interview)
            render json: { 
                html: render_to_string(partial: 'show',
                    locals: { 
                        interview_topic_feedbacks: interview_topic_feedbacks,
                        interview: interview
                        }) 
                    }
        end
end