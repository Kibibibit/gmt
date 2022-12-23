class_name Attack
extends Object

const strength = 0b0
const magic = 0b1

const use_mp = 0b0
const use_hp = 0b1

const damage_light = 2
const damage_medium = 10
const damage_heavy = 20

const mult_weak = 2.0
const mult_strong = 0.5
const mult_null = 0.0
const mult_normal = 1.0
const mult_reflect = -0.8

var resource: int
var attack_stat: int
var base_damage: int
var resource_cost: int
var stat_multiplier: float
var element: int

func _init(a_resource:int, a_attack_stat: int, a_base_damage: int, a_resource_cost: int, a_stat_multiplier: float, a_element: int):
	resource = a_resource
	attack_stat = a_attack_stat
	base_damage = a_base_damage
	resource_cost = a_resource_cost
	stat_multiplier = a_stat_multiplier
	element = a_element

func calculate_damage(attacker: Demon, defender: Demon) -> int:
	var base_stat = attacker.strength
	if (attack_stat == magic):
		base_stat = attacker.magic
	
	var dmg = base_damage + (base_stat * stat_multiplier)
	
	var affinity = Elements.get_affinity(defender.affinities, element)
	var affinity_mult = mult_normal
	match affinity:
		Elements.weak:
			affinity_mult = mult_weak
		Elements.strong:
			affinity_mult = mult_strong
		Elements.nullify:
			affinity_mult = mult_null
		Elements.reflect:
			affinity_mult = mult_reflect
	
	return dmg * affinity_mult
