var NavigationController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.modalBind();
		me.dropdownBind();
	}
	
}

NavigationController.prototype = Object.create(AppController.prototype);
NavigationController.prototype.constructor = NavigationController;


NavigationController.prototype.dropDownBind = function(){
		var me = this,
			dropDownButtons = me.documentObject.querySelectorAll('[data-bp-dropdown]');
		for (var i = dropDownButtons.length - 1; i >= 0; i--) {
			(function(){
				var targetDropDown = $(dropDownButtons[i].getAttribute('data-bp-dropdown')),
					isPreserve = dropDownButtons[i].getAttribute('data-bp-preserve'),
					triggerButton = $(dropDownButtons[i]);
				
				if(targetDropDown == []){
					return console.log('Improper dropdown declaration at ' + dropDownButtons[i]);
				}

				$(triggerButton).on('click', function(e){
					if(targetDropDown.hasClass('active')){
						targetDropDown.addClass('active');
						triggerButton.addClass('active');
					} else {
						targetDropDown.removeClass('active');
						triggerButton.removeClass('active');
					}
					e.preventDefault();
					return false;
				});
				
				if(!isPreserve){
					me.setTempEvent(triggerButton, closeButton, dropDownScreen);
				} else {
					me.setPreservedEvent(triggerButton, closeButton, dropDownscreen);
				}

			})();
		};
	}