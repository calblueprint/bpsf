var NavigationController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		
	}

	
}

NavigationController.prototype = Object.create(AppController.prototype);
NavigationController.prototype.constructor = NavigationController;
