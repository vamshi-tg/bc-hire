class InterviewsController < ApplicationController
  include InterviewsHelper
  
  before_action :set_round_names, only: [:new, :edit]

  def new
    @application_id = params[:id]
    @interviewers = get_interviewer_name_and_id_map
    @interview = Interview.new
  end

  def create
    begin
      @interview = Interview.new(interview_params)
      save_interview(@interview)
      update_application_status(@interview)
    rescue Exceptions::InvalidTimeSlotException
      redirect_to_new_application_interview_path(flash: { danger: "Invalid time slot"})

    rescue Exceptions::InterviewTimeOverlapException
      redirect_to_new_application_interview_path(flash: { danger: "Interviewer has interview around this time period. Cannot schedule interview for the interviewer" })
    end
  end

  def edit
    @application_id = params[:id]
    @interviewers = get_interviewer_name_and_id_map
    @interview = Interview.find(params[:interview_id])
  end

  def update
    begin
      @interview = Interview.find(params[:interview_id])
      update_interview(@interview)
    rescue Exceptions::InvalidTimeSlotException
      redirect_to_edit_application_interview_path(flash: { danger: "Invalid time slot"})

    rescue Exceptions::InterviewTimeOverlapException
      redirect_to_edit_application_interview_path(flash: { danger: "Interviewer has interview around this time period. Cannot schedule interview for the interviewer" })
    end
  end

  def set_round_names
    @round_names = Interview::ROUND_TOPICS.keys
  end

  private
    def save_interview(interview)
      if interview.save
        flash[:success] = "Scheduled Interview"
        interview.create_calendar_event(current_user)
        #TODO Try to better this
        redirect_to application_path(id: application_id_param[:id], interview: interview.id, anchor: "interviews")
      else
        redirect_to_new_application_interview_path(flash: { danger: interview.errors.full_messages.join(', ') })
      end
    end

    def update_interview(interview)
      if interview.update_attributes(interview_params)
        flash[:success] = "Updated Interview Details"
        interview.update_calendar_event(current_user)
        # send_relevant_interview_mail(interview)
        #TODO Try to better this
        redirect_to application_path(id: application_id_param[:id], interview: interview.id, anchor: "interviews")
      else
        redirect_to_edit_application_interview_path(flash: { danger: interview.errors.full_messages.join(', ') })
      end
    end    

    def interview_params
      all_params = {}
      all_params = params.require(:interview).permit(:round_name, :interviewer_id, :scheduled_on, :start_time, :end_time)
      all_params[:application_id] = params[:application_id]
      return all_params
    end

    def application_id_param
      return {id: params[:application_id]}
    end

    def redirect_to_new_application_interview_path(flash)
      redirect_to application_new_interview_path(application_id_param), flash
    end

    def redirect_to_edit_application_interview_path(flash)
      redirect_to application_edit_interview_path(id: params[:application_id], interview_id: params[:interview_id]), flash
    end

    def get_interviewer_name_and_id_map
        name_id_map = {}

        Employee.select(:id, :name).each do |employee|
          name_id_map[employee.name] = employee.id 
        end
        
        return name_id_map
    end

    def update_application_status(interview)
      if interview.application.status == Application::STATUS[:open]
        interview.application.update_attribute(:status, "In Progress" )
      end
    end

    def send_relevant_interview_mail(interview)
      changes = interview.previous_changes
      if changes
        if changes.key?("interviewer_id")
          interview.send_interview_schedule_mail
        else
          interview.send_interview_schedule_update_mail(changes, current_user)
        end
      end
    end
end
