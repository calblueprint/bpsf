$(function() {

	var items = $('.helppanel, .helppanelbutton, .xbox, .screen');
	var helpitems = $('.helppanel, .helppanelbutton, .xbox')
	var helpPanelButton = $('.helppanelbutton');
	var xbox = $('.xbox');
	var screen = $('.screen, .modalscreen');
	var userdropdown = $('.userdropdown')

//Modal Variables
	var teachermodal = $('#teacher-about')
	var donormodal = $('#donor-about')
	var aboutmodal = $('#about-about')
	var paymentmodal = $('#payment-form')
	var crowdfundmodal = $('#crowdfund-form')
	var confirmationmodal = $('#confirmation-modal')
	var modals = $('#teacher-about, #about-about, #donor-about')

	var everything = $('.helppanel, .helppanelbutton, .xbox, .screen, #teacher-about, #about-about, #donor-about, #payment-form, #crowdfund-form, #confirmation-modal')

	var open = function(items, open, close) {
							$(items).removeClass(close).addClass(open);
						}
	var close = function(items, open, close) {
							$(items).removeClass(open).addClass(close);
						}

//General
	xbox.click(function(){
		$(close(everything,'open','close'))
		$(close(everything, 'active', 'close'))
	});
	screen.click(function(){
		$(close(everything,'open','close'));
	    $(close(everything, 'active', 'close'))
	});

//Help Panel
	helpPanelButton.click(function(){
		if (helpPanelButton.hasClass('active open')) {$(close(items,'active open','close'))}
		else {$(open(items, 'active open', 'close'))}
	});
	$('.closeclick').click(function(){
		if (helpPanelButton.hasClass('open')) {$(close(helpitems,'open','close'))};
	});

//Login Menu
	$('.loginmenu').click(function(){
		if (userdropdown.hasClass('dropper')){
			$(close(userdropdown,'dropper','close'))
			$(close('.loginmenu', 'primary-color', 'close'))
		}
		else {
			$(open(userdropdown,'dropper','close'))
			$(open('.loginmenu', 'primary-color', 'close'))
		}
	});

//Modal Boxes
	$('#teacherbutton').click(function(){$(open(teachermodal,'active','close'))});
	$('#aboutbutton').click(function(){$(open(aboutmodal,'active','close'))});
	$('#donorbutton').click(function(){$(open(donormodal,'active','close'))});
	$('#paymentbutton').click(function(){
		$(open(paymentmodal, 'active', 'close'))
		$(open(screen, 'open', 'close'))
	});
	$('.toggle_crowdfund').click(function(){
		$(open(crowdfundmodal, 'active', 'close'))
		$(open(screen, 'open', 'close'))
	})

//Press Esc to Exit
	$(document).keyup(function(e) {
	    if (e.keyCode == 27) { // Esc
	        $(close(everything, 'open', 'close'));
	        $(close(everything, 'active', 'close'))
	    }
	});


//Loading Wheel
	$(document).on('page:fetch', function() {
		$(open('.pace', 'pace-active', 'close'))
	});
	$(document).on('page:change', function() {
		$(close('.pace', 'pace-active', 'close'))
	});

});