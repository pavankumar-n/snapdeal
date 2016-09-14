class PageScrapeController < ApplicationController

	def dashboard
		@metadata = current_user.metadata
	end

	def scrape
		if params[:url].present?
			url = params[:url]
			@agent = Mechanize.new
			start_time = Time.now
	    page = @agent.get(url)
	    @category = page.css('.category-name').text.gsub(/\s+/, " ")
	    @items = page.search('.js-tuple')
	    end_time = Time.now
	    crawl_time = (end_time - start_time)
	    # this is commented bcoz it creates new record even if same url is again submiited 
	    # metadatum = current_user.metadata.new
	    # metadatum.url = url
	    # metadatum.records_crawled = @items.count
	    # metadatum.crawl_time = Time.now
	    # metadatum.save!

	    #to avoid creating new record is same url is submitted.
	    current_user.metadata.find_or_initialize_by(:url => url).update_attributes!(:records_crawled => @items.count, :crawl_time => crawl_time)	
		  @metadatum = current_user.metadata.find_by(:url => url)
		else
			flash[:notice] = "Please provide a URL"
			redirect_to root_url
		end
	end
end
