class CreateCandidates < ActiveRecord::Migration[5.1]
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :email
      t.integer :experience

      t.timestamps
    end

    add_index :candidates, :email, unique: true
  end
end
