var HomeController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.superSlider();
		me.infiniteScroll(function(){
			me.fundingProgress();
			me.turbolinkBind();
		});
		me.fundingProgress();
		me.turbolinkBind();
		me.modalBind();
	}

	me.truncateText = function(){} 

	me.superSlider = function(){
	    $('.home-slider').superslides({
			play: 0,//8000,
			pagination: false,
			hashchange: false,
			inherit_width_from: '.home-slider-container',
			inherit_height_from: '.home-slider-container'
	    });

		var nextArrow = me.documentObject.getElementsByClassName('arrow-box-right'),
			prevArrow = me.documentObject.getElementsByClassName('arrow-box-left');
		
		$(nextArrow).on('click', function(){
			$('.home-slider').superslides('animate','next');
		});
		
		$(prevArrow).on('click', function(){
			$('.home-slider').superslides('animate','prev');
		});
	}
}

HomeController.prototype = Object.create(AppController.prototype);
HomeController.prototype.constructor = HomeController;

HomeController.prototype.infiniteScroll = function(callback){
	var me = this;
	$(window).scroll(function(){
	    var url = $('.pagination .next_page').attr('href');
	    if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 150) {
	        $('.pagination').text('Fetching more grants...')
	        if(callback){
		        $.getScript(url, function(){
		        	callback.call(me);
		        });
		    }
	    }
	});
}

HomeController.prototype.fundingProgress = function(){
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