require 'rails_helper'

RSpec.describe AvailabilityTutor, type: :model do
    let!(:university) { FactoryBot.create(:university) }
    let!(:subject) { FactoryBot.create(:subject, university: university) }
    let!(:topic) { FactoryBot.create(:topic, subject: subject) }
    let!(:user) { FactoryBot.create(:user) }
    let!(:availability_tutor) { FactoryBot.create(:availability_tutor, user: user, topic: topic) }

    describe 'Validations' do
        it 'is valid with valid attributes' do
          expect(availability_tutor).to be_valid
        end
    end

    describe 'Associations' do
      it 'belongs to a user' do
        expect(availability_tutor.user).to eq(user)
      end

      it 'belongs to a topic' do
        expect(availability_tutor.topic).to eq(topic)
      end

      it 'has many interesteds' do
        expect(availability_tutor).to respond_to(:interesteds)
        expect(availability_tutor.interesteds).to be_an(ActiveRecord::Associations::CollectionProxy)
      end

      it 'has many interested_users through interesteds' do
        expect(AvailabilityTutor.reflect_on_association(:interested_users).macro).to eq(:has_many)
        expect(AvailabilityTutor.reflect_on_association(:interested_users).options[:through]).to eq(:interesteds)
      end

      it 'has many meets' do
        expect(AvailabilityTutor.reflect_on_association(:meets).macro).to eq(:has_many)
      end
    end

    describe 'Dependent Destroy' do
      it 'destroys associated interesteds when availability_tutor is destroyed' do
        interested = FactoryBot.create(:interested, availability_tutor: availability_tutor)
        expect { availability_tutor.destroy }.to change { Interested.count }.by(-1)
      end

      it 'destroys associated meets when availability_tutor is destroyed' do
        meet = FactoryBot.create(:meet, availability_tutor: availability_tutor)
        expect { availability_tutor.destroy }.to change { Meet.count }.by(-1)
      end
    end
end
