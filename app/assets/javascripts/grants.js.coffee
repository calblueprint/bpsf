# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

payment =
  setupForm: ->
    $("#new_payment").submit ->
      $("input[type=submit]").attr "disabled", true
      if $("#card_number").length
        payment.processCard()
        false
      else
        true


  processCard: ->
    card =
      name: $("#card_name").val()
      number: $("#card_number").val()
      cvc: $("#card_code").val()
      expMonth: $("#card_month").val()
      expYear: $("#card_year").val()
      address_line1: $("#address_line1").val()
      address_line2: $("#address_line2").val()
      address_city: $("#address_city").val()
      address_zip: $("#address_zip").val()
      address_state: $("#address_state").val()
      address_country: $("#address_country").val()
    Stripe.createToken card, payment.stripeResponseHandler

  stripeResponseHandler: (status, response) ->
    if status is 200
      $("#stripe_token").val response.id
      $("#new_payment")[0].submit()
    else
      $("#stripe_error").text response.error.message
      $("input[type=submit]").attr "disabled", false

$(document).ready ->
  Stripe.setPublishableKey $("meta[name='stripe-key']").attr("content")
  payment.setupForm()
