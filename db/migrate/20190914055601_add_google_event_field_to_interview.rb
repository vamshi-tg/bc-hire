class AddGoogleEventFieldToInterview < ActiveRecord::Migration[5.1]
  def change
    add_column :interviews, :google_event_id, :string
  end
end
