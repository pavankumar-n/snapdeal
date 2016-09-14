class Metadatum < ActiveRecord::Base
  belongs_to :user

  def update_crawl_time(total_time)
  	self.crawl_time += total_time
  	self.save!
  end
end
