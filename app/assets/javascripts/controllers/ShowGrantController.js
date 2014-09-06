var ShowGrantController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.extend(modal);
		me.extend(fundingBar);
		me.extend(setupStripe);
		
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

ShowGrantController.prototype = Object.create(AppController.prototype);
ShowGrantController.prototype.constructor = ShowGrantController;
