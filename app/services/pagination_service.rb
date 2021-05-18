class PaginationService
  def self.paginate(query, page = 1, data_accessor_property)
    data = query.page(page)
    has_previous_page = query.page(page).prev_page
    has_next_page = query.page(page).next_page
    pages_count = query.page(page).total_pages

    {
      data_accessor_property || "data" => data,
      has_previous_page: !!has_previous_page,
      has_next_page: !!has_next_page,
      pages_count: pages_count
    }
  end
end