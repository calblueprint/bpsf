var truncate = {
	setupTruncate: function(){
		var me = this,
		textBoxes = me.documentObject.querySelectorAll('[data-bp-truncate]');
		for (var i = textBoxes.length - 1; i >= 0; i--) {
			var maxLines = Number(textBoxes[i].getAttribute('data-bp-truncate'));
			me.truncateLines(textBoxes[i], maxLines);
		};
	},
	truncateLines: function(textBox, maxLines){
		var offsetHeight = textBox.offsetHeight,
			scrollHeight = textBox.scrollHeight,
			origText = textBox.innerText;
		
		textBox.innerText += '\n .';
		var lineHeight = textBox.scrollHeight - scrollHeight || false;

		if(lineHeight && scrollHeight / lineHeight > maxLines){
			while(textBox.scrollHeight / lineHeight > maxLines){
				textBox.innerText = textBox.innerText.substring(0, textBox.innerText.length - 1);
			}
			textBox.innerText = textBox.innerText.substring(0, textBox.innerText.length - 4);
			textBox.innerHTML += '&hellip;';
		} else {
			textBox.innerText = origText;
		}

	}
}
