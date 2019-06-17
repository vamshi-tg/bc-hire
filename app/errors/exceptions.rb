module Exceptions
    class InvalidTimeSlotException < StandardError; end
    class InterviewTimeOverlapException < StandardError; end
end