var fundingBar = {
	fundingProgress: function(){
		var me = this,
			fundingBars = me.documentObject.querySelectorAll('[data-bp-current]');
		for (var i = fundingBars.length - 1; i >= 0; i--) {
			var currentFunding = fundingBars[i].getAttribute('data-bp-current'),
				goalFunding = fundingBars[i].getAttribute('data-bp-goal'),
				fundingBarWidth = currentFunding/goalFunding * 100;
			if (fundingBarWidth > 0 && fundingBarWidth < 10){
				fundingBarWidth = 10;
			} else if(fundingBarWidth > 100){
				fundingBarWidth = 100;
			}
			fundingBars[i].style.width = String(fundingBarWidth) + '%';
		};
	}
}