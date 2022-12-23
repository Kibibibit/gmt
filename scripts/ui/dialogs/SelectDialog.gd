class_name  SelectDialog
extends TextDialog

var question: String = ""
var options: Array[String] = []
var selected_offset = 1
var selected_option = 0

func _init(s: String, o: Array[String]):
	question = s
	options = o
	super(make_text())
	

func _unhandled_input(event):
	if (is_current_dialog):
		if (event.is_action_released("menu_up")):
			selected_option -= 1
			if (selected_option < 0):
				selected_option = options.size() - 1
			text.set_string(make_text())
			Game.handle_input()
		elif (event.is_action_released("menu_down")):
			selected_option += 1
			if (selected_option >= options.size()):
				selected_option = 0
			text.set_string(make_text())
			Game.handle_input()
		elif (event.is_action_released("menu_accept")):
			ret_value = selected_option+selected_offset
			pop_dialog()
			Game.handle_input()

func make_text():
	var selector = "<"
	
	var base = "%s\n" % question
	var i = 0
	for option in options:
		if (selected_option == i):
			base = "%s\n%s%s" % [base, option, selector]
		else:
			base = "%s\n%s" % [base,option]
		i += 1

	return base
