class ListingsController < ApplicationController
  include Pagy::Backend

  SORTING_OPTIONS = [
    { column: "created_at", direction: "desc", text: "Recently added" },
    { column: "price", direction: "asc", text: "Price: Low to High" },
    { column: "price", direction: "desc", text: "Price: High to Low" }
  ]

  DEFAULT_SORTING_OPTION = SORTING_OPTIONS.first

  def index
    @filter = ListingFilter.new
    @pagy, @listings = pagy(@filter.results, items: 12, page: @filter.page, size: [1,1,1,1])
  rescue Pagy::OverflowError
    @pagy, @listings = pagy(@filter.results, items: 12, page: 1, size: [1,1,1,1])
  end

  private

  def selected_sorting_option
    DEFAULT_SORTING_OPTION
  end
  helper_method :selected_sorting_option
end
