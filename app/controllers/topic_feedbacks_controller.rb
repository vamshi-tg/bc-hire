class TopicFeedbacksController < ApplicationController
    def create
        interview = Interview.find(params[:interview_id])
        @errors = []

        params[:round].each do |topic, feedbacks|
            TopicFeedback.new(feedback_params(topic)).tap do |topic_feedback|
                topic_feedback.name = topic
                topic_feedback.interview_id = interview.id
                unless topic_feedback.save
                    @errors << topic_feedback.errors.full_messages
                end
            end
        end

        if @errors.present?
            #TODO: Send status as bad request
            render json: { html: "<H4> Feedback already exists for form </H4>" }    
        else
            interview_topic_feedbacks = TopicFeedback.where(interview_id: interview.id)
            render json: { 
                html: render_to_string(partial: 'show', 
                    locals: { 
                        interview_topic_feedbacks: interview_topic_feedbacks, 
                        interview_id: interview.id
                    })
                }
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
            unless topic_feedback.update_attributes(feedback_params(topic_name))
                @errors << topic_feedback.errors.full_messages
            end
        end

        if @errors.present?
            #TODO: Send status as bad request
            render json: { html: "<H4> Error while Updating </H4>" }    
        else
            interview_topic_feedbacks = TopicFeedback.where(interview_id: params[:interview_id])
            render json: { 
                html: render_to_string(partial: 'show',
                    locals: { 
                        interview_topic_feedbacks: interview_topic_feedbacks, 
                        interview_id: params[:interview_id]
                        }) 
                    }
        end

    end

    private
    def feedback_params(topic)
        params.require(:round).require(topic.to_sym).permit(:positives, :negatives, :candidate_level)
    end
end