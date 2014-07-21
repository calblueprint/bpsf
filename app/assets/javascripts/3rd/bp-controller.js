var AppController = function(namespace){
	var me = this;
	me.namespace = namespace || document;
	me.activeControllers = [];

	me.init = function(){
		console.log('Initializing AppController...');
		me.objectCreatePolyfill();

		me.findController();
		if(me.controllerNamespaces){
			me.activateControllers();
		}
	}

	me.findController = function(){
		me.controllerNamespaces = me.namespace.querySelectorAll('[data-bp-controller]');
	}

	me.activateControllers = function(){
		for (var i = me.controllerNamespaces.length - 1; i >= 0; i--) {
			var namespace = me.controllerNamespaces[i],
				controller = namespace.getAttribute('data-bp-controller');
			if(typeof(controller) == 'string'){
				try{
					newController = window[controller](namespace);
					me.activateControllers.push(newController);
				} catch(err){
					console.log('Error: Improper controller name.' + controller + ' does not exist.');
					console.log(err.message);
				}
			} else {
				console.log('Error: Improper controller declaration.' + controller + ' is not a string.')
			}
		}
	}

	me.objectCreatePolyfill = function(){
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
}

var HomeController = function(namespace){
	var me = this;
	AppController.call(me, namespace);

	me.init = function(){
		console.log('Initializing HomeController');
		me.createAlert();
	}

	me.createAlert = function(){
		alert('HomeController working' + this);
	}
}

HomeController.prototype = Object.create(AppController.prototype);
HomeController.prototype.constructor = HomeController;



