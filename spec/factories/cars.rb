FactoryBot.define do
  factory :car do
    plate_number { Faker::Vehicle.vin }
    model_number { Faker::Vehicle.make }
    year { Faker::Vehicle.year }
  end
end
