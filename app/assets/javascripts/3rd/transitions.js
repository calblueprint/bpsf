$(function() {


	var screens = $('.screen, .modalscreen'),
		isOpened = [];

	var tabGetter = function(e, tabs, type){
		var target = $(window.location.hash.replace('tab-',''));
		$(tabs).trigger('gumby.set', target.index());
	};

	var tabSetter = function(e, target, type){
		window.location.hash = 'tab-' + target.id.replace('#','');
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
		e.preventDefault();
		return false
	};

	//Add any modals you want to this list.
	//[Trigger, Target, Function, Target-type, Event]
	var bindList = [
			[document, isOpened, transitionFunction, 'modal', 'keyup'],
			[document, '.pace', transitionFunction, 'loader change', 'page:change'],
			[document, '.pace', transitionFunction, 'loader fetch', 'page:fetch'],
			['#loggedinmenu', '.userdropdown', transitionFunction, 'menu', 'click'],
			['.xbox, .screen, .modalscreen', isOpened, transitionFunction, 'modal', 'click'],
			['.toggle_crowdfund', '#crowdfund-form', transitionFunction, 'modal', 'click'],
			['#terms_conditions', '#terms', transitionFunction, 'modal', 'click'],
			['.helppanelbutton', '.helppanel', transitionFunction, 'modal', 'click'],
			['#teacherbutton', '#teacher-about', transitionFunction, 'modal', 'click'],
			['#aboutbutton', '#about-about', transitionFunction, 'modal', 'click'],
			['#donorbutton', '#donor-about', transitionFunction, 'modal', 'click'],
			['#paymentbutton1, #paymentbutton2', '#payment-form', transitionFunction, 'modal', 'click'],
			['.donate', '#payment-modal', transitionFunction, 'modal', 'click']
		];

	//Bind tab change events if tabs exist on page
	var tabs = $('.tab-nav');
	if(tabs.length > 0){
		console.log('adding to bindlist');
		bindList.push(
			[document, tabs, tabGetter, 'tab', 'page:change'],
			[document, tabs, tabGetter, 'tab', 'ready']	
			);
		var tabChildren = tabs.children();
	    for(var i = tabChildren.length - 1; i >= 0; i--){
	    	bindList.push([tabChildren[i], [tabChildren[i]], tabSetter, 'tab', 'click'])
	    };
	};

	var bindFunction = function(trigger, target, func, type, eventType){
		var triggerObject = findObject(trigger);
		if(triggerObject !== null){
			triggerObject.on(eventType, function(e){
				if(typeof target == 'string'){
					func(e, target, type);
				} else if(e.keyCode == 27 || e.keyCode == undefined && target == isOpened) {
					for (var i = target.length - 1; i >= 0; i--) {
						func(e, target[i], type);
						target.pop();
					};
				} else if(target.length == 1){
					func(e, target[0], type);
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

/*

  $(".donate").click ->
    $("#payment-modal").toggleClass "active"

  $(".close-payment-form").click ->
    $("#payment-modal").removeClass "active"

  $(".crowdfund").click ->
    $("#crowdfund-form").addClass "active"

  $(".close-crowdfund-modal").click ->
    $("#crowdfund-form").removeClass "active"

  $(".close-confirmation-modal").click ->
    $("#confirmation-form").removeClass "active"
    $("#payment-form").removeClass "active"

  $(document).keyup (e) ->
    if e.keyCode is 27
      $("#crowdfund-form").removeClass "active"  if $("#crowdfund-form").hasClass("active")
      $("#payment-modal").removeClass "active"  if $("#payment-modal").hasClass("active")
      $("#confirmation-modal").removeClass "active"  if $("#confirmation-modal").hasClass("active")
*/