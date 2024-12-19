json.maintenance_services do
  json.array! @maintenance_services, partial: "maintenance_services/maintenance_service", as: :maintenance_service
end

json.pagination do
  json.partial! "shared/pagination", pagy: @pagy, url: api_v1_maintenance_services_url
end
