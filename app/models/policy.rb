class Policy

  attr_reader :destination, :countries

  def initialize(citizenship, destination)
    @policies_table = POLICIES
    countries = @policies_table.map{ |val| val }.sort
    @destination = destination.capitalize
    @citizenship = citizenship.capitalize
  end

  def to_s
    @destination
  end

  def need_visa?
    @policies_table[@destination][@citizenship]
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
    COUNTRIES.each do |a|

      citizenship = a.first

      policy = COUNTRIES[citizenship]["#{destination}"]["visa"]

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