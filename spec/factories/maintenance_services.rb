FactoryBot.define do
  factory :maintenance_service do
    description { Faker::Lorem.sentence }
    status { :pending }
    date { Faker::Date.backward }
    car { create(:car) }
  end
end
