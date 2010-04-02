# WeeklyVerticalCalendar by Ireneusz Skrobis 2010
module WeeklyVerticalCalendar

  def weekly_vertical_calendar(objects, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    start_date, end_date = date(options[:date] || Time.now)
    concat(tag("div", :id => "week"))
    yield WeeklyVerticalCalendar::Builder.new(objects || [], self, start_date, end_date)
    concat("</div>")
  end

  def weekly_vertical_calendar_links(options)
    start_date, end_date = date(options[:date] || Time.now)
    concat("<a href='?start_date=#{start_date - 7}?user_id='>« Previous Week</a> ")
    concat("#{start_date.strftime("%B %d -")} #{end_date.strftime("%B %d")} #{start_date.year}")
    concat(" <a href='?start_date=#{start_date + 7}?user_id='>Next Week »</a>")
  end

  def date(date)
    start_date = Date.new(date.year, date.month, date.day)
    end_date = Date.new(date.year, date.month, date.day) + 6
    [start_date, end_date]
  end

end