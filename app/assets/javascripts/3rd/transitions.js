$(function() {

	var screens = $('.screen, .modalscreen'),
		isOpened = [];

	var tabGetter = function(e, tabs, type, preventDefault){
		target = $('#' + sessionStorage.getItem('tab'));
		$(tabs).trigger('gumby.set', target.index());
	};

	var tabSetter = function(e, target, type, preventDefault){
		sessionStorage.setItem('tab',target.id);
	};

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

	var transitionFunction = function(e, target, type, preventDefault){
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
			var openClasses = 'pace-active',
				closeClasses = 'close';
		};
		if(
			object[0].hasClass(openClasses) 
			|| type == 'loader change' 
			&& type !== 'loader fetch'
			) {
			editClasses(object, closeClasses, openClasses);
		} else {
			editClasses(object, openClasses, closeClasses);
			isOpened.push(object[0]);
		};
		if(preventDefault){
			e.preventDefault();
			return false;
		}
	};

	//Add any modals you want to this list.
	//[Trigger, Target, Function, Target-type, Event, PreventDefaul?]
	var bindList = [
			[document, isOpened, transitionFunction, 'modal', 'keyup', true],
			[document, '.pace', transitionFunction, 'loader change', 'page:change', true],
			[document, '.pace', transitionFunction, 'loader fetch', 'page:fetch', true],
			['#loggedinmenu', '.userdropdown', transitionFunction, 'menu', 'click', true],
			['.xbox, .screen, .modalscreen', isOpened, transitionFunction, 'modal', 'click', true],
			['.toggle_crowdfund', '#crowdfund-form', transitionFunction, 'modal', 'click', true],
			['#terms_conditions', '#terms', transitionFunction, 'modal', 'click', true],
			['.helppanelbutton', '.helppanel', transitionFunction, 'modal', 'click', true],
			['#teacherbutton', '#teacher-about', transitionFunction, 'modal', 'click', true],
			['#aboutbutton', '#about-about', transitionFunction, 'modal', 'click', true],
			['#donorbutton', '#donor-about', transitionFunction, 'modal', 'click', true],
			['#paymentbutton1, #paymentbutton2', '#payment-form', transitionFunction, 'modal', 'click', true],
		];

	//Bind tab change events if tabs exist on page
	var tabs = $('.tab-nav');
	if(tabs.length > 0){
		bindList.push(
			[document, tabs, tabGetter, 'tab', 'page:change', true],
			[document, tabs, tabGetter, 'tab', 'ready', true]	
			);
		var tabChildren = tabs.children();
	    for(var i = tabChildren.length - 1; i >= 0; i--){
	    	bindList.push([tabChildren[i], tabChildren[i], tabSetter, 'tab', 'click'])
	    };
	};

	var isSavedCard = $('.saved_card');
	if (isSavedCard.length > 0){
		bindList.push(['#new_payment', '#confirmation-modal', transitionFunction, 'modal', 'submit', false]);
	};

	var bindFunction = function(trigger, target, func, type, eventType, preventDefault){
		var triggerObject = findObject(trigger);
		if(triggerObject !== null){
			triggerObject.on(eventType, function(e){
				if(typeof target == 'string' || type == 'tab'){
					func(e, target, type, preventDefault);
				} else if(e.keyCode == 27 || e.keyCode == undefined && target == isOpened) {
					for (var i = target.length - 1; i >= 0; i--) {
						func(e, target[i], type, preventDefault);
						target.pop();
						console.log(target);
					};
				};
			});
		};
	};

	/*Takes a list of triggers, targets, functions, target types, events and
	whether to preventDefault and binds the function to the target on that event*/
	var bindAll = function(bindList){
		for (var i = bindList.length - 1; i >= 0; i--) {
			var trigger = bindList[i][0],
				target  = bindList[i][1],
				func = bindList[i][2],
				type = bindList[i][3],
				eventType = bindList[i][4],
				preventDefault = bindList[i][5];
			bindFunction(trigger, target, func, type, eventType, preventDefault);
		};
	};

	bindAll(bindList);

});