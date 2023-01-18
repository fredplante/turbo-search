class ListingFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

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
end
