ActiveRecord::Schema.define do
  self.verbose = false
  
  create_table :trees, :force => true do |t|
    t.string :type
    t.integer :fruit
    t.timestamps
  end
end
