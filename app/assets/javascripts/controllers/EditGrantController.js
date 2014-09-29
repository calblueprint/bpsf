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
		var croppic = document.querySelector('#croppic'),
			croppicButton = document.querySelector('#croppic_button'),
			croppicOptions = {
				uploadUrl: croppic.getAttribute('data-uploadurl'),
				cropUrl: croppic.getAttribute('data-cropurl'),
				zoomFactor: 0,
				doubleZoomControls: false,
				imgEyecandy: false,
				loaderHtml: "<div class='loader-blob active' style='position: absolute; \
										text-align: center; width:100%; height:50px; \
										top: 50%; right: initial; display:block; \
										z-index:2; transform: none; \
										-webkit-transform:none; -moz-transform:none; \
										-o-transform:none; -ms-transform:none;'> \
				        				<div class='bounce-1'></div> \
										<div class='bounce-2'></div> \
										<div class='bounce-3'></div> \
									</div>",
				customUploadButtonId: 'upload_button'
			};

		if(croppic && !$(croppic).hasClass('display-none')){
			new Croppic('croppic', croppicOptions);
		} else {
			$(croppicButton).on('click', function(){
				$(croppic).removeClass('display-none');
				$('.grant-cover-wrapper').remove();
				new Croppic('croppic', croppicOptions);
			});
		}
	}
}

EditGrantController.prototype = Object.create(AppController.prototype);
EditGrantController.prototype.constructor = EditGrantController;