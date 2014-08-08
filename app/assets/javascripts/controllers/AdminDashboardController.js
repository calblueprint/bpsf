var AdminDashboardController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.manageTabs();
	}
}

AdminDashboardController.prototype = Object.create(AppController.prototype);
AdminDashboardController.prototype.constructor = AdminDashboardController;