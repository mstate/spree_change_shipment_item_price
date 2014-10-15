module Spree
  class OrderContents
		def add_with_options(variant, quantity = 1, currency = nil, shipment = nil, options={})
      line_item = add_to_line_item_with_options(variant, quantity, currency, shipment, options)
      reload_totals
      shipment.present? ? shipment.update_amounts : order.ensure_updated_shipments
      PromotionHandler::Cart.new(order, line_item).activate
      ItemAdjustments.new(line_item).update
      reload_totals
      line_item
    end

    def remove_with_options(variant, quantity = 1, shipment = nil, options={})
      line_item = remove_from_line_item_with_options(variant, quantity, shipment, options)
      reload_totals
      shipment.present? ? shipment.update_amounts : order.ensure_updated_shipments
      PromotionHandler::Cart.new(order, line_item).activate
      ItemAdjustments.new(line_item).update
      reload_totals
      line_item
    end


		private

      def add_to_line_item_with_options(variant, quantity, currency=nil, shipment=nil, options={})
      
        line_item =  grab_line_item_by_id(options[:line_item_id], raise_error = false, options) if options[:line_item_id]

        line_item ||= grab_line_item_by_variant(variant)
        if line_item
          line_item.target_shipment = shipment
          line_item.quantity += quantity.to_i
          line_item.currency = currency unless currency.nil?
          line_item.price = options[:price] if options[:price]
        else
          line_item = order.line_items.new(quantity: quantity, variant: variant)
          line_item.target_shipment = shipment
          if currency
            line_item.currency = currency
            line_item.price    = options[:price] || variant.price_in(currency).amount
          else
            line_item.price    = options[:price] || variant.price
          end
        end

        line_item.save
        line_item
      end

      def remove_from_line_item_with_options(variant, quantity, shipment=nil, options={})
        line_item =  grab_line_item_by_id(options[:line_item_id], raise_error = false, options) if options[:line_item_id]
        line_item ||= grab_line_item_by_variant(variant)

        line_item.quantity += -quantity
        line_item.target_shipment= shipment
        line_item.price = options[:price] if options[:price]


        if line_item.quantity == 0
          line_item.destroy
        else
          line_item.save!
        end

        line_item
      end

      def grab_line_item_by_id(line_item_id, raise_error = false, options = {})
        line_item = order.line_items.find(line_item_id)

        if !line_item.present? && raise_error
          raise ActiveRecord::RecordNotFound, "Line item not found for variant #{variant.sku}"
        end

        line_item
      end
  end
end
