class AlterNameFieldsInEmployee < ActiveRecord::Migration[5.1]
  def change
    rename_column :employees, :first_name, :name
    remove_column :employees, :last_name
  end
end
