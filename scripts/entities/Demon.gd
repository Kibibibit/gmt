class_name Demon
extends Object

var demon_id: int = 0
var name: String = "UNAMED"
var max_hp: int = 10
var hp: int
var max_mp: int = 10
var mp: int
var level: int = 1
var speed: int = 1
var strength: int = 1
var magic: int = 1
var hp_growth: float
var mp_growth: float
var speed_growth: float
var strength_growth: float
var magic_growth: float

func _init(_demon_id: int):
	demon_id = _demon_id
	
	var data = DemonData.get_demon(demon_id)
	var start_level = data.start_level
	hp_growth = data.hp_growth
	mp_growth = data.mp_growth
	speed_growth = data.speed_growth
	magic_growth = data.magic_growth
	strength_growth = data.strength_growth
	## Can't have the player level up too early or it will break things
	while(level != start_level && demon_id != DemonData.player_id):
		self.level_up()
	hp = max_hp
	mp = max_mp
	
func random_level_stat(chance: float) -> int:
	if (randf() < chance):
		if (randf() < chance):
			return 2
		return 1
	return 0
	
func level_up():
	if (demon_id != DemonData.player_id):
		max_hp += random_level_stat(hp_growth)
		max_mp += random_level_stat(mp_growth)
		strength += random_level_stat(strength_growth)
		magic += random_level_stat(magic_growth)
		speed += random_level_stat(speed_growth)
	
	hp = max_hp
	mp = max_mp
