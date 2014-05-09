$(document).ready(function(){
  $('span.progressbar').each(function(value) {
    var goalTotal = $(this).attr('data-goal');
    var currentTotal = $(this).attr('data-current');
    var width = parseInt(currentTotal/goalTotal * 100 + 0.5);
    if (width < 12 && width != 0){
        width = 10;
    } else if (width > 100){
        width = 100;
      }
    var widthStyle = "width:" + width + "%";
    $(this).attr('style', widthStyle);
  });
});