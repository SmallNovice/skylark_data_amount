class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :article_name
      t.string :article_id
      t.integer :article_number
      t.string :article_data

      t.timestamps
    end
  end
end
