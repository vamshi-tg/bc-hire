module InterviewsHelper
    def get_old_value(previous_changes, interview, field)
        previous_changes.key?(field) ? previous_changes[field][0] : interview[field]
    end

    def get_topic_feedback_name(topic_key)
        all_round_topics ||= Interview::ROUND_TOPICS.values.reduce({}, :merge)
        return all_round_topics[topic_key.to_sym]
    end
end