json.maintenance_services do
  json.array! @maintenance_services, partial: "maintenance_services/maintenance_service", as: :maintenance_service
end

json.pagination do
  json.current_page @pagy.page
  json.total_pages @pagy.pages
  json.total_count @pagy.count
  json.next_url @pagy.page < @pagy.pages ? api_v1_maintenance_services_url(page: @pagy.next) : nil
  json.prev_url @pagy.page > 1 ? api_v1_maintenance_services_url(page: @pagy.prev) : nil
end
