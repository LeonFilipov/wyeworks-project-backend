require 'rails_helper'


RSpec.describe Subject, type: :model do
let!(:university) { FactoryBot.create(:university) }

describe "validations" do
    it "is valid with valid attributes" do
        subject = FactoryBot.build(:subject, university: university)
        expect(subject).to be_valid
    end

    it "is not valid without a name" do
        subject = FactoryBot.build(:subject, university: university, name: nil)
        expect(subject).to_not be_valid
    end

    it "is not valid without a university" do
        subject = FactoryBot.build(:subject, university: nil)
        expect(subject).to_not be_valid
    end
end

describe "associations" do
    it "belongs to university" do
        association = described_class.reflect_on_association(:university)
        expect(association.macro).to eq(:belongs_to)
    end

    it "has many topics" do
        association = described_class.reflect_on_association(:topics)
        expect(association.macro).to eq(:has_many)
    end
end
end
