var AdminDashboardController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.extend(customSelect);

		me.manageTabs();
		me.turbolinkBind();
		$(document).on('ajaxComplete', function(){
			me.turbolinkBind();
		});
		me.convertSelects();
	}
}

AdminDashboardController.prototype = Object.create(AppController.prototype);
AdminDashboardController.prototype.constructor = AdminDashboardController;