$(function() {

	var items = $('.helppanel, .helppanelbutton, .xbox, .screen');
	var hp = $('.helppanelbutton');
	var xbox = $('.xbox');
	var screen = $('.screen');
	var closeclick = $('.closeclick');

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
	screen.click(function(){
		if (hp.hasClass('open')) {$(close)};
	});
	closeclick.click(function(){
		if (hp.hasClass('open')) {$(close)};
	});

});