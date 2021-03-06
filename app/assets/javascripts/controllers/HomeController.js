var HomeController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.extend(customSelect);
		me.extend(modal);
		me.extend(fundingBar);
		me.extend(truncate);

		me.superSlider();
		me.infiniteScroll(function(){
			me.fundingProgress();
			me.turbolinkBind();
			me.setupTruncate();
		});
		me.fundingProgress();
		me.turbolinkBind();
		me.modalBind();
		me.convertSelects();
		me.setupTruncate();
	}

	me.superSlider = function(){
	    $('.home-slider').superslides({
			play: 8000,
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

	me.deactivate = function(){
		$(window).off('scroll')
	}
}

HomeController.prototype = Object.create(AppController.prototype);
HomeController.prototype.constructor = HomeController;

HomeController.prototype.infiniteScroll = function(callback){
	var me = this;
	$(window).on('scroll', loadPagContent);

	function loadPagContent(){
	    if ($(window).scrollTop() > $(document).height() - $(window).height() - 150) {
	    	var pagination = me.documentObject.querySelector('.pagination .next_page'),
	    		url = pagination ? pagination.getAttribute('href') : false;
	    	if(url){
		        me.documentObject.querySelector('.pagination')
		        	.innerHTML = "<div class='loader-blob active' style='position:inherit'> \
			        				<div class='bounce-1'></div> \
									<div class='bounce-2'></div> \
									<div class='bounce-3'></div> \
								</div>";
		        if(callback){
			        $.getScript(url, function(){
			        	callback.call(me);
			        });
			    } else {
			    	$.getScript(url);
			    }
			}
	    }
	}
}