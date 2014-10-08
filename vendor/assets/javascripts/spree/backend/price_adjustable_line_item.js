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

adjustShipmentItems = function(shipment_number, variant_id, quantity, price){
    var shipment = _.findWhere(shipments, {number: shipment_number + ''});
    var inventory_units = _.where(shipment.inventory_units, {variant_id: variant_id});

    var url = Spree.routes.shipments_api + "/" + shipment_number;

    var new_quantity = 0;
    if(inventory_units.length<quantity){
      url += "/add"
      new_quantity = (quantity - inventory_units.length);
    }else if(inventory_units.length>quantity){
      url += "/remove"
      new_quantity = (inventory_units.length - quantity);
    }else if(typeof price != 'undefined'){
      url += "/add"
      new_price = price;
    }

    url += '.json';
    var changes_to_line_item = {variant_id: variant_id}
    if(new_quantity!=0){
      changes_to_line_item.quantity = new_quantity
    }
    if(typeof price != 'undefined'){
      changes_to_line_item.price = price
    }

    if(new_quantity!=0 || typeof price != 'undefined'){
      $.ajax({
        type: "PUT",
        url: Spree.url(url),
        data: changes_to_line_item
      }).done(function( msg ) {
        window.location.reload();
      });
    }
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
    var price = parseInt(save.parents('tr').find('input.line_item_price').val());

    toggleItemEdit();
    adjustShipmentItems(shipment_number, variant_id, quantity, price);
    return false;
  });

});