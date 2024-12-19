require 'rails_helper'

RSpec.describe Car, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:plate_number) }
    it { should validate_presence_of(:model_number) }
    it { should validate_uniqueness_of(:plate_number).case_insensitive }
    it { should validate_length_of(:plate_number).is_at_least(1).is_at_most(30) }
    it { should validate_length_of(:model_number).is_at_least(1).is_at_most(50) }
    it { should validate_numericality_of(:year).only_integer.is_greater_than_or_equal_to(1900).is_less_than_or_equal_to(Date.today.year) }
    it { should validate_presence_of(:year) }
    it { should have_many(:maintenance_services) }
  end


  describe 'before_save' do
    it 'sets the plate_number to uppercase' do
      car = create(:car, plate_number: 'abc123')
      expect(car.plate_number).to eq('ABC123')
    end
  end

  describe "validate year" do
    it 'validates the year' do
      car = build(:car, year: 1899)
      expect(car).not_to be_valid
      expect(car.errors[:year]).to include("debe ser mayor que o igual a 1900")
    end

    it 'validates the year is less than or equal to the current year' do
      car = build(:car, year: Date.today.year + 1)
      expect(car).not_to be_valid
      expect(car.errors[:year]).to include("debe ser menor que o igual a #{Date.today.year}")
    end
  end

  describe 'self.ransackable_attributes' do
    it 'returns the plate_number attribute' do
      expect(Car.ransackable_attributes).to include('plate_number')
    end
  end
end
