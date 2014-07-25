var AppController = function(documentObject){
	var me = this;
	me.documentObject = documentObject || document;
	me.activeControllers = [];
	me.wind = window;

	me.init = function(){
		console.log('Initializing AppController...');
		me.objectCreatePolyfill();

		me.findController();
		if(me.controllerdocumentObjects){
			me.activateControllers();
		}
	}

	me.findController = function(){
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
					me.activeControllers.push(newController);
				} catch(err){
					console.log('Error: Improper controller name. ' + controller + ' does not exist.');
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

	me.navigationBar = function(){}

	me.turbolinkHook = function(){}

	me.extendPageLength = function(){}

	me.setActiveElements = function(){}

	me.getActiveElements = function(){}

	me.clearActiveElements = function(){}

	me.initDataStore = function(){}

	me.setDataStore = function(){}

	me.getDataStore = function(){}

	me.manageTabs = function(){}

	me.setActiveTab = function(){}

	me.getActiveTab = function(){}
}

var HomeController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.fundingProgress();
	}

	//This needs to be wired to fire when more grants are loaded from scrolling
	me.fundingProgress = function(){
		var fundingBars = me.documentObject.querySelectorAll('.funding-bar');
		for (var i = fundingBars.length - 1; i >= 0; i--) {
			var currentFunding = fundingBars[i].getAttribute('data-current'),
				goalFunding = fundingBars[i].getAttribute('data-goal'),
				fundingBarWidth = currentFunding/goalFunding * 100;
			if (fundingBarWidth > 0 && fundingBarWidth < 10){
				fundingBarWidth = 10;
			} else if(fundingBarWidth > 100){
				fundingBarWidth = 100;
			}
			fundingBars[i].style.width = String(fundingBarWidth) + '%';
		};
	}

	me.truncateText = function(){}

	me.infiniteScroll = function(){}

	me.superSlider = function(){}
}

HomeController.prototype = Object.create(AppController.prototype);
HomeController.prototype.constructor = HomeController;


var EditGrantController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){}
}

EditGrantController.prototype = Object.create(AppController.prototype);
EditGrantController.prototype.constructor = EditGrantController;


var ShowGrantController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){}
}

ShowGrantController.prototype = Object.create(AppController.prototype);
ShowGrantController.prototype.constructor = ShowGrantController;


var AdminDashboardController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){}
}

AdminDashboardController.prototype = Object.create(AppController.prototype);
AdminDashboardController.prototype.constructor = AdminDashboardController;