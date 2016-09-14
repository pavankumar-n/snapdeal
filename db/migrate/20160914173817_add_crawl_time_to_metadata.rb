class AddCrawlTimeToMetadata < ActiveRecord::Migration
  def change
    add_column :metadata, :crawl_time, :float
  end
end
