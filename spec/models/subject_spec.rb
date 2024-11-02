require 'rails_helper'


RSpec.describe Subject, type: :model do
let!(:university) { FactoryBot.create(:university) }
let!(:career) { FactoryBot.create(:career, university: university) }

describe "validations" do
    it "is valid with valid attributes" do
        subject = FactoryBot.build(:subject, career: career)
        expect(subject).to be_valid
    end

    it "is not valid without a name" do
        subject = FactoryBot.build(:subject, career: career, name: nil)
        expect(subject).to_not be_valid
    end

    it "is not valid without a career" do
        subject = FactoryBot.build(:subject, career: nil)
        expect(subject).to_not be_valid
    end
end

describe "associations" do
    it "belongs to career" do
        association = described_class.reflect_on_association(:career)
        expect(association.macro).to eq(:belongs_to)
    end

    it "has many topics" do
        association = described_class.reflect_on_association(:topics)
        expect(association.macro).to eq(:has_many)
    end
end
end
