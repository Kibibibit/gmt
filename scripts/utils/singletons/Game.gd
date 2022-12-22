extends Node

## The name of the root node
const root_node_name: String = "Root"
const enemy_chance = 0.02
var world_generated: bool = false
var world_data: Grid = Grid.new()

var steps_since_last_battle = 0


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

func set_scene(world: String):
	await root().set_scene(world)

func handle_input():
	get_tree().root.set_input_as_handled()

func screen_wipe() -> ScreenEffects:
	return root().screen_effects.screen_wipe()

func _exit_tree():
	world_data.free()
