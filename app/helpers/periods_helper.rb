module PeriodsHelper
  def date_format(date)
    date.strftime("%d %b %Y") if date
  end
end
