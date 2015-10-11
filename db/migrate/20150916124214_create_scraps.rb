class CreateScraps < ActiveRecord::Migration
  def change
    create_table :scraps do |t|
        t.string :post_category
        t.date :post_deadline
        t.string :post_company
        t.string :post_subject
        t.string :post_content
        t.string :post_image
        
      t.timestamps null: false
    end
  end
end
