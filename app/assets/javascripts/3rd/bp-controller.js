var appController = function(namespace){
	var me = this;
	me.namespace = namepace;
	me.activeControllers[];

	me.init = function(){
		me.findController();
		if(me.controllerNamespaces){
			me.activateControllers();
		}
	}

	me.findController = function(){
		me.controllerNamespaces = me.namespace.querySelectorAll('[data-bp-controller]');
	}

	me.activateControllers = function(){
		for (namespace in me.controllerNamespaces){
			var controller = controller.getAttribute('data-bp-controller');
			if(typeof(controller) == 'string'{
				try{
					newController = new window[controller](namespace);
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
}