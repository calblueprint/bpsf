var social = {
	bindSocial: function(){
		var me = this,
			socialButtons = me.documentObject.querySelectorAll('[data-bp-social]');

		for (var i = socialButtons.length - 1; i >= 0; i--) {
			(function(){
				var buttonType = socialButtons[i].getAttribute('data-bp-social');
				switch(buttonType){
					case 'facebook':
						$(socialButtons[i]).on('click', function(e){
							window.open('http://www.facebook.com/sharer.php?u=' + encodeURIComponent(window.location.href), '_blank');
							e.preventDefault();
							return false;
						});
						break;
					case 'twitter':
						$(socialButtons[i]).on('click', function(e){
							window.open('https://twitter.com/share?url=' + encodeURIComponent(window.location.href), '_blank');
							e.preventDefault();
							return false;
						});
						break;
					case 'mail':
						$(socialButtons[i]).on('click', function(e){
							window.location.href = 'mailto:?subject=' + document.title + '&body=' + encodeURIComponent(window.location.href);
							e.preventDefault();
							return false;
						})
						break;
				}
			})();
		};
	}
}