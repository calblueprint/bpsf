var HomeController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.fundingProgress();
	}

	//This needs to be wired to fire when more grants are loaded from scrolling
	me.fundingProgress = function(){
		var fundingBars = me.documentObject.querySelectorAll('.funding-bar');
		for (var i = fundingBars.length - 1; i >= 0; i--) {
			var currentFunding = fundingBars[i].getAttribute('data-current'),
				goalFunding = fundingBars[i].getAttribute('data-goal'),
				fundingBarWidth = currentFunding/goalFunding * 100;
			if (fundingBarWidth > 0 && fundingBarWidth < 10){
				fundingBarWidth = 10;
			} else if(fundingBarWidth > 100){
				fundingBarWidth = 100;
			}
			fundingBars[i].style.width = String(fundingBarWidth) + '%';
		};
	}

	me.truncateText = function(){}

	me.infiniteScroll = function(){}

	me.superSlider = function(){}
}

HomeController.prototype = Object.create(AppController.prototype);
HomeController.prototype.constructor = HomeController;
