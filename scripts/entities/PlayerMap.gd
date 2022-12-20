class_name PlayerMap
extends Node2D

@onready
var sprite: Sprite2D = Sprite2D.new()

@onready
var world: World = get_parent() as World

@onready
var move_timer: Timer = Timer.new()

@onready
var can_move: bool = true

var move_speed: float = 0.15

var lerp_speed: float = 15.0

func _ready():
	add_child(move_timer)
	move_timer.connect("timeout", Callable(self,"_on_timeout"))
	sprite.centered = false
	sprite.texture = load("res://sprites/player.png")
	add_child(sprite)

func _unhandled_input(event):
	if (Game.ui_stack.is_empty()):
		if (event.is_action_pressed("ui_accept")):
			Game.handle_input()
			await Game.display_dialog(PauseDialog.new())
			

func _process(delta):
	if (Game.ui_stack.is_empty()):
		process_moving()
	
	self.position = self.position.lerp(PlayerData.map_pos * world.tile_size, delta*lerp_speed)

func process_moving():
	if (can_move):
		var walls: int = world.grid.at_v(PlayerData.map_pos).walls
		if Input.is_action_pressed("ui_down") && (walls & ~world.down_mask == 0):
			PlayerData.map_pos.y += 1
			moved()
		elif Input.is_action_pressed("ui_up") && (walls & ~world.up_mask == 0):
			PlayerData.map_pos.y -= 1
			moved()
		elif Input.is_action_pressed("ui_left") && (walls & ~world.left_mask == 0):
			PlayerData.map_pos.x -= 1
			moved()
		elif Input.is_action_pressed("ui_right") && (walls & ~world.right_mask == 0):
			PlayerData.map_pos.x += 1
			moved()



func moved():
	can_move = false
	move_timer.start(move_speed)
	

func _on_timeout():
	can_move = true
	
