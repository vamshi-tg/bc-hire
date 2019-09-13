module TopicFeedbacksHelper
    def get_interview_topic_feedbacks(interview_id)
        TopicFeedback.where(interview_id: interview_id)
    end
end