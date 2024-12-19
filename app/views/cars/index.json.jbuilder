json.cars do
  json.array! @cars, partial: "cars/car", as: :car
end

json.pagination do
  json.partial! "shared/pagination", pagy: @pagy, url: api_v1_cars_url
end
