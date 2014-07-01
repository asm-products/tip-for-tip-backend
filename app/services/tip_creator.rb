# Handles the complexities of creating a tip.
class TipCreator

  # Expects the user and noun to be included in the params.
  # Parses send_at from named values if provided.
  def call(params)
    params.symbolize_keys!

    params[:send_at] = parse_send_at(params[:send_at])

    tip = Tip.new params
    tip.user = params[:user]
    tip.noun = params[:noun]
    tip.save!

    tip
  end

  private

  # Internal: Parses the send_at value. If it is a parseable timestamp
  # it will be used as a precise time. If it is a named timeframe string
  # it will be interpreted and randomized within that timeframe.
  def parse_send_at(val)
    return val if val.blank?

    val = val.to_s
    time = Time.parse(val) rescue case val.downcase.strip
    when 'today' then rand(1.hour.from_now..4.hours.from_now)
    when 'tomorrow' then rand(1.day.from_now.beginning_of_day..1.day.from_now.end_of_day)
    when 'later this week' then rand(2.days.from_now..4.days.from_now)
    when 'in a few weeks' then rand(2.weeks.from_now..4.weeks.from_now)
    else
      raise ArgumentError, "Cannot parse send_at value '#{val}'"
    end
    time.to_datetime
  end



end
