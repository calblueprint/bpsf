$(document).ready(function(){
	var yamlContent = $('#yaml-content'),
	var notEmptyString = function(string){
		return string != '' || string != undefined
	}
	if(yamlContent){
		var yamlText = yamlContent.val(),
			yamlTextByLine = yamlText.split('\n').filter(notEmptyString),
			yamlTextByKey = [],
			yamlTextByLineLength = yamlTextByLine.length,
			yamlCanvas = $('#yaml-canvas');

		for (var i = 0; i < yamlTextByLineLength; i++) {
			yamlTextByKey[i] = yamlTextByLine[i].split(':').filter(notEmptyString)
		};

	}
})