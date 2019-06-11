class AddColumnsToEmployee < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :uid, :string
    add_column :employees, :email, :string
    add_column :employees, :first_name, :string
    add_column :employees, :last_name, :string
    add_column :employees, :picture, :string
    add_column :employees, :provider, :string
  end
end
