json.extract! car, :id, :plate_number, :model_number, :year, :created_at, :updated_at
json.url api_v1_car_url(car, format: :json)
