module PeriodsHelper
  def date_format(date)
    if date
      date.strftime("%d %b %Y")
    end
  end
end
