class_name TextDialog
extends Dialog

@onready var text: Text = Text.new()
@onready var string: String


func _init(s: String, w: int = border_size, h: int = border_size):
	super(w,h)
	string = s
	

func _ready():
	add_child(text)
	text.z_index = 1
	text.position = Vector2(Dialog.border_size, Dialog.border_size)
	text.set_string(string)
	resize(Vector2i(floor(text.columns()*Dialog.border_size*0.5), floor(text.lines()*Dialog.border_size*0.5)))
	super()
