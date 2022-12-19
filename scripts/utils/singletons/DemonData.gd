extends Node


const player_id = 1

@onready
var data: Dictionary = {
	player_id: DemonStats.new(
		"Player", #Name
		1, #Starting Level
		0.0, #Hp Growth
		0.0, #Mp Growth
		0.0, #Str Growth
		0.0, #Mag Growth
		0.0  #Spd Growth
	),
	2: DemonStats.new(
		"Jack Frost", #Name
		1, #Starting Level
		0.4, #Hp Growth
		1.0, #Mp Growth
		0.3, #Str Growth
		0.8, #Mag Growth
		0.3  #Spd Growth
	),
}

func get_demon(id: int):
	if (data.has(id)):
		var d = data[id]
		d.id = id
		return d
	else:
		return null

class DemonStats:
	var demon_name: String
	var id: int
	var start_level: int
	var hp_growth: float
	var mp_growth: float
	var strength_growth: float
	var magic_growth: float
	var speed_growth: float
	
	func _init(_demon_name: String,_start_level: int, _hp_growth: float, _mp_growth: float, _strength_growth: float, _magic_growth: float, _speed_growth:float):
		demon_name = _demon_name
		start_level = _start_level
		hp_growth = _hp_growth
		mp_growth = _mp_growth
		strength_growth = _strength_growth
		magic_growth = _magic_growth
		speed_growth = _speed_growth
