Spree::Api::ShipmentsController.class_eval do
	def add
	  variant = Spree::Variant.find(params[:variant_id])
	  quantity = params[:quantity].to_i
	  add_options = {}
	  add_options[:price] = params[:price].to_f if params[:price]
	  add_options[:line_item_id] = params[:line_item_id] if params[:line_item_id]
	  add_options[:force_new_line_item] = params[:force_new_line_item] if params[:force_new_line_item].present?
	  @shipment.order.contents.add_with_options(variant, quantity, nil, @shipment, add_options)
		respond_with(@shipment, default_template: :show)
	end

	def remove
	  variant = Spree::Variant.find(params[:variant_id])
	  quantity = params[:quantity].to_i
	  remove_options = {}
	  remove_options[:price] = params[:price].to_f if params[:price]
	  remove_options[:line_item_id] = params[:line_item_id] if params[:line_item_id]
	  @shipment.order.contents.remove_with_options(variant, quantity, @shipment, remove_options)
	  @shipment.reload if @shipment.persisted?
	  respond_with(@shipment, default_template: :show)
	end
end
