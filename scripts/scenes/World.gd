class_name World
extends Node2D

## List of directions used to get offsets for geenration
const offs: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

## Removes left wall from a node
const left_mask: int = 0b0111
## Removes right wall from a node
const right_mask: int = 0b1011
## Removes up wall from a node
const up_mask: int = 0b1101
## Removes down wal from a node
const down_mask: int = 0b1110

## (boss_size*2)+1 gives the width/height of the boss room
var boss_size: int = 2

@onready
var tiles: TileMap = $TileMap

@onready
var tile_size: int = floor(tiles.tile_set.tile_size.x)

## Width of the world in tiles
@onready
var world_width:int = floor((Game.width() as float) / tile_size)

## Height of the world in tiles
@onready 
var world_height:int = floor((Game.height() as float) / tile_size)

## The start point the player is dropped into
@onready
var start: Vector2 = Vector2(0,0)

## The grid storing the world gen data
@onready
var grid: Grid = Grid.new()

## Small helper class storing the positions, walls and visited status of each point on the map
class GridNode:
	var walls: int = 0b1111
	var pos: Vector2 = Grid.invalid
	var visited = false
	func _init(x: int, y: int):
		pos = Vector2(x,y)

## Generates the world using a randomised depth first search
func generate_world():
	tiles.clear()
	grid.clear()
	## Start by creating a blank grid
	for x in range(0,world_width):
		for y in range(0, world_height):
			grid.add(x,y,GridNode.new(x,y))
	
	## Find the start and add to the visited stack
	var visited: Array[GridNode] = [grid.at_v(start)]
	grid.at_v(start).visited = true
	
	## Get the center of the world
	var cx = floor((world_width as float) / 2)
	var cy = floor((world_height as float) / 2)
	
	## Create  the boss room
	for x in range(-1*boss_size, boss_size+1):
		for y in range(-1*boss_size, boss_size+1):
			var node = GridNode.new(cx+x,cy+y)
			if (x != -1*boss_size):
				node.walls = node.walls & left_mask
			if (x != boss_size):
				node.walls = node.walls & right_mask
			if (y != -1*boss_size):
				node.walls = node.walls & up_mask
			if (y != boss_size):
				node.walls = node.walls & down_mask
			node.visited = true
			grid.add(cx+x,cy+y,node)
	## Create the door of the boss room
	var doors = [Vector2i(cx-boss_size,cy), Vector2i(cx+boss_size,cy), Vector2i(cx,cy-boss_size),Vector2i(cx,cy+boss_size)]
	var door = Utils.random_element(doors)
	var node = grid.at(door.x,door.y)
	node.visited = false
	node.walls = 0
	grid.add(door.x,door.y,node)
	
	## While the visited stack is not empty, generate the map
	while visited.size() > 0:
		visited = generate_step(visited)
	
	for x in range(0, world_width):
		for y in range(0, world_height):
			var ax = floor((grid.at(x,y).walls) % 4)
			var ay = floor((grid.at(x,y).walls as float) / 4)
			tiles.set_cell(0,Vector2i(x,y),0,Vector2i(ax,ay))
	
## One iteration of the world generation
func generate_step(visited: Array[GridNode]) -> Array[GridNode]:
	## If visited is empty, we have finished generating so stop
	if (visited.size() == 0):
		return []
	## Get the last node in the stack
	var node: GridNode = visited[visited.size()-1]
	var neighbours: Array[GridNode] = []
	## Find unvisited neighbours of that node
	for off in offs:
		var x = node.pos.x + off.x
		var y = node.pos.y + off.y
		var neighbour = grid.at(floor(x),floor(y))
		if (neighbour != null):
			if (!neighbour.visited):
				neighbours.append(neighbour)
	## if there are no unvisited neighbours, go back one on the stack
	if neighbours.size() < 1:
		visited.pop_back()
		return visited
	else:
		## Selected a random neighbour and set the walls accordingly
		var next: GridNode = Utils.random_element(neighbours)
		next.visited = true
		var x_diff = node.pos.x-next.pos.x
		var y_diff = node.pos.y-next.pos.y
		if x_diff == -1:
			next.walls = next.walls & left_mask
			node.walls = node.walls & right_mask
		elif x_diff == 1:
			next.walls = next.walls & right_mask
			node.walls = node.walls & left_mask
		elif y_diff == -1:
			next.walls = next.walls & up_mask
			node.walls = node.walls & down_mask
		elif y_diff == 1:
			next.walls = next.walls & down_mask
			node.walls = node.walls & up_mask
		## Append the neighbour to visited, then move on
		visited.append(next)
		grid.add_v(next.pos, next)
		grid.add_v(node.pos, node)
		return visited
	
