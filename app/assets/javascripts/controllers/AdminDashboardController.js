var AdminDashboardController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.manageTabs();

		$(".chosenselect").chosen({width:'90%'});
		$("input[name=donors]").attr("disabled", true).addClass('disabled');
		$("#donor-selection").change(function() {
			var selection = $("#donor-selection")[0].selectedIndex;
			if (selection == 0) {
				// Placeholder
				$("input[name=donors]").attr("disabled", true);
			} else {
				$("input[name=donors]").attr("disabled", false);
			}
		});
	}
}

AdminDashboardController.prototype = Object.create(AppController.prototype);
AdminDashboardController.prototype.constructor = AdminDashboardController;