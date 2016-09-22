class PageScrapeController < ApplicationController

	def dashboard
		@metadata = current_user.metadata
	end

	def scrape
	  if params[:url].present?
	    @url = params[:url]
	    @url.sub!(/\#.*/, '')
	    @agent = Mechanize.new
	    start_time = Time.now
	    page = @agent.get(@url)
	    end_time = Time.now
	    @crawl_time = (end_time - start_time)
	    @category = page.css('.category-name').text.gsub(/\s+/, " ")
	    #to avoid creating new record is same url is submitted.
	    #current_user.metadata.find_or_initialize_by(:url => @url).update_attributes!(:records_crawled => 0, :crawl_time => crawl_time)
	    current_user.metadata.find_or_create_by(:url => @url)
	    @metadatum = current_user.metadata.find_by(:url => @url)
	  else
	    flash[:alert] = "Please provide a URL"
	    redirect_to root_url
	  end
	end

	def destroy_record
		@metadatum = current_user.metadata.find_by(id: params[:id])
		if @metadatum
			if @metadatum.destroy
				flash[:notice] = "Record was Deleted"
				redirect_to root_url
			else
				flash[:alert] = "Something went wrong!"
				redirect_to root_url
			end
		else
			flash[:alert] = "Something went wrong!"
			redirect_to root_url
		end
	end

	def download_csv
		url = params[:url]
		agent = Mechanize.new
		respond_to do |format|
		  format.csv { send_data to_csv(url, agent) }
	  end
	end

	def to_csv(url, agent)
		CSV.generate(headers: true) do |csv|
			csv << %w{Image Name/Model Original_Price Dicounted_Price Dicount% EMI/month Color Product_Link Total_ratings Average_rating Offer}
			some_method(url, agent, csv)
		end
	end

	def some_method(url, agent, csv)
		a = 0
		while true
			begin
				new_url = url + "&start=#{a}&ajax=true"
				page = agent.get(new_url)
				(page.search('.js-tuple')).each do |item|
					values = []
					image_url = item.css('.product-image img').attr('src') || item.css('.product-image img').attr('data-src')
					values << image_url
					link = item.at('.product-tuple-image a')
					new_page = agent.click(link)
					values << item.css('.product-title').text
					values << item.css('.strike').text
					values << item.css('.product-price').text
					values << item.css('.product-discount span').text
					values << new_page.css('.emi-price').text
					values << new_page.css('.attr-selected .ellipses-cls').text
					values << link[:href]
					values << item.css('.product-rating-count').text[/[0-9]+/]
					values << new_page.css('.avrg-rating').text[/[0-9]\.?[0-9]/]
					values << new_page.css('.freebieNotPresentClass').text.strip
					a += 1
					csv << values
				end
			rescue Exception => e
				break
			end
		end
		csv
	end

	# def download_csv
	# 	url = params[:url]
	# 	agent = Mechanize.new
	# 	page = agent.get(url)
	# 	items = page.search('.js-tuple')
	# 	respond_to do |format|
	# 	  format.csv { send_data to_csv(items, agent) }
	#   end
 #  end

	# def to_csv(items, agent)
	# 	CSV.generate(headers: true) do |csv|
	# 		csv << %w{Image Name/Model Original_Price Dicounted_Price Dicount% EMI/month Color}
	# 		items.each do |item|
	# 			csv << item_data(item, agent)
	# 		end
	# 	end
	# end

	# def item_data(item, agent)
	# 	link = item.at('.product-tuple-image a')
	# 	new_page = agent.click(link)
	# 	values = []
	# 	image_url = item.css('.product-image img').attr('src') || item.css('.product-image img').attr('data-src')
	# 	values << image_url
	# 	values << item.css('.product-title').text
	# 	values << item.css('.strike').text
	# 	values << item.css('.product-price').text
	# 	values << item.css('.product-discount span').text
	# 	values << new_page.css('.emi-price').text
	# 	values << new_page.css('.attr-selected .ellipses-cls').text
	# 	return values
	# end
end
