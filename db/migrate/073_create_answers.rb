class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.column :ticket_id, :integer
      t.column :subject, :string
      t.column :message, :text
      t.timestamps 
    end
    add_index :answers, :ticket_id
  end

  def self.down
    drop_table :answers
  end
end
