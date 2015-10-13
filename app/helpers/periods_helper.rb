module PeriodsHelper
  def date_format(date)
    date.strftime("%d %b %Y") if date
  end

  def form_date_format(date)
    date if date
  end
end
