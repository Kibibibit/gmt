class_name Battle
extends Node2D

const level_diff = 3
const max_demon_count = 4

const state_battle_begin = 0
const state_player_turn = 1
const state_enemy_turn = 2
const state_running = 3
const state_running_failed = 4

var battle_state = state_battle_begin

var awaiting: bool = false

const player_option_attack = 1
const player_option_skill = 2
const player_option_run = 3

@onready
var player_sprite: Sprite2D = $PlayerSprite

@onready
var ground_player_sprite: Sprite2D = $GroundSpritePlayer

@onready
var ground_demon_sprite: Sprite2D = $GroundSpriteEnemy

@onready
var demons: Array[Demon] = []

@onready
var demon_sprites: Dictionary = {}

@onready
var battle_dialog: BattleDialog = BattleDialog.new()

var max_enemy_press_turns: int = 4
var max_player_press_turns: int = 2

var enemy_press_turns: Array[bool] = []
var player_press_turns: Array[bool] = []

var timer: Timer = Timer.new()

func _ready():
	timer.connect("timeout", Callable(self,"_on_timeout"))
	player_sprite.position.y = ground_player_sprite.position.y - player_sprite.texture.get_height()
	player_sprite.position.x = ground_player_sprite.position.x - (player_sprite.texture.get_width()*0.5)
	Game.display_dialog(battle_dialog)
	
	spawn_demons()
	var i = 0
	for demon in demons:
		var demon_sprite = Sprite2D.new()
		demon_sprite.centered = false
		demon_sprite.texture = load("res://sprites/player.png")
		demon_sprites[demon.get_instance_id()] = demon_sprite
		add_child(demon_sprite)
		demon_sprite.position.x = ground_demon_sprite.position.x - (((demons.size()-1)*32)*0.5) + (i*32) - (0.5*demon_sprite.texture.get_width())
		demon_sprite.position.y = ground_demon_sprite.position.y - demon_sprite.texture.get_height()
		i += 1
	
	var names = []
	for demon in demons:
		if names.find(demon.name) == -1:
			names.append(demon.name)
	
	var first = true
	var appeared_string = ""
	for n in names:
		if (first):
			appeared_string = "%s" % n
		else:
			appeared_string = "%s, %s" % [appeared_string, n]
		
		first = false
	
	if (demons.size() == 1):
		appeared_string = "An enemy! %s appeared!" % appeared_string
	else:
		appeared_string = "%d enemies! %s appeared!" % [demons.size(), appeared_string]
	battle_dialog.set_text(appeared_string)
	add_child(timer)
	timer.start(2)

func _on_timeout():
	match battle_state:
		state_battle_begin:
			start_battle()
			return
		state_running:
			Game.set_scene(Root.scene_world)
			return
		state_running_failed:
			set_turn(state_enemy_turn)
			return
		_:
			return

func start_battle():
	set_turn(state_player_turn)

func set_turn(t: int):
	if (t == state_player_turn):
		battle_dialog.set_text("Your turn! What will you do?")
		player_press_turns = refill_press_turns(player_press_turns, max_player_press_turns)
	else:
		battle_dialog.set_text("Enemy turn!")
		enemy_press_turns = refill_press_turns(enemy_press_turns, max_enemy_press_turns)
	
	battle_state = t
func _unhandled_input(event):
	if (awaiting):
		return
	
	match battle_state:
		state_battle_begin,state_running, state_running_failed:
			cancel_timer(event)
		_:
			return

func cancel_timer(event: InputEvent):
	if (!timer.is_stopped()):
		if (event.is_action_released("menu_accept")):
			Game.handle_input()
			timer.stop()
			_on_timeout()
		

func _process(_delta):
	
	if (awaiting):
		return
	match battle_state:
		state_player_turn:
			await _process_player_turn(_delta)

func _process_player_turn(_delta: float):
	
	awaiting = true
	var option_dialog: SelectDialog = SelectDialog.new("What will you do?",["Attack","Skill","Run"])
	var option = await Game.display_dialog(option_dialog)
	match option:
		player_option_attack:
			pass
		player_option_skill:
			pass
		player_option_run:
			player_run()

	awaiting = false

func get_run_chance():
	return 1.0

func player_run():
	if (randf() <= get_run_chance()):
		battle_dialog.set_text("You ran away!")
		battle_state = state_running
	else:
		battle_dialog.set_text("You could not escape!")
		battle_state = state_running_failed
	timer.start(2)

func refill_press_turns(turns: Array[bool], max_turns: int) -> Array[bool]:
	turns = []
	for i in range(0,max_turns):
		turns.append(true)
	return turns

func spawn_demons():
	for i in range(0, randi_range(1,max_demon_count)):
		var demon = null
		while (demon == null):
			demon = get_random_demon()
		demons.append(demon)
	max_enemy_press_turns = demons.size()

func get_random_demon():
	var id = randi_range(DemonData.player_id+1, DemonData.data.size())
	
	var demon: Demon = Demon.new(id)
	if (demon == null):
		return null
	if (demon.level > PlayerData.entity.level):
		if (abs(demon.level - PlayerData.entity.level) > level_diff):
			return null
	
	return demon

func _exit_tree():
	for demon in demons:
		demon.free()
	battle_dialog.pop_dialog()
