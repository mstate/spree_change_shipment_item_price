Spree::Api::LineItemsController.class_eval do

	def method_name
		options[:force_new_line_item]
	end
	def create
    variant = Spree::Variant.find(params[:line_item][:variant_id])
    # added force_new_line_item: true - requires spree_option_is_product to ensure new line item created.
    @line_item = order.contents.add(variant, (params[:line_item][:quantity] || 1), force_new_line_item: true)

    if @line_item.errors.empty?
      respond_with(@line_item, status: 201, default_template: :show)
    else
      invalid_resource!(@line_item)
    end
  end

	private	
	  def line_items_attributes
	    attributes_to_return = {line_items_attributes: {
	        id: params[:id],
	        quantity: params[:line_item][:quantity],
	        options: line_item_params[:options] || {}
	    }}
	    attributes_to_return[:line_items_attributes][:price] = params[:line_item][:price] if @current_user_roles && @current_user_roles.include?("admin")
	    attributes_to_return
	  end
end