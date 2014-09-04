var EditGrantController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.extend(tabs);
		me.manageTabs();
	}
}

EditGrantController.prototype = Object.create(AppController.prototype);
EditGrantController.prototype.constructor = EditGrantController;