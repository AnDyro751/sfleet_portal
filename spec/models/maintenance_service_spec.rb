require 'rails_helper'

RSpec.describe MaintenanceService, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:date) }
    it { should belong_to(:car) }
  end


  describe 'self.ransackable_attributes' do
    it 'returns the status attribute' do
      expect(MaintenanceService.ransackable_attributes).to include('status')
    end
  end

  describe 'ransacker status' do
    it 'formats the status for searches' do
      servicio = create(:maintenance_service, status: :pending)
      resultado = MaintenanceService.ransack(status_eq: 'pending').result
      expect(resultado).to include(servicio)
    end
  end

  describe 'self.ransackable_associations' do
    it 'returns the car attribute' do
      expect(MaintenanceService.ransackable_associations).to include('car')
    end
  end

  describe "default scope" do
    it 'orders by date descending' do
      car = create(:car)
      maintenance_service = create(:maintenance_service,
        date: Date.today - 12.days,
        car: car
      )
      maintenance_service2 = create(:maintenance_service,
        date: Date.today - 2.days,
        car: car
      )
      maintenance_service3 = create(:maintenance_service,
        date: Date.today - 3.days,
        car: car
      )

      expect(MaintenanceService.all).to eq([
        maintenance_service2,
        maintenance_service3,
        maintenance_service
      ])
    end
  end

  describe 'validate status' do
    it 'validates the status is a valid enum value' do
      expect { build(:maintenance_service, status: 'invalid') }.to raise_error(ArgumentError)
    end

    it 'accepts valid enum values' do
      expect(build(:maintenance_service, status: :pending)).to be_valid
      expect(build(:maintenance_service, status: :in_progress)).to be_valid
      expect(build(:maintenance_service, status: :completed)).to be_valid
    end
  end

  describe 'validate date' do
    it 'validates the date is a valid date' do
      maintenance_service = build(:maintenance_service, date: Date.today + 1.year)
      expect(maintenance_service).not_to be_valid
      expect(maintenance_service.errors[:date]).to include("Debe ser una fecha válida")
    end

    it 'validates the date is in the past' do
      maintenance_service = build(:maintenance_service, date: Date.today - 1.year)
      expect(maintenance_service).to be_valid
    end
  end
end
