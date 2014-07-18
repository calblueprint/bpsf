var appController = function($){
	var me = this;

	me.init = function(){
		me.findController();
		if(me.thisController){
			me.activate(thisController);
		} else{
			console.log('No controller set. Loading default controller...');
			me.activate()
		}
	}

	me.findController = function(){
		var controllerDeclaration = $('[data-bp-controller]');
		me.thisController = controllerDeclaration.data('bp-controller');
	}

	me.activate = function(thisController){
		if(thisController != undefined){
			newController = me.controllerIndex[thisController]();
		} else {
			newController = me.controllerIndex['defaultController'];
		}
	}

	
}