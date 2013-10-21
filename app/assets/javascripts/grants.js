// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


var payment;
$(document).ready(function() {
	Stripe.setPublishableKey($("meta[name='stripe-key']").attr("content"));
	return payment.setupForm();
});

payment = {
	setupForm: function() {
		return $("#new-payment").submit(function() {
			$("input[type=submit]").attr("disabled", true);
			if ($("#card-number").length) {
				payment.processCard();
				return false;
			} else {
				return true;
			}
		});
		   },
	processCard: function() {
			     var card;
			     card = {
				     number: $("#card-number").val(),
				     cvc: $("#card-code").val(),
				     expMonth: $("#card-month").val(),
				     expYear: $("#card-year").val()
			     };
			     return Stripe.createToken(card, payment.stripeResponseHandler);
		     },
	stripeResponseHandler: function(status, response) {
				       if (status == 200) {
					       $("#payment-stripe-token").val(response.id);
					       return $("#new-payment")[0].submit();
				       } else {
					       $("#stripe-error").text(response.error.message);
					       return $("input[type=submit]").attr("disabled", false);
				       }
			       }
};
