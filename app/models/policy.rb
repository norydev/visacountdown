class Policy

  attr_reader :destination, :countries

  def initialize(citizenship, destination)
    @destination = destination
    @citizenship = citizenship
    @rules = POLICIES[@destination][@citizenship]
  end

  def freedom?
    @rules["freedom"]
  end

  def need_visa?
    @rules["need_visa"]
  end

  def length
    @rules["length"]
  end

  def window
    @rules["window"]
  end

  def self.write_new
    #erase file
    File.open('config/policies.yml', 'w') do |file|
      file.write("")
    end

    File.open('config/policies.yml', 'a') do |file|
      write_destination(file, "Schengen area")
      write_destination(file, "Turkey")
    end
  end

  private

  def self.write_destination(file, destination)
    file.write( "#{destination}:" + "\n")
    COUNTRY_LIST.each do |a|

      citizenship = a.first

      policy = COUNTRY_LIST[citizenship]["#{destination}"]["visa"]

      case policy
      when "no_visa_90_180"
        freedom = false
        need_visa = false
        length = 90
        window = 180
      when "evisa_90_180"
        freedom = false
        need_visa = true
        length = 90
        window = 180
      when "freedom"
        freedom = true
        need_visa = false
        length = 0
        window = 0
      when "error"
        freedom = false
        need_visa = "error"
        length = "error"
        window = "error"
      end

      file.write( "  #{citizenship}:" + "\n")
      file.write( "    freedom: #{freedom}" + "\n")
      file.write( "    need_visa: #{need_visa}" + "\n")
      file.write( "    length: #{length}" + "\n")
      file.write( "    window: #{window}" + "\n")
    end
  end
end