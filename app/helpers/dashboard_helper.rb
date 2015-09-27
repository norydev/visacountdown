module DashboardHelper
  def user_policy_for(destination)
    if destination.policy.freedom?
      "<button class='btn btn-success btn-xs' data-toggle='popover' data-placement='bottom' title='Freedom of movement' data-content='You can freely move inside #{destination.zone == 'Turkey' ? '' : 'the '}#{destination.zone} without any limitation. You can travel with your ID card.'>Freedom of movement <i class='fa fa-question-circle'></i></button>".html_safe
    elsif destination.policy.need_visa? === true
      "<button class='btn btn-warning btn-xs' data-toggle='popover' data-placement='bottom' title='Visa needed' data-content='You need an e-visa to enter #{destination.zone == 'Turkey' ? '' : 'the '}#{destination.zone}. You can stay 90 days in ANY 180 days period.'>Visa needed <i class='fa fa-question-circle'></i></button>".html_safe
    elsif destination.policy.need_visa? === false
      "<button class='btn btn-info btn-xs' data-toggle='popover' data-placement='bottom' title='Visa not needed' data-content='You don&rsquo;t need a visa to enter #{destination.zone == 'Turkey' ? '' : 'the '}#{destination.zone}. You can stay 90 days in ANY 180 days period.'>Visa not needed <i class='fa fa-question-circle'></i></button>".html_safe
    # else
    #   "<p class='alert-danger marged'>
    #           Sorry, our calculator does not take your situation into account.
    #         </p>".html_safe
    end
  end
end
