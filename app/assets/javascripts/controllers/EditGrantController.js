var EditGrantController = function(documentObject){
	var me = this;
	AppController.call(me, documentObject);
	me.documentObject = documentObject || document;

	me.init = function(){
		me.extend(formToolTip);
		me.initFormToolTip();
		me.activateChosen();

		me.confirmSave();
		me.uploadImg();
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

		$('#save_button').on('click', function(){
			hasChanged = false;
		});

		$('#submit_button').on('click', function(){
			hasChanged = false;
		});
	}

	me.activateChosen = function(){
		$(".chosenselect").chosen({width:'100%'});
	}

	me.deactivate = function(){
		$(window).off('beforeunload');
		$(document).off('page:before-change');
	}

	me.uploadImg = function(){
		var button = me.documentObject.querySelector('#upload_button'),
			fileInput = me.documentObject.querySelector('#upload_input'),
			saveButton = me.documentObject.querySelector('#save_button');

		$(button).on('click', function(e){
			$(fileInput).trigger('click');
			e.preventDefault();
			return false;
		});

		$(fileInput).on('change', function(){
			$(save_button).trigger('click');
		});
	}
}

EditGrantController.prototype = Object.create(AppController.prototype);
EditGrantController.prototype.constructor = EditGrantController;