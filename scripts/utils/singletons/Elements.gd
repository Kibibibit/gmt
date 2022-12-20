extends Node


const element_bit_offset = 3

const normal: int = 0b000
const weak: int = 0b001
const strong: int = 0b010
const nullify: int = 0b011
const reflect: int = 0b100

const affinity_mask = 0b111

const physical = 0
const gun = 1
const fire = 2
const lightning = 3
const ice = 4
const force = 5
const almigthy = 6

func add_affinity(data: int, element: int, affinity:int)->int:
	var offset:int = element*element_bit_offset
	var subtract = ((data >> offset) & affinity_mask) << offset
	var cleared_data = data-subtract
	var add: int = affinity << offset
	return cleared_data+add

func get_affinity(data: int, element: int)->int:
	var offset:int = element*element_bit_offset
	return (data >> offset) & affinity_mask
