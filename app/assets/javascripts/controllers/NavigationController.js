var NavigationController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.modalBind();
		me.dropDownBind();
		me.mobileNavBind();
	}
	
}

NavigationController.prototype = Object.create(AppController.prototype);
NavigationController.prototype.constructor = NavigationController;


NavigationController.prototype.dropDownBind = function(){
	var me = this,
		dropDownButtons = me.documentObject.querySelectorAll('[data-bp-dropdown]');
	for (var i = dropDownButtons.length - 1; i >= 0; i--) {
		(function(){
			var targetDropDown = me.documentObject.querySelector(dropDownButtons[i].getAttribute('data-bp-dropdown')),
				backButton = targetDropDown.querySelector('.go-back'),
				triggerButton = dropDownButtons[i];
			
			if(targetDropDown == []){
				return console.log('Improper dropdown declaration at ' + dropDownButtons[i]);
			}

			$(triggerButton).on('click', function(e){
				me.flipElementStates(targetDropDown, triggerButton);
				e.preventDefault();
				return false;
			});

			$(backButton).on('click', function(e){
				me.deactivateElements(targetDropDown, triggerButton);
				e.preventDefault();
				return false;
			});
			
		})();
	};
}

NavigationController.prototype.mobileNavBind = function(){
	var me = this,
		mobileNavButtons = me.documentObject.querySelectorAll('[data-bp-mobilenav]');
	for (var i = mobileNavButtons.length - 1; i >= 0; i--) {
		(function(){
			var targetNavigation = me.documentObject.querySelector(mobileNavButtons[i].getAttribute('data-bp-mobilenav')),
				modalScreen = targetNavigation.querySelector('.modalscreen'),
				triggerButton = mobileNavButtons[i];
			
			if(targetNavigation == []){
				return console.log('Improper mobilenav declaration at ' + mobileNavButtons[i]);
			}

			$(triggerButton).on('click', function(e){
				me.activateElements(targetNavigation, modalScreen);
				e.preventDefault();
				return false;
			});

			$(modalScreen).on('click', function(e){
				me.clearActiveElements();
				e.preventDefault();
				return false;
			});

		})();
	};
}