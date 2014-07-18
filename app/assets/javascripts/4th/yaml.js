var YamlManager = function(){
		var me = this;
		this.fn = this.prototype;

		me.init = function(){
			me.yamlContent = $('#yaml-content');
			me.yamlCanvas = $('#yaml-canvas');
			me.yamlTitle = $('#yaml-title');
			if(me.yamlContent && me.yamlCanvas){
				me.initDataStores();
				me.initContentFields();
			} else{
				console.log('Error: No yaml content fields present')
			}
		}

		me.initDataStores = function(){
			me.yamlText = me.yamlContent.val();
			me.yamlTextByLine = me.yamlText.split('\n').filter(me.isNotEmptyString);
			me.yamlTextByLineLength = me.yamlTextByLine.length;
			me.yamlTextByKey = [];

			me.populateYamlTextByKey();
		}

		me.isNotEmptyString = function(str){
			return str != ''
		}

		me.isNotEmptyArray = function(arr){
			return arr != [] && arr.length > 0
		}

		me.populateYamlTextByKey = function(){
			for (var i = 0; i < me.yamlTextByLineLength; i++) {
				var indexOfColon = me.yamlTextByLine[i].indexOf(':');
				me.yamlTextByKey[i] = [];
				me.yamlTextByKey[i][0] = me.yamlTextByLine[i].slice(0, indexOfColon + 1);
				me.yamlTextByKey[i][1] = me.yamlTextByLine[i].slice(indexOfColon + 1);
				me.yamlTextByKey[i] = me.yamlTextByKey[i].filter(me.isNotEmptyString);
			};

			me.yamlTextByKeyLength = me.yamlTextByKey.length;
		}

		me.initContentFields = function(){
			$(me.yamlTextByKey).each(function(index, val){
				if(val.length == 2){
					var newFieldEl = me.constructField(index, val);

					$(newFieldEl).on('keyup', function(){
						me.updateYamlText(newFieldEl);
					});
				} else {
					me.yamlTitle.append('<h3 class="inlined">' + val[0] + '></h3>');
				}
			});	
		}

		me.updateYamlText = function(newFieldEl){
			var index = newFieldEl.data('index');
			console.log(index);
			me.yamlTextByKey[index][1] = newFieldEl.val();
			for (var i = 0; i < me.yamlTextByKeyLength; i++) {
				me.yamlTextByLine[i] = me.yamlTextByKey[i].join('');
			}    
			me.yamlContent.val(me.yamlTextByLine.join('\n'));
		}

		me.chooseFieldType = function(fieldVal){
			if(fieldVal.length > 50){
				return 'input'
			} else{
				return 'textarea'
			}
		}

		me.constructField = function(index, val){
			var fieldType = me.chooseFieldType(val[1]),
				newFieldText = '<div class="field"> \
									<label class="inline" for="field-' + index + '">' + val[0] + '</label> \
									<input class="input text" value="' + val[1] + '" data-index=' + index + ' > \
								</div>',
				newFieldObject = $(newFieldText).appendTo(me.yamlCanvas);

			return newFieldObject.find('input');
		}

		me.init();
	}

$(document).ready(function(){
	var yamlManager = new YamlManager();
})