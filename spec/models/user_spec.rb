require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:destinations).dependent(:destroy)}
  it { should validate_inclusion_of(:citizenship).in_array(COUNTRIES).allow_blank }
end
