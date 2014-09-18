var EditGrantController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.extend(formToolTip);
		me.initFormToolTip();

		me.confirmSave();
	}

	me.confirmSave = function(){
		var hasChanged = false;

		$('.bp-edit-grant form :input').on('change', function(){
			hasChanged = true;
		});

		$(window).on('beforeunload', function(){
			if(hasChanged){
			    return 'You have unsaved changes. Are you sure you want to leave?';
			}
		});

		$(document).on('page:before-change', function(){
			if(hasChanged){
				return confirm('You have unsaved changes. Are you sure you want to leave?');
			}
		});
	}

	me.deactivate = function(){
		$(window).off('beforeunload');
		$(document).off('page:before-change');
	}
}

EditGrantController.prototype = Object.create(AppController.prototype);
EditGrantController.prototype.constructor = EditGrantController;