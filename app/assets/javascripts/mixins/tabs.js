var tabs = {
	manageTabs: function(){
		var me = this,
			buttons = me.documentObject.querySelectorAll('.tab-nav li'),
			tabs = me.documentObject.querySelectorAll('.tab-content'),
			numButtons = buttons.length,
			numTabs = tabs.length;

		if(numButtons == 0 && numTabs == 0){
			console.log('No tabs on this page.');
			return;
		}

		if(numButtons != numTabs){
			console.log('Error: Incorrect number of tabs (' + numTabs + ') and tab buttons (' + numButtons + ').');
		}

		for (var i = 0; i < numButtons; i++) {
			(function(){
				var thisButton = buttons[i],
					thisTab = tabs[i];
				$(thisButton).on('click', function(e){
					if(!$(this).hasClass('active')){
						deactivateTab();
						activateTab(thisButton, thisTab);
					}
					e.preventDefault();
					return false;
				});
			})()
		};

		activateTab();

		function deactivateTab(){
			me.deactivateElements.apply(me, buttons);
			me.deactivateElements.apply(me, tabs);
		}

		function activateTab(button, tab){
			if(!button || !tab){
				var tabObject = me.getActiveTab(buttons, tabs),
					button = tabObject.button,
					tab = tabObject.tab;
			}

			var getPath = tab.getAttribute('data-bp-get');
			if(getPath){
				$.get(getPath);
			}

			me.activateElements(button, tab);
			me.setActiveTab(tabs, tab);
		}
	},

	setActiveTab: function(tabs, tab){
		var tabIndex = Array.prototype.indexOf.call(tabs, tab);
		try{
			sessionStorage.setItem('tabIndex' + window.location.pathname, tabIndex);
		} catch(err){
			console.log('Tab-saving will not work. Try turning off private mode');
			console.log(err);
		}
	},

	getActiveTab: function(buttons, tabs){
		try{
			var tabIndex = Number(sessionStorage.getItem('tabIndex'
									+ window.location.pathname));
			if(tabIndex != NaN){
				var tabObject = {};
				tabObject.button = buttons[tabIndex];
				tabObject.tab = tabs[tabIndex];
				return tabObject;
			} else {
				return false;
			}
		} catch(err) {
			console.log('Try turning off private mode');
			console.log(err);
			return false;
		}
	}
}