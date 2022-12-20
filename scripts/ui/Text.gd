class_name Text
extends Node2D

const alphabet = {
	"a":0,
	"b":1,
	"c":2,
	"d":3,
	"e":4,
	"f":5,
	"g":6,
	"h":7,
	"i":8,
	"j":9,
	"k":10,
	"l":11,
	"m":12,
	"n":13,
	"o":14,
	"p":15,
	"q":16,
	"r":17,
	"s":18,
	"t":19,
	"u":20,
	"v":21,
	"w":22,
	"x":23,
	"y":24,
	"z":25,
	"<":26,
	"?":27,
	"!":28,
	" ":29
}

const newline = "\n"
const char_size = 16

var texture = load("res://sprites/font-white.png")

var string: String = ""
var sprite_stack: Array[Sprite2D] = []

func _init(s: String = ""):
	string = s

func _ready():
	set_string(string)

func set_string(new_string: String):
	string = new_string
	update_sprite_stack()
	update_sprites()

func update_sprites():
	var x: int = 0
	var y: int = 0
	
	var text = string
	var i = 0
	while text.length() > 0:
		if (text.begins_with(newline)):
			x = 0
			y += char_size
		else:
			sprite_stack[i].frame = alphabet[text.substr(0,1).to_lower()]
			sprite_stack[i].position = Vector2(x as float, y as float)
			x += char_size
			i += 1
		text = text.substr(1,text.length())
		

func update_sprite_stack():
	while (sprite_stack.size() > text_length()):
		var sprite: Sprite2D = sprite_stack.pop_back()
		remove_child(sprite)
		sprite.queue_free()
	while (sprite_stack.size() < text_length()):
		var sprite = create_sprite()
		sprite_stack.push_back(sprite)
		add_child(sprite)

func create_sprite() -> Sprite2D:
	var sprite: Sprite2D = Sprite2D.new()
	sprite.centered = false
	sprite.texture = texture
	sprite.hframes = 8
	sprite.vframes = 4
	return sprite

func columns() -> int:
	var split_lines = string.split(newline)
	var length = 0
	for line in split_lines:
		if (line.length() > length):
			length = line.length()
	return length

func text_length() -> int:
	return string.length() - (lines() - 1)

func lines() -> int:
	return string.count(newline) + 1
