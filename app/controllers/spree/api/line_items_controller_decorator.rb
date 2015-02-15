Spree::Api::LineItemsController.class_eval do
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