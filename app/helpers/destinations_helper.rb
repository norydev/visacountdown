module DestinationsHelper
  def display_countdown_for(destination)
    countdown = destination.countdown
    case countdown.situation
    when "inside_ok"
      "<div class='panel panel-success'>
        <div class='panel-heading'>You are in #{destination}</div>
        <div class='panel-body'>
          <ul class=list-unstyled>
            <li>Time spent in the last 180 days: <strong>#{countdown.time_spent}</strong> days</li>
            #{
              if destination.latest_entry && destination.latest_entry <= Date.current
                'You entered on ' + date_format(destination.latest_entry)
              elsif destination.latest_entry && destination.latest_entry > Date.current
                'You plan to enter on ' + date_format(destination.latest_entry)
              else
                '</ul><ul class=list-unstyled><li>If you enter tomorrow:</li>'.html_safe
              end
            }
            <li>Remaining time: <strong>#{countdown.remaining_time}</strong> days</li>
            <li>Latest exit date: <strong>#{date_format(countdown.exit_day)}</strong></li>
          </ul>
        </div>
      </div>".html_safe
    when "outside_ok"
      "<div class='panel panel-success'>
        <div class='panel-heading'>You are outside of #{destination}</div>
        <div class='panel-body'>
          <ul class=list-unstyled>
            <li>Time spent in the last 180 days: <strong>#{countdown.time_spent}</strong> days</li>
            #{'</ul><ul class=list-unstyled><li>If you enter tomorrow:</li>'.html_safe unless destination.latest_entry}
            <li>Remaining time: <strong>#{countdown.remaining_time}</strong> days</li>
            <li>Latest exit date: <strong>#{date_format(countdown.exit_day)}</strong></li>
          </ul>
        </div>
      </div>".html_safe
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
