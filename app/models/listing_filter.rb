class ListingFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  SORTING_OPTIONS = {
    created_at_asc: { column: "created_at", direction: "desc", text: "Recently added" },
    price_asc: { column: "price", direction: "asc", text: "Price: Low to High" },
    price_desc: { column: "price", direction: "desc", text: "Price: High to Low" }
  }

  DEFAULT_SORTING_OPTION = SORTING_OPTIONS.first

  # Filters
  attribute :query, :string
  attribute :min_price, :integer, default: 1
  attribute :max_price, :integer, default: Listing.max_price
  attribute :category, array: true, default: []
  attribute :tag, array: true, default: []
  attribute :format, array: true, default: []
  # Pagination
  attribute :page, :integer, default: 1
  # Sorting
  attribute :sorting, :string, default: "created_at_asc"

  def results
    filtered_listings_ids = Listing.for_sale
      .joins(print: :artwork)
      .price_between(min_price, max_price)
      .from_categories(category)
      .with_tags(tag)
      .with_formats(format)
      .pluck(:id)

    Listing
      .includes(artwork: { cover_image_attachment: :blob })
      .where(id: filtered_listings_ids)
      .search(query)
      .reorder(selected_sorting_option[:column] => selected_sorting_option[:direction])
      .limit(200)
  end

  def selected_sorting_option
    @selected_sorting_option ||= SORTING_OPTIONS[sorting.to_sym] || SORTING_OPTIONS[DEFAULT_SORTING_OPTION]
  end
end
