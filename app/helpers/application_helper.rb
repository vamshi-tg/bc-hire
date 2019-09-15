module ApplicationHelper
    def current_path_active?(test_path)
        request.path == test_path ? 'active' : ''
    end

    # TO-DO How to handle this?
    def roles
        ["Full Stack Developer", "Web Developer", "Graphic Designer"]
    end

    def formatted_time(time)
        time.strftime(Interview::TIME_FORMAT)
    end

    def get_date(time)
        time.strftime(Interview::DATE_FORMAT)
    end

    def login_url?
        request.path == login_path
    end
end
