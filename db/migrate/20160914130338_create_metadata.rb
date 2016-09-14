class CreateMetadata < ActiveRecord::Migration
  def change
    create_table :metadata do |t|
      t.string :url
      t.datetime :crawl_time
      t.integer :records_crawled
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
