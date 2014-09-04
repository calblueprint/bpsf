var checkbox = {
	checkboxBind: function(){
		var me = this,
			checkboxes = me.documentObject.querySelectorAll('.checkbox');

		for (var i = checkboxes.length - 1; i >= 0; i--) {
			(function(){
				var checkbox = checkboxes[i];
				$(checkbox).on('click', function(e){
					var inputEl = checkbox.querySelector('input[type="checkbox"]');
					if(inputEl.checked){
						me.deactivateElements(checkbox);
					} else {
						me.activateElements(checkbox);
					}
					inputEl.checked = !inputEl.checked;
					e.preventDefault();
					return false;
				});
			})();
		};
	}
}