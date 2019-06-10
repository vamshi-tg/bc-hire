module ApplicationHelper
    def current_path_active?(test_path)
        request.path == test_path ? 'active' : ''
    end

    # TO-DO How to handle this?
    def roles
        ["Full Stack Developer", "Web Developer", "Graphic Designer"]
    end

    def format_time(time)
        time
    end
end
