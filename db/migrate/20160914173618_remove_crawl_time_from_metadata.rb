class RemoveCrawlTimeFromMetadata < ActiveRecord::Migration
  def change
    remove_column :metadata, :crawl_time, :datetime
  end
end
