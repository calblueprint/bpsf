var UserController = function(documentObject){
	var me = this;
	ShowGrantController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.manageTabs();
	}
}

UserController.prototype = Object.create(ShowGrantController.prototype);
UserController.prototype.constructor = UserController;