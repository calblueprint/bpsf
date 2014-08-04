var ShowGrantController = function(documentObject){
	var me = this;
	HomeController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.fundingProgress();
	}

	me.socialButtons = function(){
		
	}

}

ShowGrantController.prototype = Object.create(HomeController.prototype);
ShowGrantController.prototype.constructor = ShowGrantController;
