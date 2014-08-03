var ShowGrantController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){}

	me.socialButtons = function(){}

}

ShowGrantController.prototype = Object.create(AppController.prototype);
ShowGrantController.prototype.constructor = ShowGrantController;
