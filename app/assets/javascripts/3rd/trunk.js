$(function() {

	var items = $('.helppanel, .helppanelbutton, .xbox, .screen');
	var hp = $('.helppanelbutton');
	var xbox = $('.xbox');
	var screen = $('.screen');
	var closeclick = $('.closeclick');
	var loginmenu = $('.loginmenu')
	var userdropdown = $('.userdropdown')

	var open = function(items, open, close) {
							$(items).removeClass(close).addClass(open);
						}
	var close = function(items, open, close) {
							$(items).removeClass(open).addClass(close);
						}

	hp.click(function(){
		if (hp.hasClass('open')) {$(close(items,'open','close'))}
		else {$(open(items, 'open', 'close'))}
	});
	xbox.click(function(){
		if (hp.hasClass('open')) {$(close(items,'open','close'))};
	});
	screen.click(function(){
		if (hp.hasClass('open')) {$(close(items,'open','close'))};
	});
	closeclick.click(function(){
		if (hp.hasClass('open')) {$(close(items,'open','close'))};
	});
	loginmenu.click(function(){
		if (userdropdown.hasClass('dropper')){$(close(userdropdown,'dropper','close'))}
		else {$(open(userdropdown,'dropper','close'))}
	});

});