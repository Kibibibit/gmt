extends Node

## The name of the root node
const root_node_name: String = "Root"

var world_generated: bool = false
var world_data: Grid

var ui_stack: Array[int] = []

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

func display_dialog(dialog: Dialog) -> int:
	root().ui.add_child(dialog)
	return await dialog.dialog_closed

func handle_input():
	get_tree().root.set_input_as_handled()
