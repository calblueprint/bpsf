$(function() {


	var screens = $('.screen, .modalscreen'),
		isOpened = [];

	var editClasses = function(objects, addClasses, removeClasses){
		for (var i = objects.length - 1; i >= 0; i--) {
			objects[i].removeClass(removeClasses).addClass(addClasses);
		};
	};

	var findObject = function(name){
		var object = $(name);
		if(object[0] !== undefined){
			return object;
		} else{
			return null;
		};
	};

	var transitionFunction = function(e, target, type){
		var object = [$(target)];
		//Add object type-specific behavior here
		if(type == 'modal'){
			var openClasses = 'open active',
				closeClasses = 'close';
			object.push(screens);
		} else if(type == 'menu'){
			var openClasses = 'dropper',
				closeClasses = 'close';
		} else if(type == 'loader fetch' || type == 'loader change'){
			console.log('page fetch!')
			var openClasses = 'pace-active',
				closeClasses = 'close';
		};
		if(
			e.keyCode == 27 
			|| object[0].hasClass(openClasses) 
			|| type == 'loader change' 
			&& type !== 'loader fetch'
			) {
			editClasses(object, closeClasses, openClasses);
		} else {
			editClasses(object, openClasses, closeClasses);
			isOpened.push(object[0]);
		};
		e.preventDefault();
		return false
	};

	//Add any modals you want to this list.
	//[Trigger, Target, Function, Target-type, Event]
	var bindList = [
			[document, isOpened, transitionFunction, 'modal', 'keyup'],
			[document, '.pace', transitionFunction, 'loader change', 'page:change'],
			[document, '.pace', transitionFunction, 'loader fetch', 'page:fetch'],
			['.xbox, .screen, .modalscreen', isOpened, transitionFunction, 'modal', 'click'],
			['.toggle_crowdfund', '#crowdfund-form', transitionFunction, 'modal', 'click'],
			['#terms_conditions', '#terms', transitionFunction, 'modal', 'click'],
			['.helppanelbutton', '.helppanel', transitionFunction, 'modal', 'click'],
			['#teacherbutton', '#teacher-about', transitionFunction, 'modal', 'click'],
			['#aboutbutton', '#about-about', transitionFunction, 'modal', 'click'],
			['#donorbutton', '#donor-about', transitionFunction, 'modal', 'click'],
			['#paymentbutton1, #paymentbutton2', '#payment-form', transitionFunction, 'modal', 'click'],
			['#loggedinmenu', '.userdropdown', transitionFunction, 'menu', 'click']
		];


	var bindFunction = function(trigger, target, func, type, eventType){
		var triggerObject = findObject(trigger);
		if(triggerObject !== null){
			triggerObject.on(eventType, function(e){
				if(typeof target == 'string'){
					func(e, target, type);
				} else {
					for (var i = target.length - 1; i >= 0; i--) {
						func(e, target[i], type);
						target.pop();
					};
				};
			});
		};
	};

	/*Takes a list of triggers, targets, functions, target types and events 
	and binds the function to the target on that event*/
	var bindAll = function(bindList){
		for (var i = bindList.length - 1; i >= 0; i--) {
			var trigger = bindList[i][0],
				target  = bindList[i][1],
				func = bindList[i][2],
				type = bindList[i][3],
				eventType = bindList[i][4];
			bindFunction(trigger, target, func, type, eventType);
		};
	};

	bindAll(bindList);


});