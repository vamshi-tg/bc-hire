class ChangeOauthExpireTypeOfEmployee < ActiveRecord::Migration[5.1]
  def change
    change_column :employees, :google_token_expires_at, :integer, using: 'google_token_expires_at::integer'
  end
end
