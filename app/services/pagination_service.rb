class PaginationService
  def self.paginate(entity, page = 1, data_accessor_property)
    data = entity.page(page)
    has_previous_page = entity.page(page).prev_page
    has_next_page = entity.page(page).next_page
    pages_count = entity.page(page).total_pages

    {
      data_accessor_property || "data" => data,
      has_previous_page: !!has_previous_page,
      has_next_page: !!has_next_page,
      pages_count: pages_count
    }
  end
end