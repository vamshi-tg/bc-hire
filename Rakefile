# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'yaml'

Rails.application.load_tasks

namespace :dev_utils do
    desc 'add_permissions_to_employee'
    task add_permissions_to_employee: :environment do
        data = YAML::load(File.open("./db/employee_permissions.yaml"))
        not_found_emails = []
        failed_emails = []

        data["employees"].each do |email, permissions|
            begin    
                employee = Employee.find_by!(email: email)
                if employee.permission.nil?
                    employee.create_permission!(permissions)
                end
            rescue ActiveRecord::RecordNotFound
                not_found_emails << email
            rescue StandardError => e
                failed_emails << { email: email, error: e.message }
            end
        end

        puts "Emails not found: #{not_found_emails}" if not_found_emails.any?
        puts "Add permssions failed emails: #{failed_emails}" if failed_emails.any?
    end
end