class ListingFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  SORTING_OPTIONS = [
    { column: "created_at", direction: "desc", text: "Recently added" },
    { column: "price", direction: "asc", text: "Price: Low to High" },
    { column: "price", direction: "desc", text: "Price: High to Low" }
  ]

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
  attribute :order_by, :string, default: "created_at"
  attribute :direction, :string, default: "desc"

  def results
    order_by = SORTING_OPTIONS.map { |opt| opt[:column] }.uniq.include?(order_by) ? order_by : DEFAULT_SORTING_OPTION[:column]
    direction = SORTING_OPTIONS.map { |opt| opt[:direction] }.uniq.include?(direction) ? direction : DEFAULT_SORTING_OPTION[:direction]

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
      .reorder(order_by => direction)
      .limit(200)
  end

  def selected_sorting_option
    @selected_sorting_option ||= (SORTING_OPTIONS.find { |option| order_by == option[:column] && direction == option[:direction] } || SORTING_OPTIONS.first)
  end
end
