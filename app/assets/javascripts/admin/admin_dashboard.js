
$(document).ready(function(){

	// $(".crowdfund").click(function(event){
	// 	alert("button pressed");
	// 	$.ajax({
	// 		url: crowdfund_form,
	// 		type: "GET",
	// 		data: {id : event.target.id },
	// 		success: function(data) {
	// 			alert("got something back")
	// 			$("#modal-content").html(data);
	// 			$("#crowdfund-modal").addClass("active");
	// 		},
	// 		error: function() {
	// 			   alert("CRAP");
	// 		}
	// 	});
	// });
	$(".crowdfund").bind("ajax:success", function(evt, data, status, xhr){
		alert("button pressed");
		$("#modal-content").html(data);
		$("#crowdfund-modal").addClass("active");
	}).bind("ajax:error", function(evt, data, status, xhr){
		// We should do something with the errors.
		// When we add an error div this should add stuff to it.
	});
});


