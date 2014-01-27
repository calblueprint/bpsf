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
      number: $("#card_number").val()
      cvc: $("#card_code").val()
      expMonth: $("#card_month").val()
      expYear: $("#card_year").val()

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
  $(".donate").click ->
    $("#payment-modal").toggleClass "active"

  $(".close-payment-form").click ->
    $("#payment-modal").removeClass "active"

  $(".crowdfund").click ->
    $("#crowdfund-form").addClass "active"

  $(".close-crowdfund-modal").click ->
    $("#crowdfund-form").removeClass "active"

  $(".close-confirmation-modal").click ->
    $("#confirmation-form").removeClass "active"
    $("#payment-form").removeClass "active"

  $(document).keyup (e) ->
    if e.keyCode is 27
      $("#crowdfund-form").removeClass "active"  if $("#crowdfund-form").hasClass("active")
      $("#payment-modal").removeClass "active"  if $("#payment-modal").hasClass("active")
      $("#confirmation-modal").removeClass "active"  if $("#confirmation-modal").hasClass("active")
