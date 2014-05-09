$(document).ready(function(){
	var numwrappers = $('.wrapper').length;
	if (numwrappers == 1){
		var windowHeight = $( window ).height();
		var elemHeight = $('.wrapper').height();
		var footOffset = $('.footwrapper').offset().top;
		var bottomOffset = windowHeight - footOffset;
		var newElemHeight = elemHeight + bottomOffset - $('.footwrapper').height();
		if (newElemHeight > elemHeight){
			$('.wrapper').css("minHeight", newElemHeight );
		}
	}
});