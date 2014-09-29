/*
 * CROP
 * dependancy: jQuery
 * author: Ognjen "Zmaj Džedaj" Božičković
 */

(function (window, document) {

  Croppic = function (id, options) {

    var me = this;
    me.id = id;
    me.obj = $('#' + id);
    me.outputDiv = me.obj;

    // DEFAULT OPTIONS
    me.options = {
      uploadUrl:'',
      uploadData:{},
      cropUrl:'',
      cropData:{},
      outputUrlId:'',
      //styles
      imgEyecandy:true,
      imgEyecandyOpacity:0.2,
      zoomFactor:10,
      doubleZoomControls:true,
      modal:false,
      customUploadButtonId:'',
      loaderHtml:'',
      //callbacks
      onBeforeImgUpload: null,
      onAfterImgUpload: null,
      onImgDrag: null,
      onImgZoom: null,
      onBeforeImgCrop: null,
      onAfterImgCrop: null
    };

    // OVERWRITE DEFAULT OPTIONS
    for (i in options) me.options[i] = options[i];

    // INIT THE WHOLE DAMN THING!!!
    me.init();

  };

  Croppic.prototype = {
    id:'',
    imgInitW:0,
    imgInitH:0,
    imgW:0,
    imgH:0,
    objW:0,
    objH:0,
    windowW:0,
    windowH:$(window).height(),
    obj:{},
    outputDiv:{},
    outputUrlObj:{},
    img:{},
    defaultImg:{},
    croppedImg:{},
    imgEyecandy:{},
    form:{},
    cropControlsUpload:{},
    cropControlsCrop:{},
    cropControlZoomMuchIn:{},
    cropControlZoomMuchOut:{},
    cropControlZoomIn:{},
    cropControlZoomOut:{},
    cropControlCrop:{},
    cropControlReset:{},
    cropControlRemoveCroppedImage:{},
    modal:{},
    loader:{},

    init: function () {
      var me = this;

      me.objW = me.obj.width();
      me.objH = me.obj.height();

      if( $.isEmptyObject(me.defaultImg)){ me.defaultImg = me.obj.find('img'); }

      me.createImgUploadControls();
      me.bindImgUploadControl();

    },
    createImgUploadControls: function(){
      var me = this;

      var cropControlUpload = '';
      if(me.options.customUploadButtonId ===''){ cropControlUpload = '<i class="cropControlUpload"></i>'; }
      var cropControlRemoveCroppedImage = '<div class="medium primary btn pointer cropControlRemoveCroppedImage"><a>Change Image</a></div>';

      if( $.isEmptyObject(me.croppedImg)){ cropControlRemoveCroppedImage=''; }

      var html =    '<div class="cropControls cropControlsUpload"> ' + cropControlUpload + cropControlRemoveCroppedImage + ' </div>';
      me.outputDiv.append(html);

      me.cropControlsUpload = me.outputDiv.find('.cropControlsUpload');

      if(me.options.customUploadButtonId ===''){ me.imgUploadControl = me.outputDiv.find('.cropControlUpload'); }
      else{ me.imgUploadControl = $('#'+me.options.customUploadButtonId); me.imgUploadControl.show(); }

      if( !$.isEmptyObject(me.croppedImg)){
        me.cropControlRemoveCroppedImage = me.outputDiv.find('.cropControlRemoveCroppedImage');
      }

    },
    bindImgUploadControl: function(){

      var me = this;

      // CREATE UPLOAD IMG FORM
      var formHtml = '<form class="'+me.id+'_imgUploadForm" style="display: none; visibility: hidden;">  <input type="file" name="img">  </form>';
      me.outputDiv.append(formHtml);
      me.form = me.outputDiv.find('.'+me.id+'_imgUploadForm');

      me.imgUploadControl.off('click');
      me.imgUploadControl.on('click',function(){
        me.form.find('input[type="file"]').trigger('click');
      });

      if( !$.isEmptyObject(me.croppedImg)){

        me.cropControlRemoveCroppedImage.on('click',function(){
          me.croppedImg.remove();
          $(this).hide();

          if( !$.isEmptyObject(me.defaultImg)){
            me.obj.append(me.defaultImg);
          }

          if(me.options.outputUrlId !== ''){  $('#'+me.options.outputUrlId).val('');  }

        });

      }

      me.form.find('input[type="file"]').change(function(){

        if (me.options.onBeforeImgUpload) me.options.onBeforeImgUpload.call(me);

        me.showLoader();
        me.imgUploadControl.hide();

        var formData = new FormData(me.form[0]);

        for (var key in me.options.uploadData) {
          if( me.options.uploadData.hasOwnProperty(key) ) {
            formData.append( key , me.options.uploadData[key] );
          }
        }

        $.ajax({
                    url: me.options.uploadUrl,
                    data: formData,
                    context: document.body,
                    cache: false,
                    contentType: false,
                    processData: false,
                    type: 'POST'
        }).always(function(data){
          // response = jQuery.parseJSON(data);
          response = data;
          if(response.status=='success'){

            me.imgInitW = me.imgW = response.width;
            me.imgInitH = me.imgH = response.height;

            if(me.options.modal){ me.createModal(); }
            if( !$.isEmptyObject(me.croppedImg)){ me.croppedImg.remove(); }

            me.imgUrl=response.url;

            me.obj.append('<img src="'+response.url+'">');
            me.initCropper();

            me.hideLoader();

            if (me.options.onAfterImgUpload) me.options.onAfterImgUpload.call(me);

          }

          if(response.status=='error'){
            me.obj.append('<p style="width:100%; height:100%; text-align:center; line-height:'+me.objH+'px;">'+response.message+'</p>');
            me.hideLoader();
            setTimeout( function(){ me.reset(); },2000)
          }


        });

      });

    },
    createModal: function(){
      var me = this;

      var marginTop = me.windowH/2-me.objH/2;
      var modalHTML =  '<div id="croppicModal">'+'<div id="croppicModalObj" style="width:'+ me.objW +'px; height:'+ me.objH +'px; margin:0 auto; margin-top:'+ marginTop +'px; position: relative;"> </div>'+'</div>';

      $('body').append(modalHTML);

      me.modal = $('#croppicModal');

      me.obj = $('#croppicModalObj');

    },
    destroyModal: function(){
      var me = this;

      me.obj = me.outputDiv;
      me.modal.remove();
    },
    initCropper: function(){
      var me = this;

      /*SET UP SOME VARS*/
      me.img = me.obj.find('img');
      me.img.wrap('<div class="cropImgWrapper" style="overflow:hidden; z-index:1; position:absolute; width:'+me.objW+'px; height:'+me.objH+'px;"></div>');

      /*INIT DRAGGING*/
      me.createCropControls();

      if(me.options.imgEyecandy){ me.createEyecandy(); }
      me.initDrag();
      me.initialScaleImg();
    },
    createEyecandy: function(){
      var me = this;

      me.imgEyecandy = me.img.clone();
      me.imgEyecandy.css({'z-index':'0','opacity':me.options.imgEyecandyOpacity}).appendTo(me.obj);
    },
    destroyEyecandy: function(){
      var me = this;
      me.imgEyecandy.remove();
    },
    initialScaleImg:function(){
      var me = this;
      me.zoom(-me.imgInitW);
      //me.zoom(40);

      // initial center image
      me.img.css({'left': 0, 'top': 0, 'position':'relative'});
      if(me.options.imgEyecandy){ me.imgEyecandy.css({'left': -(me.imgW -me.objW)/2, 'top': -(me.imgH -me.objH)/2, 'position':'relative'}); }

    },

    createCropControls: function(){
      var me = this;

      // CREATE CONTROLS
      var cropControlZoomMuchIn =      '<i class="cropControlZoomMuchIn"></i>';
      var cropControlZoomIn =          '<i class="cropControlZoomIn"></i>';
      var cropControlZoomOut =         '<i class="cropControlZoomOut"></i>';
      var cropControlZoomMuchOut =     '<i class="cropControlZoomMuchOut"></i>';
      var cropControlCrop =            '<div class="medium primary btn pointer cropControlCrop"><a>Save Image</a></div>';
      var cropControlReset =           '<div class="medium primary btn pointer cropControlReset nudge-left"><a>Change Image</a></div>';

            var html;

      if(me.options.doubleZoomControls){ html =  '<div class="cropControls cropControlsCrop">'+ cropControlZoomMuchIn + cropControlZoomIn + cropControlZoomOut + cropControlZoomMuchOut + cropControlCrop + cropControlReset + '</div>'; }
      else{ html =  '<div class="cropControls cropControlsCrop">' + cropControlCrop + cropControlReset + '</div>'; }

      me.obj.append(html);

      me.cropControlsCrop = me.obj.find('.cropControlsCrop');

      // CACHE AND BIND CONTROLS
      if(me.options.doubleZoomControls){
        me.cropControlZoomMuchIn = me.cropControlsCrop.find('.cropControlZoomMuchIn');
        me.cropControlZoomMuchIn.on('click',function(){ me.zoom( me.options.zoomFactor*10 ); });

        me.cropControlZoomMuchOut = me.cropControlsCrop.find('.cropControlZoomMuchOut');
        me.cropControlZoomMuchOut.on('click',function(){ me.zoom(-me.options.zoomFactor*10); });

        me.cropControlZoomIn = me.cropControlsCrop.find('.cropControlZoomIn');
        me.cropControlZoomIn.on('click',function(){ me.zoom(me.options.zoomFactor); });

        me.cropControlZoomOut = me.cropControlsCrop.find('.cropControlZoomOut');
        me.cropControlZoomOut.on('click',function(){ me.zoom(-me.options.zoomFactor); });
      }

      me.cropControlCrop = me.cropControlsCrop.find('.cropControlCrop');
      me.cropControlCrop.on('click',function(){ me.crop(); });

      me.cropControlReset = me.cropControlsCrop.find('.cropControlReset');
      me.cropControlReset.on('click',function(){ me.reset(); });

    },
    initDrag:function(){
      var me = this;

      me.img.on("mousedown", function(e) {

        e.preventDefault(); // disable selection

        var z_idx = me.img.css('z-index'),
                drg_h = me.img.outerHeight(),
                drg_w = me.img.outerWidth(),
                pos_y = me.img.offset().top + drg_h - e.pageY,
                pos_x = me.img.offset().left + drg_w - e.pageX;

        me.img.css('z-index', 1000).on("mousemove", function(e) {

          var imgTop = e.pageY + pos_y - drg_h;
          var imgLeft = e.pageX + pos_x - drg_w;

          me.img.offset({
            top:imgTop,
            left:imgLeft
          }).on("mouseup", function() {
            $(this).removeClass('draggable').css('z-index', z_idx);
          });

          if(me.options.imgEyecandy){ me.imgEyecandy.offset({ top:imgTop, left:imgLeft }); }

          if( parseInt( me.img.css('top')) > 0 ){ me.img.css('top',0);  if(me.options.imgEyecandy){ me.imgEyecandy.css('top', 0); } }
          var maxTop = -( me.imgH-me.objH); if( parseInt( me.img.css('top')) < maxTop){ me.img.css('top', maxTop); if(me.options.imgEyecandy){ me.imgEyecandy.css('top', maxTop); } }

          if( parseInt( me.img.css('left')) > 0 ){ me.img.css('left',0); if(me.options.imgEyecandy){ me.imgEyecandy.css('left', 0); }}
          var maxLeft = -( me.imgW-me.objW); if( parseInt( me.img.css('left')) < maxLeft){ me.img.css('left', maxLeft); if(me.options.imgEyecandy){ me.imgEyecandy.css('left', maxLeft); } }

          if (me.options.onImgDrag) me.options.onImgDrag.call(me);

        });

      }).on("mouseup", function() {
        me.img.off("mousemove");
      }).on("mouseout", function() {
        me.img.off("mousemove");
      });

    },
    zoom :function(x){
      var me = this;
      var ratio = me.imgW / me.imgH;
      var newWidth = me.imgW+x;
      var newHeight = newWidth/ratio;
      var doPositioning = true;

      if( newWidth < me.objW || newHeight < me.objH){

        if( newWidth - me.objW < newHeight - me.objH ){
          newWidth = me.objW;
          newHeight = newWidth/ratio;
        }else{
          newHeight = me.objH;
          newWidth = ratio * newHeight;
        }

        doPositioning = false;

      }

      if( newWidth > me.imgInitW || newHeight > me.imgInitH){

        if( newWidth - me.imgInitW < newHeight - me.imgInitH ){
          newWidth = me.imgInitW;
          newHeight = newWidth/ratio;
        }else{
          newHeight = me.imgInitH;
          newWidth = ratio * newHeight;
        }

        doPositioning = false;

      }

      me.imgW = newWidth;
      me.img.width(newWidth);

      me.imgH = newHeight;
      me.img.height(newHeight);

      var newTop = parseInt( me.img.css('top') ) - x/2;
      var newLeft = parseInt( me.img.css('left') ) - x/2;

      if( newTop>0 ){ newTop=0;}
      if( newLeft>0 ){ newLeft=0;}

      var maxTop = -( newHeight-me.objH); if( newTop < maxTop){ newTop = maxTop;  }
      var maxLeft = -( newWidth-me.objW); if( newLeft < maxLeft){ newLeft = maxLeft;  }

      if( doPositioning ){
        me.img.css({'top':newTop, 'left':newLeft});
      }

      if(me.options.imgEyecandy){
        me.imgEyecandy.width(newWidth);
        me.imgEyecandy.height(newHeight);
        if( doPositioning ){
          me.imgEyecandy.css({'top':newTop, 'left':newLeft});
        }
      }

      if (me.options.onImgZoom) me.options.onImgZoom.call(me);

    },
    crop:function(){
      var me = this;

      if (me.options.onBeforeImgCrop) me.options.onBeforeImgCrop.call(me);

      me.cropControlsCrop.hide();
      me.showLoader();

      var cropData = {
          imgUrl:me.imgUrl,
          imgInitW:me.imgInitW,
          imgInitH:me.imgInitH,
          imgW:me.imgW,
          imgH:me.imgH,
          imgY1:Math.abs( parseInt( me.img.css('top') ) ),
          imgX1:Math.abs( parseInt( me.img.css('left') ) ),
          cropH:me.objH,
          cropW:me.objW
        };


      var formData = new FormData();

      for (var key in cropData) {
        if( cropData.hasOwnProperty(key) ) {
            formData.append( key , cropData[key] );
        }
      }

      for (var key in me.options.cropData) {
        if( me.options.cropData.hasOwnProperty(key) ) {
            formData.append( key , me.options.cropData[key] );
        }
      }

      $.ajax({
          url: me.options.cropUrl,
          data: formData,
          context: document.body,
          cache: false,
          contentType: false,
          processData: false,
          type: 'POST'
        }).always(function(data){
          // response = jQuery.parseJSON(data);
          response = data;
          if(response.status=='success'){

//            me.imgEyecandy.hide();

            me.destroy();

            me.obj.append('<img class="croppedImg" src="'+response.url+'">');
            if(me.options.outputUrlId !== ''){  $('#'+me.options.outputUrlId).val(response.url);  }

            me.croppedImg = me.obj.find('.croppedImg');

            me.init();

            me.hideLoader();

          }
          if(response.status=='error'){
            me.obj.append('<p style="width:100%; height:100%;>'+response.message+'</p>">');
          }

          if (me.options.onAfterImgCrop) me.options.onAfterImgCrop.call(me);

        });
    },
    showLoader:function(){
      var me = this;

      me.obj.append(me.options.loaderHtml);
      me.loader = me.obj.find('.loader-blob');

    },
    hideLoader:function(){
      var me = this;
      me.loader.remove();
    },
    reset:function(){
      var me = this;
      me.destroy();

      me.obj.append(
            '<div class="grant-cover-prompt"> \
              <h4>Cover Image</h4> \
              <h6 class="subhead no-margin">Choose a photo that will appear at the top \
              of your application. Please choose an image with a 2:1 aspect ratio.</h6> \
              <div class="medium primary btn pointer" id="upload_button"> \
                <a>Upload Cover Image</a> \
              </div> \
            </div>');

      me.init();

      if( !$.isEmptyObject(me.croppedImg)){
        me.obj.append(me.croppedImg);
        if(me.options.outputUrlId !== ''){  $('#'+me.options.outputUrlId).val(me.croppedImg.attr('url')); }
      }

    },
    destroy:function(){
      var me = this;
      if(me.options.modal && !$.isEmptyObject(me.modal) ){ me.destroyModal(); }
      if(me.options.imgEyecandy && !$.isEmptyObject(me.imgEyecandy) ){  me.destroyEyecandy(); }
      if( !$.isEmptyObject( me.cropControlsUpload ) ){  me.cropControlsUpload.remove(); }
      if( !$.isEmptyObject( me.cropControlsCrop ) ){   me.cropControlsCrop.remove(); }
      if( !$.isEmptyObject( me.loader ) ){   me.loader.remove(); }
      if( !$.isEmptyObject( me.form ) ){   me.form.remove(); }
      me.obj.html('');
    }
  };
})(window, document);
