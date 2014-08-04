$(document).ready(function() {
  $(".chosenselect").chosen({width:'90%'});
  $("input[name=donors]").attr("disabled", true);
  $("#donor-selection").change(function() {
  	console.log("donor-selection changed");
  	var selection = $("#donor-selection")[0].selectedIndex;
  	if (selection == 0) {
  		// Placeholder
  		$("input[name=donors]").attr("disabled", true);
  	} else {
  		$("input[name=donors]").attr("disabled", false);
  	}
  });
});