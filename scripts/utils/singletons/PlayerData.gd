extends Node


var map_pos: Vector2i = Vector2i(0,0)

@onready
var entity: Demon = Demon.new(DemonData.player_id)


func _exit_tree():
	entity.free()
