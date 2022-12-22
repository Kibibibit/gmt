class_name PauseDialog
extends TextDialog

func _init():
	super("Game is paused!\nHit ESC to unpause!\nHit Q to quit!")

func _ready():
	super()
	center_dialog()



func _unhandled_input(event):
	if (is_current_dialog):
		if (event.is_action_pressed("map_pause")):
			Game.handle_input()
			pop_dialog()
		elif (event.is_action_pressed("pause_menu_quit")):
			var quit = await Game.display_dialog(YesNoDialog.new("Quit?","Yes","No").center_dialog())
			if (quit == Dialog.YES):
				get_tree().quit()
