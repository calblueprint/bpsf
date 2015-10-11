var ShowGrantController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.extend(modal);
		me.extend(fundingBar);
		me.extend(setupStripe);
		me.extend(social);

		me.fundingProgress();
		me.modalBind();
		me.setupStripeForm();
		me.setupOfflinePayments();
		me.setupPayments();
		me.donorListHeight();
		me.bindSocial();
	}

	me.donorListHeight = function(){
		var donorList = me.documentObject.querySelector('.donor-container');
		if (donorList){
			donorList.style.height = String(me.documentObject.querySelector('#project').offsetHeight) + 'px';
		}
	}

	me.setupOfflinePayments = function(){
		$("#offline-donate").on('click', function(e) {
	    e.preventDefault();
	    if (!$('.offline_donation_amount').val()) {
	      $("#amount-alert").removeClass('hide');
	      $("#offline-amount-below-alert").addClass('hide');
	    } else if ($('.offline_donation_amount').val() <= 0) {
	      $("#amount-alert").addClass('hide');
	      $("#offline-amount-below-alert").removeClass('hide');
	    } else {
	      $("#amount-alert").addClass('hide');
	      $("#offline-amount-below-alert").addClass('hide');
	    }
	    if (!$('.donor_name').val()) {
	      $("#donor-alert").removeClass('hide');
	    } else {
	      $("#donor-alert").addClass('hide');
	    }
	    if ($('.offline_donation_amount').val() && $('.offline_donation_amount').val() > 0 && $('.donor_name').val()) {
	      $('#offline-donate').parents('form').bind('ajax:complete', function(){
					var confirmationModal = me.documentObject.querySelector('#offline-confirmation-modal'),
						closeButton = confirmationModal.querySelector('.xbox'),
						modalScreen = confirmationModal.querySelector('.modalscreen'),
						paymentModal = me.documentObject.querySelector('#offline-payment-form');

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
				var sure = confirm("Are you sure you want to submit this donation?");
    		if (sure) {
    			$('#offline-donate').parents('form').submit();
    		}
	    }
	  });
	}

	me.setupPayments = function(){
		$(".saved_card").on('click', function(e) {
	    e.preventDefault();
	    if (!$('.saved_donation_amount').val() || $('.saved_donation_amount').val() <= 0) {
	      $("#saved-amount-below-alert").removeClass('hide');
	    } else {
	      $("#saved-amount-below-alert").addClass('hide');
	    }
	    if ($('.saved_donation_amount').val() && $('.saved_donation_amount').val() > 0) {
				$('.saved_card').parents('form').bind('ajax:complete', function(){
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
				var sure = confirm("Are you sure you want to submit this donation?");
    		if (sure) {
					$('.saved_card').parents('form').submit();
				}
	    }
	  });

		$(".new_card").on('click', function(e) {
	    e.preventDefault();
	    if (!$('.donation_amount').val() || $('.donation_amount').val() <= 0) {
	      $("#amount-below-alert").removeClass('hide');
	    } else {
	      $("#amount-below-alert").addClass('hide');
	    }
	    if ($('.donation_amount').val() && $('.donation_amount').val() > 0) {
				var sure = confirm("Are you sure you want to submit this donation?");
    		if (sure) {
    			$('.new_card').prop('value', 'Submitting...');
    			$('.new_card').parent().css('border', 'none');
    			$('.new_card').prop('disabled', true);
					$('.new_card').parents('form').submit();
				}
	    }
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
