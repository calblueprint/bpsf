(function($){

	function ifOldieAlert(){
		console.log('Checking if oldie browser...')
		if(!('querySelector' in document &&
			'localStorage' in window &&
			'addEventListener' in window &&
			'create' in Object))
		{
			var response = confirm('This site is designed for modern web browsers \
									and may offer a subpar experience in older \
									versions. We kindly suggest you update your web browser \
									to a newer version. Click "Ok" to be redirected to a safe \
									place to update your browser. Otherwise click "Cancel" ');
			if (response){
				window.location.href = 'http://whatbrowser.org/';
			} else {
				objectCreatePolyfill();
			}
		}
	}

	function objectCreatePolyfill(){
		if (typeof Object.create != 'function') {
		    (function () {
		        var F = function () {};
		        Object.create = function (o) {
		            if (arguments.length > 1) { 
		              throw Error('Second argument not supported');
		            }
		            if (o === null) { 
		              throw Error('Cannot set a null [[Prototype]]');
		            }
		            if (typeof o != 'object') { 
		              throw TypeError('Argument must be an object');
		            }
		            F.prototype = o;
		            return new F();
		        };
		    })();
		}
	}

	ifOldieAlert();

	window['AppController'] = function(documentObject){
		var me = this;
		me.documentObject = documentObject || document;
		me.activeControllers = [];
		window['activeElements'] = [];

		me.init = function(){
			console.log('Initializing AppController...');

			me.findControllers();
			if(me.controllerdocumentObjects){
				me.activateControllers();
			}

			$(document).on('keyup', function(e){
				if(e.keyCode == 27){
					me.clearActiveElements();
				}
			});
		}

		me.findControllers = function(){
			me.controllerdocumentObjects = me.documentObject.querySelectorAll('[data-bp-controller]');
		}

		me.activateControllers = function(){
			for (var i = me.controllerdocumentObjects.length - 1; i >= 0; i--) {
				var documentObject = me.controllerdocumentObjects[i],
					controller = documentObject.getAttribute('data-bp-controller');
				if(typeof(controller) == 'string'){
					try{
						controllerConstructor = window[controller];
						newController = new controllerConstructor(documentObject);
						me.setActiveController(newController);
						newController.init();
						console.log(controller + ' initialized');
					} catch(err){
						console.log('Error: Improper controller initialization. ' + controller + ' cannot initialize.');
						console.log(err);
					}
				} else {
					console.log('Error: Improper controller declaration.' + controller + ' is not a string.')
				}
			}
		}

		me.setActiveController = function(controller){
			me.activeControllers.push(controller);
		}

		me.getActiveControllers = function(){
			return me.activeControllers;
		}

		me.deactivateControllers = function(){
			var activeControllers = me.getActiveControllers();
			for (var i = activeControllers.length - 1; i >= 0; i--) {
				activeControllers[i].removeEvents();
				activeControllers[i].clearData();
				delete activeControllers[i];
			};
		}
	}


	AppController.prototype.activateElements = function(){
		var me = this;
		for (var i = arguments.length - 1; i >= 0; i--) {
			try{
				if(me.isJQuery(arguments[i])){
					arguments[i].addClass('active');
					//
					arguments[i].addClass('open');
					//
				} else {
					arguments[i].className += arguments[i].className ? ' active' : 'active';
					//
					arguments[i].className += ' open';
					//
				}

				me.setActiveElement(arguments[i]);
			} catch(err){
				console.log(arguments[i] + ' is not a document element');
				console.log(err);
			}
		};
	}

	AppController.prototype.clearActiveElements = function(){
		var me = this;
		me.deactivateElements.apply(me, activeElements);
	}

	AppController.prototype.deactivateElements = function(){
		var me = this;
		for (var i = arguments.length - 1; i >= 0; i--) {
			try{
				if(me.isJQuery(arguments[i])){
					arguments[i].removeClass('active');
					//
					arguments[i].removeClass('open');
					//
				} else {
					arguments[i].className = arguments[i].className.replace('active', '');
					//
					arguments[i].className = arguments[i].className.replace('open', '');
					//
				}

				me.removeActiveElement(arguments[i]);
			} catch(err){
				console.log(arguments[i], ' is not a document element');
				console.log(err);
			}
		};
	}

	AppController.prototype.flipElementStates = function(){
		var me = this;
		for (var i = arguments.length - 1; i >= 0; i--) {
			if(arguments[i].className.indexOf('active') > -1){
				me.deactivateElements(arguments[i]);
			} else{
				me.activateElements(arguments[i]);
			}
		};
	}

	AppController.prototype.isJQuery = function(obj){
		return obj instanceof $;
	}

	AppController.prototype.modalBind = function(){
		var me = this,
			modalButtons = me.documentObject.querySelectorAll('[data-bp-modal]');
		for (var i = modalButtons.length - 1; i >= 0; i--) {
			(function(){
				try{
					var targetModal = document.querySelector(modalButtons[i].getAttribute('data-bp-modal')),
						triggerButton = modalButtons[i],
						closeButton = targetModal.querySelector('.xbox'),
						modalScreen = targetModal.querySelector('.modalscreen');
					
					if(targetModal == []){
						return console.log('Improper modal declaration at ' + modalButtons[i]);
					}

					$(triggerButton).on('click', function(e){
						me.activateElements(targetModal);
						e.preventDefault();
						return false;
					});

					$(closeButton).on('click', function(e){
						me.clearActiveElements();
						e.preventDefault();
						return false;
					});

					$(modalScreen).on('click', function(e){
						me.clearActiveElements();
						e.preventDefault();
						return false;
					});

				} catch(err){
					console.log('Error: Improper modal declaration at ', modalButtons[i]);
					console.log(err);
				}

			})();
		};
	}

	AppController.prototype.removeActiveElement = function(el){
		var index = activeElements.indexOf(el);
		if(index > -1){
			activeElements.splice(index, 1);
		}
	}

	AppController.prototype.setActiveElement = function(el){
		activeElements.push(el);
	}

	AppController.prototype.turbolinkBind = function(){
		var me = this,
			links = me.documentObject.querySelectorAll('[data-bp-turbo]');
		for (var i = links.length - 1; i >= 0; i--) {
			(function(){
				var path = links[i].getAttribute('data-bp-turbo');
				$(links[i]).on('click', function(e){
					me.turbolinkHook(path);
					e.preventDefault();
					return false;
				});
			})();
		}
	}

	AppController.prototype.turbolinkHook = function(path){
		Turbolinks.visit(path)
	}

	AppController.prototype.initDataStore = function(){}

	AppController.prototype.setDataStore = function(){}

	AppController.prototype.getDataStore = function(){}

	AppController.prototype.manageTabs = function(){
		var this = me,
			tabButtons = me.documentObject.querySelectorAll('.tab-nav li'),
			tabs = me.documentObject.querySelectorAll('.tab-content'),
			numButtons = tabButtons.length,
			numTabs = tabs.length;

		if(numButtons != numTabs){
			console.log('Error: Incorrect number of tabs (' + numTabs + ') and tab buttons (' + numButtons + ').');
		}

		for (var i = 0; i < numButtons; i++) {
			(function(){
				$(tabButtons[i]).on('click', function(){
					me.deactivateTab();
					me.activateTab(tabButtons[i], tabs[i]);
				});
			})()
		};

		function deactivateTab(){
			var activeTab = me.getActiveTab();

		}

		function activateTab(button, tab){
			if(!button || !tab){
				var tabObject = getActiveTab();
				button = tabObject.button;
				tab = tabObject.tab;
			}

			me.activateElements(button, tab);

			var getPath = tab.getAttribute('data-bp-get');
			if(getPath){
				$.get(getPath);
			}
		}
	}

	AppController.prototype.setActiveTab = function(){}

	AppController.prototype.getActiveTab = function(){}

})(jQuery);