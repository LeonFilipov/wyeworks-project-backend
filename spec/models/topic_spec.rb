require 'rails_helper'

RSpec.describe Topic, type: :model do
    let!(:university) { FactoryBot.create(:university) }
    let!(:subject) { FactoryBot.create(:subject, university: university) }
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
  
      it 'is invalid with a non-unique name' do
        create(:topic, name: topic.name, subject: subject)
        expect(topic).not_to be_valid
        expect(topic.errors[:name]).to include('has already been taken')
      end
    end
  
    ### 2. Asociaciones
  
    context 'Associations' do
      it { should belong_to(:subject) }
      it { should have_many(:student_topics).dependent(:destroy) }
      it { should have_many(:users).through(:student_topics) }
      it { should have_many(:availability_tutors).dependent(:destroy) }
      it { should have_many(:users).through(:availability_tutors) }
    end
  
    ### 3. Dependent destroy
  
    context 'Dependent destroy' do
      it 'destroys associated student_topics when topic is destroyed' do
        topic.save!
        student_topic = create(:student_topic, topic: topic)
        expect { topic.destroy }.to change(StudentTopic, :count).by(-1)
      end
  
      it 'destroys associated availability_tutors when topic is destroyed' do
        topic.save!
        availability_tutor = create(:availability_tutor, topic: topic)
        expect { topic.destroy }.to change(AvailabilityTutor, :count).by(-1)
      end
    end
end