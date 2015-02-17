# The only changes from this to the original are the addition of line-item-price-edit/show to toggleLineItemEdit
# and addition of price to adjustLineItem

$(document).ready ->
  #handle edit click
  $('a.edit-line-item').click toggleLineItemEdit

  #handle cancel click
  $('a.cancel-line-item').click toggleLineItemEdit

  #handle save click
  $('a.save-line-item').click ->
    save = $ this
    line_item_id = save.data('line-item-id')
    quantity = parseInt(save.parents('tr').find('input.line_item_quantity').val())
    price = parseInt(save.parents('tr').find('input.line_item_price').val())
    toggleItemEdit()
    adjustLineItem(line_item_id, quantity, price)
    false

  # handle delete click
  $('a.delete-line-item').click ->
    if confirm(Spree.translations.are_you_sure_delete)
      del = $(this);
      line_item_id = del.data('line-item-id');

      toggleItemEdit()
      deleteLineItem(line_item_id)

toggleLineItemEdit = ->
  link = $(this);
  link.parent().find('a.edit-line-item').toggle();
  link.parent().find('a.cancel-line-item').toggle();
  link.parent().find('a.save-line-item').toggle();
  link.parent().find('a.delete-line-item').toggle();
  link.parents('tr').find('td.line-item-qty-show').toggle();
  link.parents('tr').find('td.line-item-qty-edit').toggle();

  # These 2 lines were added for this extension
  link.parents('tr').find('td.line-item-price-edit').toggle();
  link.parents('tr').find('td.line-item-price-show').toggle();


  false

lineItemURL = (line_item_id) ->
  url = Spree.routes.orders_api + "/" + order_number + "/line_items/" + line_item_id + ".json"

# price added to this method call for this extension
adjustLineItem = (line_item_id, quantity, price) ->
  url = lineItemURL(line_item_id)
  $.ajax(
    type: "PUT",
    url: Spree.url(url),
    data:
      line_item:
        quantity: quantity
        # price added to the line_item object for this extension
        price: price
  ).done (msg) ->
    window.Spree.advanceOrder()



deleteLineItem = (line_item_id) ->
  url = lineItemURL(line_item_id)
  $.ajax(
    type: "DELETE"
    url: Spree.url(url)
  ).done (msg) ->
    $('#line-item-' + line_item_id).remove()
    if $('.line-items tr.line-item').length == 0
      $('.line-items').remove()
    window.Spree.advanceOrder()