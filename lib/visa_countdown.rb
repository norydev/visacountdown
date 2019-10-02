# frozen_string_literal: true
require "date"
require "pry"

require "visa_countdown/type_normalizer"
require "visa_countdown/period"
require "visa_countdown/period_collection"
require "visa_countdown/status"
require "visa_countdown/countdown"

module VisaCountdown
  class << self
    def new(*args)
      Countdown.new(*args)
    end
  end
end
