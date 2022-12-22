class_name Dialog
extends Node2D

signal dialog_closed(output)

const YES = 1
const NO = 2

var base_texture = load("res://sprites/dialog.png")

var frame_center := 0
var frame_top_left := 1
var frame_top_right := 2
var frame_bottom_left := 3
var frame_bottom_right := 4
var frame_left := 5
var frame_right := 6
var frame_top := 7
var frame_bottom := 8

var ret_value = 0

@onready
var top_left := Sprite2D.new()
@onready
var top := Sprite2D.new()
@onready
var top_right := Sprite2D.new()
@onready
var left := Sprite2D.new()
@onready
var center := Sprite2D.new()
@onready
var right := Sprite2D.new()
@onready
var bottom_left := Sprite2D.new()
@onready
var bottom := Sprite2D.new()
@onready
var bottom_right := Sprite2D.new()

const border_size = 32

var content_width: int
var content_height: int

var centered = false

@onready
var is_current_dialog: bool = false

@onready
var sprite_map: Dictionary = {
	frame_top_left: top_left,
	frame_top: top,
	frame_top_right: top_right,
	frame_left: left,
	frame_center: center,
	frame_right: right,
	frame_bottom_left: bottom_left,
	frame_bottom: bottom,
	frame_bottom_right: bottom_right
}

func _init(w: int = border_size, h: int = border_size):
	content_width = w
	content_height = h

func _process(_delta):
	is_current_dialog = Game.ui_stack.back() == self.get_instance_id()

func pop_dialog():
	get_parent().remove_child(self)
	self.queue_free()
	Game.ui_stack.pop_back()
	emit_signal("dialog_closed",ret_value)

func resize(size: Vector2i):
	content_width = size.x
	content_height = size.y
	if (centered):
		center_dialog()
	set_sizes()
	
func _ready():
	z_index = Game.ui_stack.size() * 10
	for key in sprite_map.keys():
		var sprite = sprite_map[key]
		sprite.texture = base_texture
		sprite.hframes = 3
		sprite.vframes = 3
		sprite.centered = false
		sprite.frame = key
		add_child(sprite)
	set_sizes()
	Game.ui_stack.push_back(self.get_instance_id())

func center_dialog() -> Dialog:
	var w: float = float(content_width + (border_size*2))
	var h: float = float(content_height + (border_size*2))
	position.x = float(Game.width())/2 - (w/2)
	position.y = float(Game.height())/2 - (h/2)
	centered = true
	return self

func set_sizes():
	top_left.position = Vector2(0,0)
	top.position = Vector2(border_size, 0)
	top_right.position = Vector2(border_size+content_width, 0)
	scale_sprite_width(top,content_width)
	
	left.position = Vector2(0, border_size)
	scale_sprite_height(left, content_height)
	center.position = Vector2(border_size, border_size)
	scale_sprite_width(center, content_width)
	scale_sprite_height(center, content_height)
	right.position = Vector2(border_size+content_width, border_size)
	scale_sprite_height(right, content_height)
	
	bottom_left.position = Vector2(0, border_size+content_height)
	bottom.position = Vector2(border_size, border_size+content_height)
	scale_sprite_width(bottom, content_width)
	bottom_right.position = Vector2(border_size+content_width, border_size+content_height)

func scale_sprite_width(sprite: Sprite2D, pixels: int):
	sprite.scale.x = make_scale(pixels)

func scale_sprite_height(sprite: Sprite2D, pixels: int):
	sprite.scale.y = make_scale(pixels)

func make_scale(pixels: int) -> float:
	return (pixels as float)/(border_size as float)
