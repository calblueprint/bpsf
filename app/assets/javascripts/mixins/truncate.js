var truncate = {
	setupTruncate: function(){
		var me = this,
		textBoxes = me.documentObject.querySelectorAll('[data-bp-truncate]');
		for (var i = textBoxes.length - 1; i >= 0; i--) {
			var maxLines = Number(textBoxes[i].getAttribute('data-bp-truncate')),
			truncateLines(textBoxes[i], maxLines);
		};
	},
	truncateLines: function(textBox, maxLines){
		var offsetHeight = textBox.offsetHeight,
			scrollHeight = textBox.scrollHeight,
			origText = textBox.innerText;
		
		textBox.innerText += '\n .';
		var lineHeight = scrollHeight - textBox.scrollHeight;

		if(scrollHeight / lineHeight > maxLines){
			while(scrollHeight / lineHeight > maxLines){
				textBox.innerText = textBox.innerText.substring(0, textBox.innerText.length - 1);
			}
			textBox.innerText = textBox.innerText.substring(0, textBox.innerText.length - 2) + '&hellip;';
		} else {
			textBox.innerText = origText;
		}

	}
}
