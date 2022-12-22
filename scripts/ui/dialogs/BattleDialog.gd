class_name BattleDialog
extends Dialog

const battle_dialog_height = 32

@onready
var text: Text = Text.new()

@onready
var string_width = floor(((Game.width() - (Dialog.border_size*2)) as float)/16)

func _ready():
	super()
	text.position = Vector2(Dialog.border_size, Dialog.border_size)
	add_child(text)
	resize(Vector2i(Game.width() - (Dialog.border_size*2), battle_dialog_height))
	position = Vector2(0, Game.height()-battle_dialog_height - (Dialog.border_size*2))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_text(string: String):
	if (string.length() > string_width):
		var words = string.split(" ")
		var line = ""
		var new_string = ""
		for word in words:
			if line.length() + word.length() + 1 < string_width:
				if (line.length() > 0):
					line = "%s %s" % [line, word]
				else:
					line = word
			else:
				if (new_string.length() > 0):
					new_string = "%s\n%s" % [new_string, line]
				else:
					new_string = line
				line = word
		if (line.length() > 0):
			new_string = "%s\n%s" % [new_string, line]
		string = new_string
	
	text.set_string(string)
