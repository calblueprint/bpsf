$(function() {

	var items = $('.slideRight, .slideLeft');
	var dimmer = $('.dimmer');
	
	var open = function() {
							$(items).removeClass('close').addClass('open');
						}
	var close = function() { 
							$(items).removeClass('open').addClass('close');
						}

	$('#navToggle').click(function(){
		if (dimmer.hasClass('open')) {$(close)}
		else {$(open)}
	});
	dimmer.click(function(){
		if (dimmer.hasClass('open')) {$(close)};
	});

});