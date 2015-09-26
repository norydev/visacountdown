module DestinationsHelper
  def display_countdown(countdown)
    case countdown.situation
    when "inside_ok"
      "<ul class=list-unstyled>
        <li>Time spent in the last 180 days: <strong>#{countdown.time_spent}</strong> days</li>
        <li>Remaining time: <strong>#{countdown.remaining_time}</strong> days</li>
        <li>Latest exit date: <strong>#{date_format(countdown.exit_day)}</strong></li>
      </ul>".html_safe
    when "outside_ok"
      "<ul class=list-unstyled>
        <li>Time spent in the last 180 days: <strong>#{countdown.time_spent}</strong> days</li>
        <li>Remaining time: <strong>#{countdown.remaining_time}</strong> days</li>
        <li>Latest exit date: <strong>#{date_format(countdown.exit_day)}</strong></li>
      </ul>".html_safe
    when "overstay"
    when "current_too_long"
    when "one_next_too_long"
    when "quota_will_be_used_can_enter"
    when "quota_will_be_used_cannot_enter"
    when "quota_will_be_used_no_entry"
    when "quota_used_can_enter"
    when "quota_used_cannot_enter"
    when "quota_used_no_entry"
    end
  end
end
