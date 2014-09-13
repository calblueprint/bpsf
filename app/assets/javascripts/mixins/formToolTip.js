var formToolTip = {
	initFormToolTip: function() {
		var me = this,
			formEls = me.documentObject.querySelectorAll('[data-bp-tooltip]');

		for (var i = formEls.length - 1; i >= 0; i--) {
			me.applyToolTip(formEls[i]);
		};
	},
	applyToolTip: function(el) {
		var me = this,
			toolTipInfo = el.getAttribute('data-bp-tooltip'),
			charLimit = Number(el.getAttribute('data-bp-charlimit')),
			newToolTip = me.createToolTip(toolTipInfo, charLimit);

			me.placeToolTip(el, newToolTip);
			if (charLimit) {
				me.limitChars(el, newToolTip, charLimit);
			};

			$(el).on('focusin', function(){
				me.activateElements(newToolTip);
			});

			$(el).on('focusout', function(){
				me.deactivateElements(newToolTip);
			});
	},
	createToolTip: function(toolTipInfo, charLimit) {
		var newToolTip = '<div class="tooltip">' + toolTipInfo;

		if (charLimit) {
			newToolTip += '&nbsp;<span class="char-limit">('
							+ charLimit
							+ ' characters left)</span>';
		}

		newToolTip += '<div>';

		var tempDiv = document.createElement('div');
			tempDiv.innerHTML = newToolTip;

		return tempDiv.firstChild;
	},
	limitChars: function(el, newToolTip, charLimit) {
		return;
		$(el).on('keyup', function() {
			//'count chars';
		})
	},
	placeToolTip: function(el, newToolTip){
		//var me = this,
		//	elPosition = me.getPosition(el);
		//	console.log(elPosition);

		//newToolTip.style.top = elPosition.y + el.scrollHeight + 5 + 'px';
		//newToolTip.style.left = elPosition.x + 'px';
		el.parentNode.appendChild(newToolTip);
	},
	getPosition: function(el){
		var xPosition = 0;
	    var yPosition = 0;
	    console.log(el);

	    while(el) {
	        xPosition += (el.offsetLeft - el.scrollLeft + el.clientLeft);
	        yPosition += (el.offsetTop - el.scrollTop + el.clientTop);
	        el = el.offsetParent;
	    }

	    return { x: xPosition, y: yPosition };
	}
}