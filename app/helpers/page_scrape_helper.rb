module PageScrapeHelper
	def not_nil(value)
		if value && value.present?
			value[/[0-9]+(\,|\.)?[0-9]*/].delete(',').to_i
		end
	end
end

