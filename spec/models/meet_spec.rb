require 'rails_helper'

RSpec.describe Meet, type: :model do
  let!(:university) { FactoryBot.create(:university) }
  let!(:subject) { FactoryBot.create(:subject, university: university) }
  let!(:topic) { FactoryBot.create(:topic, subject: subject) }
  let!(:user_tutor) { FactoryBot.create(:user) }
  let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user_tutor, topic: topic) }
  let!(:meet) { FactoryBot.create(:meet, availability_tutor: availability_tutor) }

  it "is valid with valid attributes" do
    expect(meet).to be_valid
  end

  it "is not valid without a description or link" do
    meet.description = nil
    expect(meet).to_not be_valid
    meet.description = "Description"
    meet.link = nil
    expect(meet).to_not be_valid
  end

  it "is not valid with an invalid mode or status" do
    meet.mode = "invalid_mode"
    expect(meet).to_not be_valid
    meet.mode = "virtual"
    meet.status = "invalid_status"
    expect(meet).to_not be_valid
  end

  it "is not valid without a date_time when status is confirmed" do
    meet.status = "confirmed"
    meet.date_time = nil
    expect(meet).to_not be_valid
  end
end
