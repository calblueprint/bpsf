$(function() {

	var items = $('.helppanel, .helppanelbutton, .xbox');
	var hp = $('.helppanelbutton');
	var xbox = $('.xbox')

	var open = function() {
							$(items).removeClass('close').addClass('open');
						}
	var close = function() { 
							$(items).removeClass('open').addClass('close');
						}

	hp.click(function(){
		if (hp.hasClass('open')) {$(close)}
		else {$(open)}
	});
	xbox.click(function(){
		if (hp.hasClass('open')) {$(close)};
	});

});