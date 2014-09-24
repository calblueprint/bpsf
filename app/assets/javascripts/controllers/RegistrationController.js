var RegistrationController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.extend(checkbox);
		me.extend(modal);
		me.extend(customSelect);
		me.checkboxBind();
		me.modalBind();
		me.userSwitch();
		me.convertSelects();
	}

	me.userSwitch = function(){
		var select = me.documentObject.querySelector('#account-select').querySelector('select'),
			texts = me.documentObject.querySelector('#account-select-text').children,
			form = me.documentObject.querySelector('form'),
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
						},
			showForm = function(){
				if (select.value){
					var form = me.documentObject.querySelector('#registration-form');
					form.className = form.className.replace('hide', '');
				}
			},
			setValue = function(){
				sessionStorage.userType = select.value;
			},
			setForm = function(){
				if(sessionStorage.userType){
					select.value = sessionStorage.userType;
					$(select).trigger('change');
				}
			};

		switchText();
		setForm();

		$(select).on('change', switchText);
		$(select).on('change', showForm);

		$(form).on('submit', setValue);

		$(select).trigger('change');
	}
}

RegistrationController.prototype = Object.create(AppController.prototype);
RegistrationController.prototype.constructor = RegistrationController;
