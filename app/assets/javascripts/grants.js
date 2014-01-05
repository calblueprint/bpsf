// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


var payment;
$(document).ready(function() {
	Stripe.setPublishableKey($("meta[name='stripe-key']").attr("content"));
	payment.setupForm();

	$(".donate").click(function(){
		$("#payment-modal").toggleClass("active");
	});

	$(".close-payment-form").click(function() {
		$("#payment-modal").removeClass("active");
	});

	$(".crowdfund").click(function() {
		$("#crowdfund-form").addClass("active");
	});

	$(".close-crowdfund-modal").click(function() {
		$("#crowdfund-form").removeClass("active");
	});

	$(".close-confirmation-modal").click(function() {
		$("#confirmation-form").removeClass("active");
		$("#payment-form").removeClass("active");
	});

	$(document).keyup(function(e) {
		if (e.keyCode == 27) {
			if ($("#crowdfund-form").hasClass("active")) {
				$("#crowdfund-form").removeClass("active")
			}
			if ($("#payment-modal").hasClass("active")) {
				$("#payment-modal").removeClass("active");
			}
			if ($("#confirmation-modal").hasClass("active")) {
				$("#confirmation-modal").removeClass("active");
			}
		}
	});
});


payment = {
	setupForm: function() {
				   $("#new_payment").submit(function() {
					   $("input[type=submit]").attr("disabled", true);
					   if ($("#card_number").length) {
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
				     number: $("#card_number").val(),
				     cvc: $("#card_code").val(),
				     expMonth: $("#card_month").val(),
				     expYear: $("#card_year").val()
			     };
			     Stripe.createToken(card, payment.stripeResponseHandler);
		     },
	stripeResponseHandler: function(status, response) {
				       if (status == 200) {
					       $("#stripe_token").val(response.id);
					       return $("#new_payment")[0].submit();
				       } else {
					       $("#stripe_error").text(response.error.message);
					       return $("input[type=submit]").attr("disabled", false);
				       }
			       }
};

