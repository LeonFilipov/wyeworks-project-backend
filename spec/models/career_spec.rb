require 'rails_helper'

RSpec.describe Career, type: :model do
  let!(:university) { FactoryBot.create(:university) }
  it "is valid with valid attributes" do
    career = FactoryBot.create(:career, university: university)
    expect(career).to be_valid
  end

  it "is not valid without a name" do
    career = FactoryBot.build(:career, university: university, name: nil)
    expect(career).to_not be_valid
    expect(career.errors[:name]).to include("can't be blank")
  end

  it "is not valid without a university" do
    career = FactoryBot.build(:career, university: nil)
    expect(career).to_not be_valid
    expect(career.errors[:university]).to include("must exist")
  end
end
