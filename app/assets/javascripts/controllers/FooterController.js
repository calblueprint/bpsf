var FooterController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.extendPageLength();
	}
	
}

FooterController.prototype = Object.create(AppController.prototype);
FooterController.prototype.constructor = FooterController;

FooterController.prototype.extendPageLength = function(){
	var me = this,
		overflow = me.documentObject.offsetTop + me.documentObject.offsetHeight - window.innerHeight,
		paddingTop = overflow > 0 ? 0 : -overflow;
	me.documentObject.style.paddingTop = paddingTop + 'px'; 
}