module DestinationsHelper
  def visa_need(destination)
    if destination.policy.freedom?
      { image: "walk.svg", title: "Freedom of movement", text: "You can freely move inside #{destination.zone == 'Turkey' ? '' : 'the '}#{destination.zone} without any limitation. You can travel with your ID card." }
    elsif destination.policy.need_visa? === true
      { image: "visa.svg", title: "Visa needed", text: "You need an e-visa to enter #{destination.zone == 'Turkey' ? '' : 'the '}#{destination.zone}. You can stay 90 days in ANY 180 days period." }
    elsif destination.policy.need_visa? === false
      { image: "novisa.svg", title: "Visa not needed", text: "You don't need a visa to enter #{destination.zone == 'Turkey' ? '' : 'the '}#{destination.zone}. You can stay 90 days in ANY 180 days period." }
    else
      { image: "logo_no_text.svg", title: "No information", text: "Sorry, Visa Countdown has no information for citizens from #{destination.user.citizenship} going to #{destination.zone == 'Turkey' ? '' : 'the '}#{destination.zone}." }
    end
  end

  # Statuses:
  #
  # "inside_ok"
  # "outside_ok"
  # "overstay"
  # "current_too_long"
  # "one_next_too_long"
  # "quota_will_be_used_can_enter"
  # "quota_will_be_used_cannot_enter"
  # "quota_will_be_used_no_entry"
  # "quota_used_can_enter"
  # "quota_used_cannot_enter"
  # "quota_used_no_entry"
  def status_color(destination)
    if destination.policy.freedom?
      situation = "freedom"
    elsif destination.countdown
      situation = destination.countdown.situation
    else
      situation = "no info"
    end

    if ["current_too_long", "one_next_too_long", "quota_will_be_used_cannot_enter", "quota_used_cannot_enter"].include?(situation)
      "orange"
    elsif ["quota_will_be_used_no_entry", "quota_used_no_entry", "no info"].include?(situation)
      "blue"
    elsif situation == "overstay"
      "red"
    else
      "green"
    end
  end

  def status_icon(color)
    case color
    when "green"
      "far fa-thumbs-up"
    when "blue"
      "fas fa-info-circle"
    when "red"
      "fas fa-times-circle"
    else
    # when "orange"
      "fas fa-exclamation-triangle"
    end
  end
end
