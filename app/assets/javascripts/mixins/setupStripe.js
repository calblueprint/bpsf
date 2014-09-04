var setupStripe = {
	setupStripeForm: function(){
		var me = this;
		Stripe.setPublishableKey($("meta[name='stripe-key']").attr("content"));
		me.setupCustomerForm();
	},
	processCustomerForm: function(){
		var me = this,
			card = {
				name: $("#card_name").val(),
				number: $("#card_number").val(),
				cvc: $("#card_code").val(),
				expMonth: $("#card_month").val(),
				expYear: $("#card_year").val(),
				address_line1: $("#address_line1").val(),
				address_line2: $("#address_line2").val(),
				address_city: $("#address_city").val(),
				address_zip: $("#address_zip").val(),
				address_state: $("#address_state").val(),
				address_country: $("#address_country").val()
			};
		Stripe.createToken(card, me.stripeResponseHandler);
	}
}