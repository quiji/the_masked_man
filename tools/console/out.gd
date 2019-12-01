extends RichTextLabel


func info(_text, values=null):
	print_line(_text, values, '#68b269', '#31f338')


func warn(_text, values=null):
	print_line(_text, values, '#c9574c', '#e73725')

func print_line(_text, values=null, text_color='#ffffff', outline_color='#ffffff'):
	if values != null:
		var i = 0
		while i < values.size():
			_text = _text.replace(str(i) + '¡', '[color=' + outline_color + ']' + str(values[i]) + '[/color]')
			i += 1
			
	append_bbcode('[color=' + text_color + ']' + _text + '[/color]')
	newline()

