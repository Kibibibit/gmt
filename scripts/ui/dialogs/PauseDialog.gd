class_name PauseDialog
extends TextDialog

func _init():
	super("Game is paused!\nHit ESC to go!")

func _ready():
	super()
	center_dialog()



func _unhandled_input(event):
	if (is_current_dialog):
		if (event.is_action_pressed("ui_cancel")):
			Game.handle_input()
			pop_dialog()
			
