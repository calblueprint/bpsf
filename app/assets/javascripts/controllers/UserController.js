var UserController = function(documentObject){
	var me = this;
	ShowGrantController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.extend(tabs);
		me.manageTabs();
		me.setupStripeForm();
	}

	me.setupCustomerForm = function(){
		$('#edit_user').submit(function() {
			$("input[type=submit]").attr("disabled", true);
			if ($("#card_number").length && $("#card_number").val().length > 0) {
				me.processCustomerForm();
				return false;
			} else {
				$("input[type=submit]").attr("disabled", false);
				return false;
			}
		});
	}

	me.stripeResponseHandler = function(status, response) {
		if (status == 200) {
			$("#stripe_token").val(response.id);
			$("input[type=submit]").attr("disabled", false);
			return $("#edit_user")[0].submit();
		} else {
			$("#stripe-error").text(response.error.message);
			return $("input[type=submit]").attr("disabled", false);
		}
	}
}

UserController.prototype = Object.create(ShowGrantController.prototype);
UserController.prototype.constructor = UserController;