# frozen_string_literal: true

require 'forwardable'

module BricklinkApiWrapper
  class PriceGuide
    extend Forwardable

    BASE_PATH = '/items'

    def_delegators :@data, :item_no, :condition, :new_or_used, :currency_code,
                   :min_price, :max_price, :avg_price, :qty_avg_price, :unit_quantity

    def initialize(data)
      @data = data
    end

    SUPPORTED_INDEX_PARAMS = %i[
      color_id
      guide_type
      new_or_used
      country_code
      region
      currency_code
    ].freeze

    def self.get(type, item_no, params = {})
      supported_params = params.slice(*SUPPORTED_INDEX_PARAMS)
      query_string = supported_params.empty? ? '' : "?#{URI.encode_www_form(supported_params)}"

      payload = Bricklink::Api.new.get("#{BASE_PATH}/#{type}/#{item_no}/price#{query_string}")

      return unless payload.meta.code == 200

      new(payload.data)
    end
  end
end
