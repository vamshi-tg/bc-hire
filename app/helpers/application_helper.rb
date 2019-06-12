module ApplicationHelper
    def current_path_active?(test_path)
        request.path == test_path ? 'active' : ''
    end

    # TO-DO How to handle this?
    def roles
        ["Full Stack Developer", "Web Developer", "Graphic Designer"]
    end

    def formatted_time(time)
        time = time.in_time_zone("Kolkata")
        time.strftime("%I:%M %p")
    end

    def login_url?
        request.path == login_path
    end
end
