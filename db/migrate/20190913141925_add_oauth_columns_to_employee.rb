class AddOauthColumnsToEmployee < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :google_token, :string
    add_column :employees, :refresh_token, :string
    add_column :employees, :google_token_expires_at, :string
  end
end
