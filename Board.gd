@tool
class_name Board
extends Node2D


@export var hand_card_curve: Curve = Curve.new()

@onready var enemyBoard: Sprite2D = $EnemyBoard
@onready var playerBoard: Sprite2D = $PlayerBoard
@onready var middleBoard: Sprite2D = $MiddleBoard
@onready var camera: Camera2D = $Camera2D
@onready var handHolder: HandHolder = $HandHolder
@onready var cardManager: CardManager = $CardManager
var flip_tween: Tween


func set_board_cell_size(board_cell_size: Vector2i) -> void:
	var cell_size: int = GLOBAL.CELL_SIZE
	var board_pixel_size: Vector2i = board_cell_size * cell_size
	enemyBoard.region_rect = Rect2i(0,0, board_pixel_size.x, board_pixel_size.y)
	middleBoard.region_rect = Rect2i(0,0, board_pixel_size.x, cell_size)
	playerBoard.region_rect = Rect2i(0,0, board_pixel_size.x, board_pixel_size.y)
	
	enemyBoard.global_position = Vector2i(0,0)
	middleBoard.global_position = Vector2(0, board_pixel_size.y)
	playerBoard.global_position = Vector2(0, board_pixel_size.y + cell_size)
	
	#camera.global_position = playerBoard.global_position + playerBoard.region_rect.size / 2
	cardManager.set_grid_size(board_cell_size)


func set_valid_card_placement(player_board: bool = true, enemy_board: bool = false):
	var invalid_color: Color = Color(1.19999992847443, 0.79999995231628, 0.79999995231628)
	var valid_color: Color = Color(0.79999995231628, 2.5, 0.5)
	if player_board:
		playerBoard.modulate = valid_color
	else:
		playerBoard.modulate = invalid_color
	
	if enemy_board:
		enemyBoard.modulate = valid_color
	else:
		enemyBoard.modulate = invalid_color


func reset_valid_card_placement()-> void:
	playerBoard.modulate = Color.WHITE
	enemyBoard.modulate = Color.WHITE

