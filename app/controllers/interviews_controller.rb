class InterviewsController < ApplicationController
  def application_new_interview
    @application_id = params[:id]
    @interviewers = get_interviewer_name_and_id_map
    @interview = Interview.new
    render 'new'
  end

  def create
    @interview = Interview.new(interview_params)
    # debugger
    if @interview.save
      flash[:success] = "Sucess"
      redirect_to root_path
    else
      flash[:danger] = "Failure"
      redirect_to root_path
    end
  end

  private
    def interview_params
      all_params = {}
      all_params = params.require(:interview).permit(:round_name, :interviewer_id, :scheduled_on, :start_time, :end_time)
      all_params['application_id'] = params[:app_id].to_s
      return all_params
    end

    def get_interviewer_name_and_id_map
        name_id_map = {}

        Employee.select(:id, :name).each do |employee|
          name_id_map[employee.name] = employee.id 
        end
        
        return name_id_map
    end
end
