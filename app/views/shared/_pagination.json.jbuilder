json.pagination do
  json.current_page @pagy.page
  json.total_pages @pagy.pages
  json.total_count @pagy.count
  json.next_url @pagy.page < @pagy.pages ? url(page: @pagy.next) : nil
  json.prev_url @pagy.page > 1 ? url(page: @pagy.prev) : nil
end
