class PageScrapeController < ApplicationController

	def dashboard
		@metadata = current_user.metadata
	end

	def scrape
		if params[:url].present?
			@url = params[:url]
			@agent = Mechanize.new
			start_time = Time.now
	    page = @agent.get(@url)
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
	    current_user.metadata.find_or_initialize_by(:url => @url).update_attributes!(:records_crawled => @items.count, :crawl_time => crawl_time)	
		  @metadatum = current_user.metadata.find_by(:url => @url)
		else
			flash[:notice] = "Please provide a URL"
			redirect_to root_url
		end
	end

	def download_csv
		url = params[:url]
		agent = Mechanize.new
		page = agent.get(url)
		items = page.search('.js-tuple')
		respond_to do |format|
		  format.csv { send_data to_csv(items, agent) }
	  end
  end

	def to_csv(items, agent)
		CSV.generate(headers: true) do |csv|
			csv << %w{Image Name/Model Original_Price Dicounted_Price Dicount% EMI/month Color}
			items.each do |item|
				csv << item_data(item, agent)
			end
		end
	end

	def item_data(item, agent)
		link = item.at('.product-tuple-image a')
		new_page = agent.click(link)
		values = []
		image_url = item.css('.product-image img').attr('src') || item.css('.product-image img').attr('data-src')
		values << image_url
		values << item.css('.product-title').text
		values << item.css('.strike').text
		values << item.css('.product-price').text
		values << item.css('.product-discount span').text
		values << new_page.css('.emi-price').text
		values << new_page.css('.attr-selected .ellipses-cls').text
		return values
	end
end
