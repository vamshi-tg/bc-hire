class ApplicationsController < ApplicationController
    def index
        @applications = Application.paginate(page: params[:page], per_page: 10)
    end

    def show
        @application = Application.find(params[:id])
    end
end
