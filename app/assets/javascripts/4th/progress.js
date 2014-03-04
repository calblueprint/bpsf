$(window).load(function(){
  $('span.progressbar').each(function(value) {
    var goalnum = $(this).attr('data-goal');
    var currentnum = $(this).attr('data-current');
    var width = parseInt(currentnum/goalnum*100);
    if (currentnum/goalnum*100 - parseInt(currentnum/goalnum*100) >= 0.5){
      width = width + 1
    }
    var text = width + "%";
    if (width<12 && width!=0){width=10;}
    if (width>100){width=100;}
    var wideness = "width:" + width + "%";
    //$(this).text(text);
    $(this).attr('style', wideness);
  });
});