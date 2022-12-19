class_name Grid
extends Object

const bit_offset: int = 32
const invalid: Vector2 = Vector2(-1,-1)
const max_dimension: int = (2**(bit_offset))-1

var _dictionary: Dictionary = {}

func clear() -> void:
	_dictionary.clear()

func duplicate(deep: bool = false) -> Grid:
	var new_dict = _dictionary.duplicate(deep)
	var new_grid = Grid.new()
	new_grid._dictionary = new_dict
	return new_grid

func erase(x:int, y:int) -> bool:
	if (valid_pos(x,y)):
		return _dictionary.erase(encode_key(x,y))
	return false

func erase_v(pos: Vector2) -> bool:
	return erase(floor(pos.x),floor(pos.y))
	
func find_key(value) -> Vector2:
	var key = _dictionary.find_key(value)
	if (key == null):
		return invalid
	return decode_key(key)

func at(x:int, y:int):
	var key: int = encode_key(x,y)
	if (_dictionary.has(key)):
		return _dictionary[key]
	else:
		return null

func at_v(pos: Vector2):
	return at(floor(pos.x),floor(pos.y))

func has(x: int, y:int) -> bool:
	if (valid_pos(x,y)):
		return at(x,y) != null
	return false

func has_v(pos: Vector2) -> bool:
	return has(floor(pos.x),floor(pos.y))

func valid_pos(x:int, y:int) -> bool:
	return x >= 0 && x <= max_dimension && y >= 0 && y <= max_dimension
	
func add(x: int, y:int, value, override: bool = true) -> bool:
	if (!valid_pos(x,y)):
		return false
	if (has(x,y) && !override):
		return false
	_dictionary[encode_key(x,y)] = value
	return true
	
func add_v(pos: Vector2, value, override: bool = true) -> bool:
	return add(floor(pos.x),floor(pos.y),value,override)

func encode_key(x:int, y:int) -> int:
	return (x << bit_offset) + y

func decode_key(key: int) -> Vector2:
	var x: int = key >> bit_offset
	var y: int = key & max_dimension
	return Vector2(x,y)

func is_empty() -> bool:
	return _dictionary.is_empty()

func has_all(key_array: Array[Vector2]) -> bool:
	for key in key_array:
		if (!_dictionary.has(encode_key(floor(key.x), floor(key.y)))):
			return false
	return true
	
func keys() -> Array[Vector2]:
	var out: Array[Vector2] = []
	for key in _dictionary.keys():
		out.append(decode_key(key))
	return out

func values() -> Array:
	return _dictionary.values()

func grid_hash() -> int:
	return _dictionary.hash()

func merge(grid: Grid, override: bool = false) -> void:
	_dictionary.merge(grid._dictionary, override)

func equals(grid: Grid) -> bool:
	return grid._dictionary == _dictionary
