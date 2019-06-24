class ChangeDefaultStatusOfApplications < ActiveRecord::Migration[5.1]
  def change
    change_column :applications, :status, :string, default: "Open"
  end
end
