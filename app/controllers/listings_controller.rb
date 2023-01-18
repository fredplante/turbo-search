class ListingsController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @listings = pagy(current_filter.results, items: 12, page: current_filter.page, size: [1, 1, 1, 1])
  rescue Pagy::OverflowError
    @pagy, @listings = pagy(current_filter.results, items: 12, page: 1, size: [1, 1, 1, 1])
  end

  private

  def filter_params
    params.permit(
      :query,
      :min_price,
      :max_price,
      :page,
      :order_by,
      :direction,
      category: [],
      tag: [],
      format: []
    )
  end
  helper_method :filter_params

  def current_filter
    current_filter ||= ListingFilter.new(filter_params)
  end
  helper_method :current_filter
end
