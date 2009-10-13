ActiveRecord::Schema.define(:version => 0) do
  create_table :books, :force => true do |t|
    t.column :id,           :integer
    t.column :title,        :string
    t.column :price,        :integer
    t.column :rate,         :float
    t.column :content,      :text
  end

  create_table :blogs, :force => true do |t|
    t.column :id,           :integer
    t.column :title,        :string
    t.column :content,      :text
  end
end
