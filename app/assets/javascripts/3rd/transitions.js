$(function() {

	var items = $('.helppanel, .helppanelbutton'),
		helpitems = $('.helppanel, .helppanelbutton, .xbox'),
		helpPanelButton = $('.helppanelbutton'),
		xbox = $('.xbox'),
		screens = $('.screen, .modalscreen'),
		userdropdown = $('.userdropdown');

//Modal Variables
	var termsmodal = $('#terms')
	var teachermodal = $('#teacher-about')
	var donormodal = $('#donor-about')
	var aboutmodal = $('#about-about')
	var paymentmodal = $('#payment-form')
	var crowdfundmodal = $('#crowdfund-form')
	var confirmationmodal = $('#confirmation-modal')
	var modals = $('#teacher-about, #about-about, #donor-about')

	var everything = $('.helppanel, .helppanelbutton, .xbox, .screen, #teacher-about, #about-about, #donor-about, #terms, #payment-form, #crowdfund-form, #confirmation-modal')

	var open = function(items, add, remove) {
							$(items).removeClass(remove).addClass(add);
							return false;
						}
	var close = function(items, remove, add) {
							$(items).removeClass(remove).addClass(add);
							return false;
						}


	var transitionObject = function(objects, addClasses, removeClasses){
		for (var i = objects.length - 1; i >= 0; i--) {
			objects[i].addClass(addClasses).removeClass(removeClasses);
		};
	};

	var findObject = function(name){
		var object = $(name);
		if(object !== null || object !== undefined){
			return object
		} else{
			return null
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
		};
		if(e.keyCode == 27){
			transitionObject(object, closeClasses, openClasses);
		} else if (object[0].hasClass(closeClasses)) {
			transitionObject(object, openClasses, closeClasses);
		} else {
			transitionObject(object, closeClasses, openClasses);
		};
	};

	var bindList = [
			['#terms_conditions', '#terms', transitionFunction, 'modal', 'click keyup']
		];

	/*Takes a list of triggers, targets, functions, target types and events 
	and binds the function to the target on that event*/
	var bindAll = function(bindList){
		for (var i = bindList.length - 1; i >= 0; i--) {
			var trigger = bindList[i][0],
				target  = bindList[i][1],
				func = bindList[i][2],
				type = bindList[i][3],
				eventType = bindList[i][4];
			var trigger = findObject(trigger);
			if(trigger !== null){
				trigger.bind(eventType, function(e){
					func(e, target, type);
				});
			};
		};
	};

	bindAll(bindList);
//General
	xbox.click(function(){
		$(close(everything,'open','close'));
		$(close(everything, 'active', 'close'));
	});
	screens.click(function(){
		$(close(everything,'open','close'));
	    $(close(everything, 'active', 'close'));
	});

//Help Panel
	helpPanelButton.bind('click',function(){
		if (helpPanelButton.hasClass('active open')) {$(close(items,'active','close'))}
		else {
			$(open(items, 'active open', 'close'));
			$(open(xbox, 'close', 'open'));
		}
		return false;
	});
	$('.closeclick').bind('click',function(){
		if (helpPanelButton.hasClass('open')) {$(close(helpitems,'open','close'))};
		return false;
	});

//Login Menu
	$('#loggedinmenu').bind('click',function(){
		if (userdropdown.hasClass('dropper')){
			$(close(userdropdown,'dropper','close'))
			$(close('#loggedinmenu', 'primary-color', 'close'))
		}
		else {
			$(open(userdropdown,'dropper','close'))
			$(open('#loggedinmenu', 'primary-color', 'close'))
		}
		return false
	});

//Modal Boxes
	$('#teacherbutton').bind('click',function(){$(open(teachermodal,'active','close'))});
	$('#aboutbutton').bind('click',function(){$(open(aboutmodal,'active','close'))});
	$('#donorbutton').bind('click',function(){$(open(donormodal,'active','close'))});
	$('#paymentbutton1').bind('click',function(){
		$(open(paymentmodal, 'active', 'close'));
		$(open(screens, 'open', 'close'));
		return false;
	});
	$('#paymentbutton2').bind('click',function(){
		$(open(paymentmodal, 'active', 'close'));
		$(open(screens, 'open', 'close'));
		return false;
	});
/*
	$('#terms_conditions').click(function(){
		$(open(termsmodal, 'active','close'));
		$(open(screens, 'open', 'close'));
		return false;
	});
*/
	$('.toggle_crowdfund').click(function(){
		$(open(crowdfundmodal, 'active', 'close'));
		$(open(screens, 'open', 'close'));
		return false;
	})

//Press Esc to Exit
	$(document).keyup(function(e) {
	    if (e.keyCode == 27) { // Esc
	        $(close(everything, 'open', 'close'));
	        $(close(everything, 'active', 'close'));
	    }
		return false;
	});


//Loading Wheel
	$(document).on('page:fetch', function() {
		$(open('.pace', 'pace-active', 'close'));
	});
	$(document).on('page:change', function() {
		$(close('.pace', 'pace-active', 'close'));
	});

});