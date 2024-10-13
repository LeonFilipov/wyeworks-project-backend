require 'rails_helper'

RSpec.describe User, type: :model do
  # Validaciones
  it "is valid with valid attributes" do
    user = FactoryBot.build(:user, email: "test@example.com", uid: "12345")
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    user = FactoryBot.build(:user, email: nil)
    expect(user).to_not be_valid
  end

  it "is not valid without a uid" do
    user = FactoryBot.build(:user, uid: nil)
    expect(user).to_not be_valid
  end

  it "is not valid with a duplicate email" do
    FactoryBot.create(:user, email: "test@example.com", uid: "12345")
    user = FactoryBot.build(:user, email: "test@example.com", uid: "67890")
    expect(user).to_not be_valid
  end

  it "is not valid with a duplicate uid" do
    FactoryBot.create(:user, email: "test@example.com", uid: "12345")
    user = FactoryBot.build(:user, email: "another@example.com", uid: "12345")
    expect(user).to_not be_valid
  end

  it "is not valid if ranking is not an integer" do
    user = FactoryBot.build(:user, ranking: 1.5)
    expect(user).to_not be_valid
  end

  it "is valid if ranking is nil" do
    user = FactoryBot.build(:user, ranking: nil)
    expect(user).to be_valid
  end

  # Validaciones de atributos numéricos
  it "is not valid if amount_given_lessons is not an integer" do
    user = FactoryBot.build(:user, amount_given_lessons: 3.5)
    expect(user).to_not be_valid
  end

  it "is valid if amount_given_lessons is nil" do
    user = FactoryBot.build(:user, amount_given_lessons: nil)
    expect(user).to be_valid
  end

  # Test del método de autenticación de Google
  describe ".google_auth" do
    let(:user_info) { { "email" => "test@example.com", "name" => "Test User", "sub" => "12345", "picture" => "http://example.com/image.jpg" } }

    it "creates a new user if the email does not exist" do
      user = User.google_auth(user_info)
      user.save 
      expect(user).to be_persisted
      expect(user.name).to eq("Test User")
      expect(user.email).to eq("test@example.com")
      expect(user.uid).to eq("12345")
      expect(user.image_url).to eq("http://example.com/image.jpg")
    end

    it "returns an existing user if the email already exists" do
      existing_user = FactoryBot.create(:user, email: "test@example.com", uid: "12345")
      user = User.google_auth(user_info)
      expect(user).to eq(existing_user)
    end
  end
end
