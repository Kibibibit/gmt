extends Node

## The name of the root node
const root_node_name: String = "Root"

## Get the size of the viewport
func size() -> Vector2:
	return get_tree().root.get_visible_rect().size

## Get the width of the viewport
func width() -> int:
	return floor(size().x)

## Get the height of the viewport
func height() -> int:
	return floor(size().y)

## Get the root node of the game
func root() -> Root:
	return get_tree().root.get_node(root_node_name) as Root
