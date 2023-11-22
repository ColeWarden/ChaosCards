extends Node

enum PLAYER {
	P1,
	P2,
	limit
}

const CELL_SIZE: int = 16
const CELL_SIZE_VEC: Vector2 = Vector2(16,16)
@onready var SCREEN_SIZE: Vector2 = Vector2(ProjectSettings.get("display/window/size/viewport_width"), ProjectSettings.get("display/window/size/viewport_height"))
@onready var CARD: Dictionary = {
	"bag_of_gold": {
		"min": Vector2(2,2),
		"max": Vector2(3,3),
		"tex": "res://spr/bag_of_gold.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/bag_of_gold.wav",
	},
	"bag_of_null": {
		"min": Vector2(2,2),
		"max": Vector2(3,3),
		"tex": "res://spr/bag_of_null.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/bag_of_null.wav",
	},
	"ballista": {
		"min": Vector2(2,2),
		"max": Vector2(3,3),
		"tex": "res://spr/ballista.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/ballista.wav",
	},
	"bee": {
		"min": Vector2(3,3),
		"max": Vector2(3,3),
		"tex": "res://spr/bee.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/bee.wav",
	},
	"big_sign": {
		"min": Vector2(3,2),
		"max": Vector2(3,3),
		"tex": "res://spr/big_sign.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/big_sign.wav",
	},
	"bomb": {
		"min": Vector2(1,1),
		"max": Vector2(3,3),
		"tex": "res://spr/bomb.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/bomb.wav",
	},
	"cactus": {
		"min": Vector2(1,2),
		"max": Vector2(3,3),
		"tex": "res://spr/cactus.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/cactus.wav",
	},
	"double_sign": {
		"min": Vector2(1,3),
		"max": Vector2(3,3),
		"tex": "res://spr/double_sign.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/double_sign.wav",
	},
	"duck": {
		"min": Vector2(2,2),
		"max": Vector2(3,3),
		"tex": "res://spr/duck.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/duck.wav",
	},
	"gear": {
		"min": Vector2(3,3),
		"max": Vector2(4,4),
		"tex": "res://spr/gear.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/train.wav",
	},
	"null": {
		"min": Vector2(1,1),
		"max": Vector2(1,1),
		"tex": "res://spr/null.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/null.wav",
	},
	"rock": {
		"min": Vector2(3,2),
		"max": Vector2(3,3),
		"tex": "res://spr/rock.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/rock.wav",
	},
	"sign": {
		"min": Vector2(1,1),
		"max": Vector2(2,2),
		"tex": "res://spr/sign.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/sign.wav",
	},
	"stone_wall": {
		"min": Vector2(1,1),
		"max": Vector2(5,1),
		"tex": "res://spr/stone_wall.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/stone_wall.wav",
	},
	"tree": {
		"min": Vector2(2,2),
		"max": Vector2(3,3),
		"tex": "res://spr/tree.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/tree.wav",
	},
	"mystery_box": {
		"min": Vector2(2,2),
		"max": Vector2(8,4),
		"tex": "res://spr/mystery_box.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/mystery_box.wav",
	},
	"gravel_wall": {
		"min": Vector2(1,1),
		"max": Vector2(5,0),
		"tex": "res://spr/gravel_wall.png",
		"space_cost": 2,
		"place_enemy": false,
		"place_player": true,
		"snd": "res://snd/gravel_wall.wav",
	},
}


var board: Board = null
var environment: Sprite2D = null
var handHolder: HandHolder = null
var camera: Camera2D = null


var players_hand: Dictionary = {
}
var current_player: int = PLAYER.P1
var flip_board: bool = false

func _ready() -> void:
	var p1_hand: Array[String] = []
	var p2_hand: Array[String] = []
	players_hand[PLAYER.P1] = p1_hand
	players_hand[PLAYER.P2] = p2_hand

func next_player()-> int:
	current_player += 1
	current_player %= PLAYER.limit
	return current_player


func set_player(player_id: int)-> void:
	current_player = player_id
	var player_hand: Array[String] = players_hand[current_player]
	handHolder.set_hand(player_hand)


func get_player()-> int:
	return current_player


func get_random_card_type()-> String:
	return CARD.keys()[randi() % CARD.keys().size()]


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("screenshot"):
		var img = get_viewport().get_texture().get_image()
		var time_dict: Dictionary = Time.get_datetime_dict_from_system()
		print(time_dict)
		var file_name: String = "user://screenshots/" + str(time_dict["month"]) + "-" + \
			str(time_dict["day"]) + "-" + str(time_dict["year"]) + "-" + str(time_dict["hour"]) + "-" + \
			str(time_dict["minute"]) + "-" + str(time_dict["second"])
		DirAccess.make_dir_recursive_absolute("user://screenshots")
		img.save_png(file_name + ".png")
