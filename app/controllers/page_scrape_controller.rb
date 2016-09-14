class PageScrapeController < ApplicationController

	def dashboard
		
	end
	
	def scrape
		url = params[:url]
		@agent = Mechanize.new
    page = @agent.get(url)
    @category = page.css('.category-name').text.gsub(/\s+/, " ")
    @items = page.search('.js-tuple')
	end
end
