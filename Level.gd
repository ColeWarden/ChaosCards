extends Node2D

@export var board_cell_size: Vector2i = Vector2(16,4)

@onready var board: Board = $Board
@onready var environment: Sprite2D = $Environment

var turn: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GLOBAL.board = board
	GLOBAL.environment = environment
	GLOBAL.handHolder = $Board/Camera2D/HandHolder
	GLOBAL.camera = $Board/Camera2D
	board.set_board_cell_size(board_cell_size)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		next_turn()


func next_turn()-> void:
	var old_player: int = GLOBAL.current_player
	GLOBAL.players_hand[old_player] = GLOBAL.handHolder.get_cards()
	print(GLOBAL.players_hand)
	turn += 1
	var next_player: int = GLOBAL.next_player()
	GLOBAL.flip_board = !GLOBAL.flip_board
	var cam = GLOBAL.camera
	if GLOBAL.flip_board:
		cam.set_target_position(cam.get_enemy_board_center_pos())
	else:
		cam.set_target_position(cam.get_player_board_center_pos())
	GLOBAL.handHolder.clear_cards()
	GLOBAL.handHolder.set_cards(GLOBAL.players_hand[next_player])

