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
		var newToolTip = '<div class="tooltip"><div class="arrow"></div>' + toolTipInfo;

		if (charLimit) {
			newToolTip += '&nbsp;(<span class="char-limit">'
							+ charLimit
							+ '</span> characters left)';
		}

		newToolTip += '<div>';

		var tempDiv = document.createElement('div');
			tempDiv.innerHTML = newToolTip;

		return tempDiv.firstChild;
	},
	limitChars: function(el, newToolTip, charLimit) {
		$(el).on('input paste propertychange', function() {
			var charUsed = el.value.length,
				charRatio = charUsed / charLimit;

			if(charRatio < 1) {
				var bgColor = 'rgba('
							+ parseInt( Math.pow(charRatio, 3) * 239)
							+ ','
							+ parseInt( Math.pow(charRatio, 3) * 64)
							+ ','
							+ parseInt( Math.pow(charRatio, 3) * 35)
							+ ','
							+ (0.3 * (charRatio) + 0.7)
							+ ')';
			} else {
				var bgColor ='rgba(239, 54, 35, 1)';
			}

			newToolTip.querySelector('.char-limit').innerHTML = charLimit - charUsed;
			newToolTip.style.backgroundColor = bgColor;
			newToolTip.querySelector('.arrow').style.borderBottomColor = bgColor;
		});

		$(el).trigger('input');
	},
	placeToolTip: function(el, newToolTip){
		el.parentNode.appendChild(newToolTip);
	}
}