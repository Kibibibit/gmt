class_name Root
extends Node2D

var current_scene: Node2D

const scene_world = "world"
const scene_battle = "battle"

@onready
var ui: Node2D = $UI

@onready
var screen_effects: ScreenEffects = $ScreenEffects



@onready
var scenes = {
	scene_world:load("res://scenes/world.tscn"),
	scene_battle: load("res://scenes/battle.tscn")
}


func _init():
	super()
	# Force this node to have the right name just in case
	self.name = Game.root_node_name
	
func set_scene(world: String):
	if (current_scene != null):
		await Game.screen_wipe().anim_half_done
		remove_child(current_scene)
		current_scene.queue_free()
	current_scene = scenes[world].instantiate()
	add_child(current_scene)
	

func _ready():
	randomize()
	await set_scene(scene_world)
