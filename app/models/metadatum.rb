class Metadatum < ActiveRecord::Base
  belongs_to :user

  def update_crawl_time_and_records_crawled(total_time, count)
	self.crawl_time = total_time
	self.records_crawled = count
	self.save!
  end
end
