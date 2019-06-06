class AddStatusToApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :status, :string, default: "open"
  end
end
