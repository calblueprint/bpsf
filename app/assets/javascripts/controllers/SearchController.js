var SearchController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.extend(fundingBar);
		
		me.fundingProgress();
		me.turbolinkBind();
	}
}

SearchController.prototype = Object.create(AppController.prototype);
SearchController.prototype.constructor = SearchController;
