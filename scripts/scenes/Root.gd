class_name Root
extends Node2D

@onready
var ui: Node2D = $UI

func _init():
	super()
	# Force this node to have the right name just in case
	self.name = Game.root_node_name



func _ready():
	randomize()
	var world = load("res://scenes/world.tscn").instantiate()
	add_child(world)
