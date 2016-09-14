class PageScrapeController < ApplicationController

	def dashboard
		@metadata = current_user.metadata
	end

	def scrape
		url = params[:url]
		@agent = Mechanize.new
		start_time = Time.now
    page = @agent.get(url)
    @category = page.css('.category-name').text.gsub(/\s+/, " ")
    @items = page.search('.js-tuple')
    end_time = Time.now
    crawl_time = (end_time - start_time).round(2)
    # this is commented bcoz it creates new record even if same url is again submiited 
    # metadatum = current_user.metadata.new
    # metadatum.url = url
    # metadatum.records_crawled = @items.count
    # metadatum.crawl_time = Time.now
    # metadatum.save!

    #to avoid creating new record is same url is submitted.
    current_user.metadata.find_or_initialize_by(:url => url).update_attributes!(:records_crawled => @items.count, :crawl_time => crawl_time)
	end
end
