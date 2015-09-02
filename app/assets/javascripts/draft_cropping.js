//# jQuery ->
//#   new ImageCropper()
//
//# class ImageCropper
//#   width: 300
//#   height: 150
//
//#   constructor: ->
//#     $('#cropbox').Jcrop
//#       aspectRatio: 2
//#       setSelect: [0, 0, 300, 150]
//#       onSelect: @update
//#       onChange: @update
//
//#   update: (coords) =>
//#     $('#draft_grant_crop_x').val(coords.x)
//#     $('#draft_grant_crop_y').val(coords.y)
//#     $('#draft_grant_crop_w').val(coords.w)
//#     $('#draft_grant_crop_h').val(coords.h)
//#     $('#grant_crop_x').val(coords.x)
//#     $('#grant_crop_y').val(coords.y)
//#     $('#grant_crop_w').val(coords.w)
//#     $('#grant_crop_h').val(coords.h)
//#     @updatePreview(coords)
//
//#   updatePreview: (coords) =>
//#     $('#preview').css
//#       width: Math.round(300/coords.w * $('#cropbox').width()) + 'px'
//#       height: Math.round(150/coords.h * $('#cropbox').height()) + 'px'
//#       marginLeft: '-' + Math.round(300/coords.w * coords.x) + 'px'
//#       marginTop: '-' + Math.round(150/coords.h * coords.y) + 'px'

