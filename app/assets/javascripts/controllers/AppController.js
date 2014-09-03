(function($){

	function ifOldieAlert(){
		console.log('Checking if oldie browser...')
		if(!('querySelector' in document &&
			'localStorage' in window &&
			'addEventListener' in window &&
			'create' in Object))
		{
			var response = confirm('This site is designed for modern web browsers \
									and may offer a subpar experience in older \
									versions. We kindly suggest you update your web browser \
									to a newer version. Click "Ok" to be redirected to a safe \
									place to update your browser. Otherwise click "Cancel" ');
			if (response){
				window.location.href = 'http://whatbrowser.org/';
			} else {
				objectCreatePolyfill();
			}
		}
	}

	function objectCreatePolyfill(){
		if (typeof Object.create != 'function') {
		    (function () {
		        var F = function () {};
		        Object.create = function (o) {
		            if (arguments.length > 1) { 
		              throw Error('Second argument not supported');
		            }
		            if (o === null) { 
		              throw Error('Cannot set a null [[Prototype]]');
		            }
		            if (typeof o != 'object') { 
		              throw TypeError('Argument must be an object');
		            }
		            F.prototype = o;
		            return new F();
		        };
		    })();
		}
	}

	ifOldieAlert();

	window['AppController'] = function(documentObject){
		var me = this;
		me.documentObject = documentObject || document;
		me.activeControllers = [];
		window['bpEvents'] = [];
		window['activeElements'] = [];

		me.init = function(){
			console.log('Initializing AppController...');

			me.findControllers();
			if(me.controllerdocumentObjects){
				me.activateControllers();
			}
			me.bindLoader();
			me.bindEscElements();


			$(document).one('page:fetch',function(){
				me.deactivateControllers();
			});

		}

		me.findControllers = function(){
			me.controllerdocumentObjects = me.documentObject.querySelectorAll('[data-bp-controller]');
		}

		me.activateControllers = function(){
			var numControllers = me.controllerdocumentObjects.length
			for (var i = 0; i < numControllers; i++) {
				var documentObject = me.controllerdocumentObjects[i],
					controller = documentObject.getAttribute('data-bp-controller');
				if(typeof(controller) == 'string'){
					try{
						controllerConstructor = window[controller];
						newController = new controllerConstructor(documentObject);
						me.setActiveController(newController);
						newController.init();
						console.log(controller + ' initialized');
					} catch(err){
						console.log('Error: Improper controller initialization. ' + controller + ' cannot initialize.');
						console.log(err);
					}
				} else {
					console.log('Error: Improper controller declaration.' + controller + ' is not a string.')
				}
			}
		}

		me.setActiveController = function(controller){
			me.activeControllers.push(controller);
		}

		me.getActiveControllers = function(){
			return me.activeControllers;
		}

		me.deactivateControllers = function(){
			var activeControllers = me.getActiveControllers();
			for (var i = activeControllers.length - 1; i >= 0; i--) {
				var thisController = activeControllers.pop();
				if (thisController.hasOwnProperty('deactivate')){
					thisController.deactivate();
				}

				for (var property in thisController){
					delete thisController[property];
				}
				delete thisController;
			};
		}

		me.bindLoader = function(){
			$(document).one('page:fetch', function(e){
				var loaderBg = me.documentObject.querySelector('.loader-bg'),
					loaderBlob = me.documentObject.querySelector('.loader-blob');
				me.activateElements(loaderBg, loaderBlob);
			});
		}

		me.bindEscElements = function(){
			$(document).on('keyup', function(e){
				if(e.keyCode == 27){
					me.clearActiveElements();
				}
			});
		}
	}


	AppController.prototype.activateElements = function(){
		var me = this,
			registerThis = arguments[0],
			endIndex = registerThis ? 0 : 1;
		for (var i = arguments.length - 1; i >= endIndex; i--) {
			try{
				if(me.isJQuery(arguments[i])){
					arguments[i].addClass('active');
				} else {
					arguments[i].className += arguments[i].className ? ' active' : 'active';
				}

				if(registerThis){
					me.setActiveElement(arguments[i]);
				}
			} catch(err){
				console.log(arguments[i] + ' is not a document element');
				console.log(err);
			}
		};
	}

	AppController.prototype.clearActiveElements = function(){
		var me = this;
		me.deactivateElements.apply(me, activeElements);
	}

	AppController.prototype.deactivateElements = function(){
		var me = this;
		for (var i = arguments.length - 1; i >= 0; i--) {
			try{
				if(me.isJQuery(arguments[i])){
					arguments[i].removeClass('active');
				} else {
					while(arguments[i].className.indexOf('active') > -1){
						arguments[i].className = arguments[i].className.replace('active', '');
					}
				}

				me.removeActiveElement(arguments[i]);
			} catch(err){
				console.log(arguments[i], ' is not a document element');
				console.log(err);
			}
		};
	}

	AppController.prototype.flipElementStates = function(){
		var me = this;
		for (var i = arguments.length - 1; i >= 0; i--) {
			if(arguments[i].className.indexOf('active') > -1){
				me.deactivateElements(arguments[i]);
			} else{
				me.activateElements(arguments[i]);
			}
		};
	}

	AppController.prototype.isJQuery = function(obj){
		return obj instanceof $;
	}

	AppController.prototype.modalBind = function(){
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

	AppController.prototype.removeActiveElement = function(el){
		var index = activeElements.indexOf(el);
		if(index > -1){
			activeElements.splice(index, 1);
		}
	}

	AppController.prototype.setActiveElement = function(el){
		activeElements.push(el);
	}

	AppController.prototype.turbolinkBind = function(){
		var me = this,
			links = me.documentObject.querySelectorAll('[data-bp-turbo]');
		for (var i = links.length - 1; i >= 0; i--) {
			(function(){
				var path = links[i].getAttribute('data-bp-turbo');
				$(links[i]).on('click', function(e){
					me.turbolinkHook(path);
					e.preventDefault();
					return false;
				});
			})();
		}
	}

	AppController.prototype.turbolinkHook = function(path){
		Turbolinks.visit(path)
	}

	AppController.prototype.manageTabs = function(){
		var me = this,
			buttons = me.documentObject.querySelectorAll('.tab-nav li'),
			tabs = me.documentObject.querySelectorAll('.tab-content'),
			numButtons = buttons.length,
			numTabs = tabs.length;


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
	}

	AppController.prototype.setActiveTab = function(tabs, tab){
		var tabIndex = Array.prototype.indexOf.call(tabs, tab);
		try{
			sessionStorage.setItem('tabIndex', tabIndex);
		} catch(err){
			console.log('Tab-saving will not work. Try turning off private mode');
			console.log(err);
		}
	}

	AppController.prototype.getActiveTab = function(buttons, tabs){
		try{
			var tabIndex = Number(sessionStorage.getItem('tabIndex'));
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

	AppController.prototype.checkboxBind = function(){
		var me = this,
			checkboxes = me.documentObject.querySelectorAll('.checkbox');

		for (var i = checkboxes.length - 1; i >= 0; i--) {
			(function(){
				var checkbox = checkboxes[i];
				$(checkbox).on('click', function(e){
					var inputEl = checkbox.querySelector('input[type="checkbox"]');
					if(inputEl.checked){
						me.deactivateElements(checkbox);
					} else {
						me.activateElements(checkbox);
					}
					inputEl.checked = !inputEl.checked;
					e.preventDefault();
					return false;
				});
			})();
		};
	}


	AppController.prototype.convertSelects = function(){
		if(document.width < 1040){
			return;
		}


		var me = this,
			selects = me.documentObject.querySelectorAll('select');

		for (var i = selects.length - 1; i >= 0; i--) {
			(function(){
				var oldSelect = selects[i],
					scope = oldSelect.parentNode,
					newSelect = createSelect(oldSelect);

				oldSelect.className = 'hide';
				scope.appendChild(newSelect);
				manageSelect(newSelect, oldSelect);

			})();
		};

		function createSelect(oldSelect){
			var newSelectHTML = '<div class="select-wrapper"><span>';
				newSelectHTML += oldSelect.value;
				newSelectHTML += '</span><ul class="select">';

			for (var i = 0; i < oldSelect.options.length; i++) {
				newSelectHTML += '<li data-bp-value="' + oldSelect.options[i].value + '"><a>' + oldSelect.options[i].value + '</a></li>';
			};

			newSelectHTML += '</ul></div>';

			var tempDiv = document.createElement('div');
				tempDiv.innerHTML = newSelectHTML;
			
			return tempDiv.firstChild
		}

		function manageSelect(newSelect, oldSelect){
			$(newSelect).on('click', function(e){
				me.flipElementStates(newSelect);
				e.preventDefault();
				return false;
			})

			var options = newSelect.querySelectorAll('li');

			for (var i = options.length - 1; i >= 0; i--) {
				(function(){
					var thisOption = options[i];
					$(thisOption).on('click', function(e){
						oldSelect.value = thisOption.getAttribute('data-bp-value');
						newSelect.querySelector('span').innerText = thisOption.getAttribute('data-bp-value');

						me.deactivateElements.apply(me, options);
						me.activateElements(false, thisOption);
						me.deactivateElements(newSelect);

						oldSelect.onchange();

						e.preventDefault();
						return false;
					});
				})();
			};

		}

	}

})(jQuery);