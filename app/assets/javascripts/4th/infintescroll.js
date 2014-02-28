//var onEndless;

//onEndless = function() {
$(window).scroll(function(){
  //var url;
  //$(window).off('scroll', onEndless);
  url = $('.pagination .next_page').attr('href');
  //$('.pagination').hide();
  if ($(window).scrollTop() > $(document).height() - $(window).height() - 150) {
   // $('.loader').show();
    $('.pagination').text('Fetching more grants...')
    $.getScript(url);
 // } else {
  //  return $(window).on('scroll', onEndless);
  }
});

//$(window).on('scroll', onEndless);

//$(window).scroll();