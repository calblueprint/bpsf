customer =
  setupForm: ->
    $("#edit_user").submit ->
      $("input[type=submit]").attr "disabled", true
      if $("#card_number").length and $("#card_number").val().length > 0
        customer.processCustomer()
        false
      else
        true


  processCustomer: ->
    card = undefined
    card =
      number: $("#card_number").val()
      cvc: $("#card_code").val()
      expMonth: $("#card_month").val()
      expYear: $("#card_year").val()

    Stripe.createToken card, customer.stripeResponseHandler

  stripeResponseHandler: (status, response) ->
    if status is 200
      $("#stripe_token").val response.id
      $("input[type=submit]").attr "disabled", false
      alert "loop"
      $("#edit_user")[0].submit()
    else
      $("#stripe-error").text response.error.message
      $("input[type=submit]").attr "disabled", false

$(document).ready = ->
  Stripe.setPublishableKey $("meta[name='stripe-key']").attr("content")
  customer.setupForm()
