extends Node


const player_id = 1

@onready
var data: Dictionary = {
	player_id: DemonStats.new(player_id, 1, 0.0, 0.0, 0.0, 0.0, 0.0)
}

func get_demon(id: int):
	if (data.has(id)):
		return data[id]
	else:
		return null

class DemonStats:
	var id: int
	var start_level: int
	var hp_growth: float
	var mp_growth: float
	var strength_growth: float
	var magic_growth: float
	var speed_growth: float
	
	func _init(_id: int, _start_level: int, _hp_growth: float, _mp_growth: float, _strength_growth: float, _magic_growth: float, _speed_growth:float):
		id = _id
		start_level = _start_level
		hp_growth = _hp_growth
		mp_growth = _mp_growth
		strength_growth = _strength_growth
		magic_growth = _magic_growth
		speed_growth = _speed_growth
