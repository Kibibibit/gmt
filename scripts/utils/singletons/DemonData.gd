extends Node

const key_id: String = "id"
const key_name: String = "name"
const key_level: String = "level"
const key_hp: String = "hp"
const key_mp: String = "mp"
const key_str: String = "str"
const key_mag: String = "mag"
const key_spd: String = "spd"
const key_hp_g: String = "hp_growth"
const key_mp_g: String = "mp_growth"
const key_str_g: String = "str_growth"
const key_mag_g: String = "mag_growth"
const key_spd_g: String = "spd_growth"

const key_physical: String = "physical"
const key_gun: String = "gun"
const key_fire: String = "fire"
const key_lightning: String = "lightning"
const key_ice: String = "ice"
const key_force: String = "force"
const key_almighty: String = "almighty"

const value_normal: String = "NONE"
const value_weak: String =  "WEAK"
const value_strong: String = "STR"
const value_nullify: String = "NULL"
const value_reflect: String = "REFLECT"

const player_id = 1

const affinity_key_to_id: Dictionary = {
	value_normal: Elements.normal,
	value_weak: Elements.weak,
	value_strong: Elements.strong,
	value_nullify: Elements.nullify,
	value_reflect: Elements.reflect
}

const element_key_to_id: Dictionary = {
	key_physical: Elements.physical,
	key_gun: Elements.gun,
	key_fire: Elements.fire,
	key_lightning: Elements.lightning,
	key_ice: Elements.ice,
	key_force: Elements.force,
	key_almighty: Elements.almigthy
}



@onready
var data: Dictionary = {}

func _ready():
	var raw_data: Dictionary = CSVLoader.load_file("res://data/demon_data.csv")
	
	var demon_count = raw_data[key_id].size()
	
	for i in range(0, demon_count):
		var d_id: int = int(raw_data[key_id][i])
		var d_name: String = raw_data[key_name][i]
		var d_level: int = int(raw_data[key_level][i])
		var d_hp: int = int(raw_data[key_hp][i])
		var d_mp: int = int(raw_data[key_mp][i])
		var d_str: int = int(raw_data[key_str][i])
		var d_mag: int = int(raw_data[key_mag][i])
		var d_spd: int = int(raw_data[key_spd][i])
		var d_hp_g: float = float(raw_data[key_hp_g][i])
		var d_mp_g: float = float(raw_data[key_mp_g][i])
		var d_str_g: float = float(raw_data[key_str_g][i])
		var d_mag_g: float = float(raw_data[key_mag_g][i])
		var d_spd_g: float = float(raw_data[key_spd_g][i])
		
		var d_affinity: int = make_affinity(raw_data, i)
		
		data[d_id] = DemonStats.new(
			d_name,
			d_level,
			d_hp,
			d_mp,
			d_str,
			d_mag,
			d_spd,
			d_hp_g,
			d_mp_g,
			d_str_g,
			d_mag_g,
			d_spd_g,
			d_affinity
		)
		print("Loaded Demon (",d_id,"): ",d_name)
func get_demon(id: int):
	if (data.has(id)):
		var d = data[id]
		d.id = id
		return d
	else:
		return null

func make_affinity(raw_data: Dictionary, index: int) -> int:
	var a: int = 0
	
	for key in element_key_to_id.keys():
		var value_string = raw_data[key][index]
		var value: int = affinity_key_to_id[value_string]
		var element: int = element_key_to_id[key]
		a = Elements.add_affinity(a, element, value)
	
	return a


class DemonStats:
	var demon_name: String
	var id: int
	var start_level: int
	var hp: int
	var mp: int
	var hp_growth: float
	var mp_growth: float
	var strength: int
	var magic: int
	var speed: int
	var strength_growth: float
	var magic_growth: float
	var speed_growth: float
	var affinities: int
	
	func _init(
		_demon_name: String,
		_start_level: int,
		_hp: int,
		_mp: int,
		_str: int,
		_mag: int,
		_spd: int,
		_hp_growth: float,
		_mp_growth: float,
		_strength_growth: float,
		_magic_growth: float,
		_speed_growth:float,
		_affinities:int
		):
		demon_name = _demon_name
		start_level = _start_level
		hp = _hp
		mp = _mp
		strength = _str
		magic = _mag
		speed = _spd
		hp_growth = _hp_growth
		mp_growth = _mp_growth
		strength_growth = _strength_growth
		magic_growth = _magic_growth
		speed_growth = _speed_growth
		affinities = _affinities
