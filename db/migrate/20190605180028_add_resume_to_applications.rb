class AddResumeToApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :resume, :string
  end
end
