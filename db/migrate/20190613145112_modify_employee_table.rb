class ModifyEmployeeTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :employees, :name, :string
    change_column :employees, :role, :string, :default => "Interviewer"
  end
end
