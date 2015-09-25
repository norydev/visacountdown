module DashboardHelper
  def user_policy_for(destination)
    if destination.policy.freedom?
      "<p class='alert-success marged'>
              You can freely move inside #{destination.zone == 'Turkey' ? '' : 'the '}#{destination.zone} without any limitation. You can travel with your ID card.
            </p>".html_safe
    elsif destination.policy.need_visa? === true
      "<p class='alert-warning marged'>
              You need an e-visa to enter #{destination.zone == 'Turkey' ? '' : 'the '}#{destination.zone}. You can stay 90 days in ANY 180 days period.
            </p>".html_safe
    elsif destination.policy.need_visa? === false
      "<p class='alert-info marged'>
              You don't need a visa to enter #{destination.zone == 'Turkey' ? '' : 'the '}#{destination.zone}. You can stay 90 days in ANY 180 days period.
            </p>".html_safe
    # else
    #   "<p class='alert-danger marged'>
    #           Sorry, our calculator does not take your situation into account.
    #         </p>".html_safe
    end
  end
end
