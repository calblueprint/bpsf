var RegistrationController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.checkboxBind();
		me.modalBind();
	}
}

RegistrationController.prototype = Object.create(AppController.prototype);
RegistrationController.prototype.constructor = RegistrationController;
