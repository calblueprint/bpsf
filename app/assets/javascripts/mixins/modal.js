var modal = {
	modalBind: function(){
		var me = this,
			modalButtons = me.documentObject.querySelectorAll('[data-bp-modal]');
		for (var i = modalButtons.length - 1; i >= 0; i--) {
			(function(){
				try{
					var targetModal = document.querySelector(modalButtons[i].getAttribute('data-bp-modal')),
						triggerButton = modalButtons[i],
						closeButton = targetModal.querySelector('.xbox'),
						modalScreen = targetModal.querySelector('.modalscreen');
					
					if(targetModal == []){
						return console.log('Improper modal declaration at ' + modalButtons[i]);
					}

					$(triggerButton).on('click', function(e){
						me.activateElements(targetModal);
						e.preventDefault();
						return false;
					});

					$(closeButton).on('click', function(e){
						me.clearActiveElements();
						e.preventDefault();
						return false;
					});

					$(modalScreen).on('click', function(e){
						me.clearActiveElements();
						e.preventDefault();
						return false;
					});

				} catch(err){
					console.log('Error: Improper modal declaration at ', modalButtons[i]);
					console.log(err);
				}

			})();
		};
	}
}