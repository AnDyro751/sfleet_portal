json.extract! maintenance_service, :id, :car_id, :description, :status, :date, :created_at, :updated_at
json.url api_v1_maintenance_service_url(maintenance_service, format: :json)
