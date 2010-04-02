class WeeklyVerticalCalendar::Builder
  include ::ActionView::Helpers::TagHelper

  def initialize(events, template, start_date, end_date)
    raise ArgumentError, "WeeklyVerticalCalendar expects an Array but found a #{events.inspect}" unless events.is_a? Array
    @events, @template, @start_date, @end_date = events, template, start_date, end_date
  end

  def week
    concat(tag("div", :id => "hours"))
    concat(content_tag("div", "&nbsp;", :id => "hour_header"))
    (0..23).each do |hour|
      concat(content_tag("div", "#{hour}:00", :id => "hour"))
    end
    concat("</div>")

    concat(tag("div", :id => "days"))
    concat(tag("div", :id => "days_header"))
    (@start_date..@end_date).each do |day|
      concat(tag("div", :id => "day_header_box"))
      concat(content_tag("b", day.strftime('%A')))
      concat(tag("br/"))
      concat(day.strftime('%B %d'))
      concat("</div>")
    end
    concat("</div>")
    concat(tag("div", :id => "grid"))
    (@start_date..@end_date).each do |day|
      concat(tag("div", :id => "day_column"))
      @events.each do |event|
        j_start_at, j_end_at, j_day = j(event.start_at, event.end_at, day)
        if (j_start_at..j_end_at).include?(j_day) or ((j_start_at > j_end_at) and ((j_start_at <= j_day) or (j_end_at >= j_day) ))
          concat(tag("div", :id => "event", :style =>"top:#{top(event.start_at, event.end_at, day)}px;height:#{height(event.start_at, event.end_at, day)}px;", :onclick => "location.href='/events/#{event.id}';"))
          yield(event)
          concat("</div>")
        end
      end
      concat("</div>")
    end
    concat("</div>")
    concat("</div>")
  end

  private

  def concat(tag)
    @template.concat(tag)
  end

  def top(start_at, end_at, day)
    hours, minutes = hours_and_minutes(start_at)
    j_start_at, j_end_at, j_day = j(start_at, end_at, day)
    return -1 if (j_start_at != j_end_at and j_start_at != j_day)
    (hours * 40) + minutes
  end

  def height(start_at, end_at, day)
    top = top(start_at, end_at, day)
    hours, minutes = hours_and_minutes(end_at)
    j_start_at, j_end_at, j_day = j(start_at, end_at, day)
    return (960 - top) if (j_start_at != j_end_at and j_end_at != j_day)
    (hours * 40) + minutes - top
  end

  def hours_and_minutes(date)
    [(date.strftime('%H').to_f), (date.strftime('%M').to_f * 2/3)]
  end

  def j(start_at, end_at, day)
    [start_at.strftime('%j'), end_at.strftime('%j'), day.strftime('%j')]
  end

end