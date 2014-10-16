toggleItemEdit = function(){
  var link = $(this);
  link.parent().find('a.edit-item').toggle();
  link.parent().find('a.cancel-item').toggle();
  link.parent().find('a.split-item').toggle();
  link.parent().find('a.save-item').toggle();
  link.parent().find('a.delete-item').toggle();
  link.parents('tr').find('td.item-qty-show').toggle();
  link.parents('tr').find('td.item-qty-edit').toggle();
  link.parents('tr').find('td.item-price-edit').toggle();
  link.parents('tr').find('td.item-price-show').toggle();

  return false;
}

function isNullOrUndef(variable) {
    return (variable === undefined || variable === null );
}

// added new method instead of adjustShipmentItems as this one has more parameters.
adjustSpecificShipmentItem = function(shipment_number, variant_id, quantity, original_quantity,  price, line_item_id, force_new_line_item){
    var shipment = _.findWhere(shipments, {number: shipment_number + ''});
    // var inventory_units = _.where(shipment.inventory_units, {variant_id: variant_id});

    var url = Spree.routes.shipments_api + "/" + shipment_number;

    var new_quantity = 0;
    
    if(original_quantity<quantity){
      url += "/add"
      new_quantity = (quantity - original_quantity);
    }else if(original_quantity>quantity){
      url += "/remove"
      new_quantity = (original_quantity - quantity);
    }else if(typeof price != 'undefined'){
      url += "/add"
      new_price = price;
    }

    url += '.json';
    var changes_to_line_item = {variant_id: variant_id};
    if(new_quantity != 0){
      changes_to_line_item.quantity = new_quantity
    }
    if(!isNullOrUndef(price)) {
      changes_to_line_item.price = price
    }
    if(!isNullOrUndef(force_new_line_item)){
      changes_to_line_item.force_new_line_item = force_new_line_item
    }
    if(!isNullOrUndef(line_item_id)){
      changes_to_line_item.line_item_id = line_item_id
    }


    if( new_quantity != 0 || !isNullOrUndef(changes_to_line_item.price) ){
      $.ajax({
        type: "PUT",
        url: Spree.url(url),
        data: changes_to_line_item
      }).done(function( msg ) {
        window.location.reload();
      });
    }
}

addVariantFromStockLocation = function() {
  $('#stock_details').hide();

  var variant_id = $('input.variant_autocomplete').val();
  var stock_location_id = $(this).data('stock-location-id');
  var quantity = $("input.quantity[data-stock-location-id='" + stock_location_id + "']").val();
  var original_quantity = 0;
  var force_new_line_item = true;
  var shipment = _.find(shipments, function(shipment){
    return shipment.stock_location_id == stock_location_id && (shipment.state == 'ready' || shipment.state == 'pending');
  });

  if(shipment==undefined){
    $.ajax({
      type: "POST",
      url: Spree.url(Spree.routes.shipments_api + "?shipment[order_id]=" + order_number),
      data: { variant_id: variant_id, quantity: quantity, stock_location_id: stock_location_id, force_new_line_item: force_new_line_item}
    }).done(function( msg ) {
      window.location.reload();
    }).error(function( msg ) {
      console.log(msg);
    });
  }else{
    //add to existing shipment as new line item.
    adjustSpecificShipmentItem(shipment.number, variant_id, quantity, original_quantity, null, null, force_new_line_item );
  }
  return 1
}


$(document).ready(function () {
  'use strict';

//handle save click
  $('a.save-item').unbind( "click" ); // unbind the line_items.js click event from spree_product_assembly and use ours instead.
  $('a.save-item').click(function(){
    var save = $(this);
    var shipment_number = save.data('shipment-number');
    var variant_id = save.data('variant-id');

    var quantity = parseInt(save.parents('tr').find('input.line_item_quantity').val());
    var original_quantity = parseInt(save.parents('tr').find('input.line_item_quantity')[0].getAttribute('data-original-quantity'));
    var price = parseInt(save.parents('tr').find('input.line_item_price').val());
    var line_item_id = parseInt(save.parents('tr').find('input.line_item_id').val());

    toggleItemEdit();
    adjustSpecificShipmentItem(shipment_number, variant_id, quantity, original_quantity, price, line_item_id);
    return false;
  });

});

