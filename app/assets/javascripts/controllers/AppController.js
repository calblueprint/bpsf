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
		window['bpEvents'] = [];
		window['activeElements'] = [];

		me.init = function(){
			console.log('Initializing AppController...');

			me.findControllers();
			if(me.controllerdocumentObjects){
				me.activateControllers();
			}
			me.bindLoader();
			me.bindEscElements();


			$(document).one('page:fetch',function(){
				me.deactivateControllers();
			});

		}

		me.findControllers = function(){
			me.controllerdocumentObjects = me.documentObject.querySelectorAll('[data-bp-controller]');
		}

		me.activateControllers = function(){
			var numControllers = me.controllerdocumentObjects.length
			for (var i = 0; i < numControllers; i++) {
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
				var thisController = activeControllers.pop();
				if (thisController.hasOwnProperty('deactivate')){
					thisController.deactivate();
				}

				for (var property in thisController){
					delete thisController[property];
				}
				delete thisController;
			};
		}

		me.bindLoader = function(){
			$(document).one('page:before-change', function(e){
				var loaderBg = me.documentObject.querySelector('.loader-bg'),
					loaderBlob = me.documentObject.querySelector('.loader-blob');
				me.activateElements(loaderBg, loaderBlob);
			});
		}

		me.bindEscElements = function(){
			$(document).on('keyup', function(e){
				if(e.keyCode == 27){
					me.clearActiveElements();
				}
			});
		}
	}


	AppController.prototype.activateElements = function(){
		var me = this,
			registerThis = arguments[0],
			endIndex = registerThis ? 0 : 1;
		for (var i = arguments.length - 1; i >= endIndex; i--) {
			try{
				if(me.isJQuery(arguments[i])){
					arguments[i].addClass('active');
				} else {
					arguments[i].className += arguments[i].className ? ' active' : 'active';
				}

				if(registerThis){
					me.setActiveElement(arguments[i]);
				}
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
				} else {
					while(arguments[i].className.indexOf('active') > -1){
						arguments[i].className = arguments[i].className.replace('active', '');
					}
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

	AppController.prototype.extend = function(source) {
		var me = this;
		for (var prop in source) {
			if (source.hasOwnProperty(prop)) {
				me[prop] = source[prop];
			}
		}
	}

})(jQuery);