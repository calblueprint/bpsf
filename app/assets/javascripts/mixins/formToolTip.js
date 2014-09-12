var formToolTip = {
	init: function(){
		var me = this,
			formEls = me.documentObject.querySelectorAll('[data-bp-tooltip]');

		for (var i = formEls.length - 1; i >= 0; i--) {
			me.applyToolTip(formEls[i]);
		};
	},
	applyToolTip: function(el){
		var me = this,
			toolTipInfo = el.getAttribute('data-bp-tooltip'),
			charLimit = el.getAttribute('data-bp-charlimit'),
			newToolTip = me.createToolTip(el, toolTipInfo);

	},
	createToolTip: function(){

	},
	limitChars: function(){

	}
}