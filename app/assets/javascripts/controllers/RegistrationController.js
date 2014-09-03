var RegistrationController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.checkboxBind();
		me.modalBind();
		me.userSwitch();
	}

	me.userSwitch = function(){
		var select = me.documentObject.querySelector('#account-select').querySelector('select'),
			texts = me.documentObject.querySelector('#account-select-text').children,
			switchText = function(){
							for (var i = texts.length - 1; i >= 0; i--) {
								if (select.value == texts[i].getAttribute('data-bp-account')){
									while(texts[i].className.indexOf('hide') > -1){
										texts[i].className = texts[i].className.replace('hide', '');
									}
								} else {
									texts[i].className += ' hide';
								}
							};
						}

		switchText();

		$(select).on('change', switchText);
	}
}

RegistrationController.prototype = Object.create(AppController.prototype);
RegistrationController.prototype.constructor = RegistrationController;
