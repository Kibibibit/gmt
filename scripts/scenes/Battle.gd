class_name Battle
extends Node2D

const level_diff = 3
const max_demon_count = 4

@onready
var player_sprite: Sprite2D = $PlayerSprite

@onready
var ground_player_sprite: Sprite2D = $GroundSpritePlayer

@onready
var demons: Array[Demon] = []


@onready
var battle_dialog: BattleDialog = BattleDialog.new()

func _ready():
	
	player_sprite.position.y = ground_player_sprite.position.y - player_sprite.texture.get_height()
	player_sprite.position.x = ground_player_sprite.position.x - (player_sprite.texture.get_width()*0.5)
	Game.display_dialog(battle_dialog)
	
	spawn_demons()
	
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
	
	appeared_string = "%s appeared!" % appeared_string
	battle_dialog.set_text(appeared_string)

func spawn_demons():
	for i in range(0, randi_range(1,max_demon_count)):
		var demon = null
		while (demon == null):
			demon = get_random_demon()
		demons.append(demon)

func get_random_demon():
	var id = randi_range(DemonData.player_id+1, DemonData.data.size())
	
	var demon: Demon = Demon.new(id)
	if (demon == null):
		return null
	if (demon.level > PlayerData.entity.level):
		if (abs(demon.level - PlayerData.entity.level) > level_diff):
			return null
	
	return demon
