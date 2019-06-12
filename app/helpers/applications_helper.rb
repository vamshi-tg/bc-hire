module ApplicationsHelper
    def disabled?(button, current_status)
        if button == "On Hold" && current_status == Application::STATUS[:on_hold]
            return true
        elsif current_status == Application::STATUS[:accepted] || current_status == Application::STATUS[:rejected]
            return true
        else
            return false
        end
    end
end
