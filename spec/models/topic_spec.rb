require 'rails_helper'

RSpec.describe Topic, type: :model do
  let!(:university) { FactoryBot.create(:university) }
  let!(:career) { FactoryBot.create(:career, university: university) }
  let!(:subject) { FactoryBot.create(:subject, career: career) }
  let!(:topic) { FactoryBot.create(:topic, subject: subject) }

  ### 1. Validaciones

  context 'Validations' do
    it 'is valid with valid attributes' do
      expect(topic).to be_valid
    end

    it 'is invalid without a name' do
      topic.name = nil
      expect(topic).not_to be_valid
      expect(topic.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a subject_id' do
      topic.subject_id = nil
      expect(topic).not_to be_valid
      expect(topic.errors[:subject_id]).to include("can't be blank")
    end
  end
end
