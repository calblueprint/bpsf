  $('span.schooltext').each(function(index, value) {
      var text = $(this).text();
      if (text.length > 25){
          text = text.substr(0,22) + '...';
          $(this).text(text);
      }
  });

  $('span.destext').each(function(index, value) {
      var text = $(this).text();
      if (text.length > 150){
          text = text.substr(0,60) + '...';
          $(this).text(text);
      }
  });