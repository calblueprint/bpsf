$(window).load(function(){
	var numwrappers = $('.wrapper').length;
	if (numwrappers > 1){
		return;
	} else {
		var winheight = $( window ).height();
		var elemheight = $('.wrapper').height();
		var footoffset = $('.footwrapper').offset().top;
		var botoomoffset = winheight - footoffset;
		var newelemheight = elemheight + botoomoffset - 217;
		if (newelemheight > elemheight){
			$('.wrapper').css("height", newelemheight );
		}
	}
});