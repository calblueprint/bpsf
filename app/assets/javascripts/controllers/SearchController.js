var SearchController = function(documentObject){
	var me = this;
	HomeController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.fundingProgress();
		me.turbolinkBind();
	}
}

SearchController.prototype = Object.create(HomeController.prototype);
SearchController.prototype.constructor = SearchController;
