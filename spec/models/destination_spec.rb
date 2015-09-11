require 'rails_helper'

RSpec.describe Destination, type: :model do

  it { should belong_to(:user) }
  it { should have_many(:periods).dependent(:destroy)}
  it { should validate_presence_of(:zone) }

  it 'responds to policy' do
    expect(subject).to respond_to(:policy)
  end

  it 'responds to policy with the correct Policy'
end
