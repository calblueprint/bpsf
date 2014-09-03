var ShowGrantController = function(documentObject){
	var me = this;
	HomeController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.extend(modal);
		me.fundingProgress();
		me.modalBind();
		me.setupStripeForm();
		me.setupConfirmationModal();
		me.donorListHeight();
	}

	me.donorListHeight = function(){
		var donorList = me.documentObject.querySelector('.donor-list');
		if (donorList){
			donorList.style.height = String(me.documentObject.querySelector('#project').offsetHeight) + 'px';
		}
	}

	me.socialButtons = function(){
		
	}

	me.setupConfirmationModal = function(){
		$('.saved_card').parents('form').submit(function(){
			var confirmationModal = me.documentObject.querySelector('#confirmation-modal'),
				closeButton = confirmationModal.querySelector('.xbox'),
				modalScreen = confirmationModal.querySelector('.modalscreen'),
				paymentModal = me.documentObject.querySelector('#payment-form');

			me.activateElements(confirmationModal);
			me.deactivateElements(paymentModal);

			$(closeButton).on('click', function(e){
				me.clearActiveElements();
				e.preventDefault();
				return false;
			});

			$(modalScreen).on('click', function(e){
				me.clearActiveElements();
				e.preventDefault();
				return false;
			});
		});
	}

	me.setupCustomerForm = function(){
		$("#new_payment").submit(function() {
			$("input[type=submit]").attr("disabled", true);
			if ($("#card_number").length) {
				me.processCustomerForm();
				return false;
			} else {
				return true;
			}
		});
	}

	me.stripeResponseHandler = function(status, response){
		if (status === 200) {
			$("#stripe_token").val(response.id);
			$("#new_payment")[0].submit();
		} else {
			$("#stripe_error").text(response.error.message);
			$("input[type=submit]").attr("disabled", false);
		}
	}

}

ShowGrantController.prototype = Object.create(HomeController.prototype);
ShowGrantController.prototype.constructor = ShowGrantController;

	ShowGrantController.prototype.setupStripeForm = function(){
		var me = this;
		Stripe.setPublishableKey($("meta[name='stripe-key']").attr("content"));
		me.setupCustomerForm();
	}

	ShowGrantController.prototype.processCustomerForm = function(){
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
