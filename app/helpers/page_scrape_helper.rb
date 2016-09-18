module PageScrapeHelper
  def not_nil(value)
    if value && value.present?
      value[/[0-9]+(\,|\.)?[0-9]*(\,|\.)?[0-9]*/].delete(',').to_i
    end
  end

	def secs_or_minutes(sec)
		if sec < 60.00
			pluralize(sec, "second")
		else
			min = sec/60.00
			pluralize(min.round(2), "minute")
		end
	end
end

