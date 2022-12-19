class_name Root
extends Node2D

func _init():
	super()
	# Force this node to have the right name just in case
	self.name = Game.root_node_name



func _ready():
	randomize()
	var world = load("res://scenes/world.tscn").instantiate()
	add_child(world)
	world.generate_world()


