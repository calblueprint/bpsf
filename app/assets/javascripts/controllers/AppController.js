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

	function AppController(documentObject){
		var me = this;
		me.documentObject = documentObject || document;
		me.activeControllers = [];

		me.init = function(){
			console.log('Initializing AppController...');

			me.findControllers();
			if(me.controllerdocumentObjects){
				me.activateControllers();
			}
		}

		me.initOnPageChange = function(){}

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
					} catch(err){
						console.log('Error: Improper controller name. ' + controller + ' does not exist.');
						console.log(err.message);
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
			return me.activateControllers;
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

	window['AppController'] = AppController;

	AppController.prototype.modalBind = function(){
		var me = this,
			modalButtons = me.documentObject.querySelectorAll('[data-bp-modal]');
		for (var i = modalButtons.length - 1; i >= 0; i--) {
			(function(){
				var targetModal = $(modalButtons[i].getAttribute('data-bp-modal')),
					isPreserve = modalButtons[i].getAttribute('data-bp-preserve'),
					triggerButton = $(modalButtons[i]),
					closeButton = targetModal.find('.xbox'),
					modalScreen = targetModal.find('.modalscreen');
				
				if(targetModal == []){
					return console.log('Improper modal declaration at ' + modalButtons[i]);
				}

				$(triggerButton).on('click', function(e){
					targetModal.addClass('active');
					e.preventDefault();
					return false;
				});

				$(closeButton).on('click', function(e){
					targetModal.removeClass('active');
					e.preventDefault();
					return false;
				});

				$(modalScreen).on('click', function(e){
					targetModal.removeClass('active');
					e.preventDefault();
					return false;
				})

				if(!isPreserve){
					me.setTempEvent(triggerButton, closeButton, modalScreen);
				} else {
					me.setPreservedEvent(triggerButton, closeButton, modalscreen);
				}

			})();
		};
	}

	AppController.prototype.removeEvents = function(){}

	AppController.prototype.clearData = function(){}

	AppController.prototype.setTempEvent = function(){}

	AppController.prototype.setPreservedEvent = function(){}

	AppController.prototype.getTempEvent = function(){}

	AppController.prototype.getPreservedEvent = function(){}

	AppController.prototype.navigationBar = function(){}

	AppController.prototype.turbolinkHook = function(){}

	AppController.prototype.extendPageLength = function(){}

	AppController.prototype.setActiveElements = function(){}

	AppController.prototype.getActiveElements = function(){}

	AppController.prototype.clearActiveElements = function(){}

	AppController.prototype.initDataStore = function(){}

	AppController.prototype.setDataStore = function(){}

	AppController.prototype.getDataStore = function(){}

	AppController.prototype.manageTabs = function(){}

	AppController.prototype.setActiveTab = function(){}

	AppController.prototype.getActiveTab = function(){}

})(jQuery);