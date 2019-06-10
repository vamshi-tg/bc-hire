class InterviewsController < ApplicationController
  def application_new_interview
    @application_id = params[:id]
    @interviewers = get_interviewer_name_and_id_map
    @interview = Interview.new
    render 'new'
  end

  def create_interview_for_application
    begin
      @interview = Interview.new(interview_params)
      save_interview(@interview)
      update_application_status(@interview)
    rescue Exceptions::InvalidTimeSlotException
      redirect_to_new_application_interview_path(flash: { danger: "Invalid time slot"})

    rescue ActiveRecord::RecordNotUnique
      redirect_to_new_application_interview_path(flash: { danger: "Interviewer not available" })
    end
  end

  private
    def save_interview(interview)
      if interview.save
        flash[:success] = "Sucess"
        redirect_to application_path(application_id_param)
      else
        redirect_to_new_application_interview_path(flash: { danger: interview.errors.full_messages.join(', ') })
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

    def get_interviewer_name_and_id_map
        name_id_map = {}

        Employee.select(:id, :name).each do |employee|
          name_id_map[employee.name] = employee.id 
        end
        
        return name_id_map
    end

    def update_application_status(interview)
      if interview.application.status == "Open"
        interview.application.update_attribute(:status, "In Progress" )
      end
    end
end
