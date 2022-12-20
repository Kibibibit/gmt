class_name YesNoDialog
extends TextDialog

var question: String = ""
var positive: String = "Yes"
var negative: String = "No"

const selector = "<"
var yes_no_offset = 1
var selected = 0

func _init(s: String, p:String, n: String):
	question = s
	positive = p
	negative = n
	super(make_text())

func _unhandled_input(event):
	if (event.is_action_pressed("ui_up") || event.is_action_pressed("ui_down")):
		selected = abs(selected-1)
		text.set_string(make_text())
		Game.handle_input()
	elif (event.is_action_pressed("ui_accept")):
		ret_value = selected+yes_no_offset
		pop_dialog()
		Game.handle_input()


func make_text():
	var neg_selector = ""
	var pos_selector = "<"
	if (selected+yes_no_offset == Dialog.NO):
		neg_selector = "<"
		pos_selector =""
	var base = "%s\n\n\n%s%s\n%s%s"
	if (question.length() == 0):
		base = "%s%s%s\n%s%s"
	return base % [question, positive, pos_selector, negative, neg_selector]
