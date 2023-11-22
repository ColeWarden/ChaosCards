class_name CardManager
extends Node2D

@onready var soundEffectManager: SoundEffectManager = $SoundEffectManager

const cardPackedScene: PackedScene = preload("res://card.tscn")
var cells: Dictionary = {}
var grid_size: Vector2i
var player_grid_size: Vector2i
var cards: Array[Card] = []


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		_reset()
	

func _reset()-> void:
	set_grid_size(player_grid_size)


func set_grid_size(_player_grid_size: Vector2i)-> void:
	for card in cards:
		card.free()
	cards.clear()
	cells.clear()
	player_grid_size = _player_grid_size
	grid_size = Vector2i(player_grid_size.x, (player_grid_size.y * 2) + 1)
	for x in grid_size.x:
		cells[x] = {}
		for y in grid_size.y:
			cells[x][y] = {"type": ""}
	
	randomize_middle()


func randomize_middle()-> void:
	var middle_row: int = grid_size.y / 2
	var x: int = 0
	var num_of_walls: int = 3
	var incre: int = grid_size.x / num_of_walls
	for i in num_of_walls:
		create_card(Vector2i(x, middle_row), "gravel_wall", Vector2i(randi() % incre + 1,1))
		x += incre


func create_card(pos: Vector2i, card_type: String, card_size: Vector2i)-> Card:
	if !is_cell_free_rect(pos, card_size):
		return null
	if is_out_of_bounds_rect(pos, card_size):
		return null
	
	
#	if is_in_enemy_grid_rect(pos, card_size):
#		return null
	var inst: Card = cardPackedScene.instantiate()
	add_child(inst)
	inst.global_position = Vector2(pos.x, pos.y) * GLOBAL.CELL_SIZE_VEC
	inst.set_type(card_type)
	inst.set_card_size(card_size)
	soundEffectManager.play_card_sfx(card_type)
	var data: Dictionary = {"type": card_type}
	set_cell_rect_data(pos, card_size, data)
	cards.append(inst)
	return inst


func is_out_of_bounds(pos: Vector2i)-> bool:
	return cells.get(pos.x, {}).get(pos.y, {}).is_empty()


func is_out_of_bounds_rect(pos: Vector2i, size: Vector2i)-> bool:
	for x in range(pos.x, pos.x + size.x):
		for y in range(pos.y, pos.y + size.y):
			if is_out_of_bounds(Vector2i(x,y)):
				return true
	return false


func set_cell_data(pos: Vector2i, data: Dictionary)-> void:
	cells[pos.x][pos.y] = data


func get_cell_data(pos: Vector2i)-> Dictionary:
	return cells.get(pos.x, {}).get(pos.y, {})


func set_cell_rect_data(pos: Vector2i, size: Vector2i, data: Dictionary)-> void:
	for x in range(pos.x, pos.x + size.x):
		for y in range(pos.y, pos.y + size.y):
			set_cell_data(Vector2i(x,y), data)


func is_cell_free_rect(pos: Vector2i, size: Vector2i)-> bool:
	for x in range(pos.x, pos.x + size.x):
		for y in range(pos.y, pos.y + size.y):
			if !is_cell_free(Vector2i(x,y)):
				return false
	return true


func is_cell_free(pos: Vector2i)-> bool:
	var type_value: String = get_cell_data(pos).get("type", "")
	return type_value == ""


func is_pos_in_grid(pos: Vector2)-> bool:
	return pos.x > 0 and pos.y > 0 and pos.x < grid_size.x * GLOBAL.CELL_SIZE and pos.y < grid_size.y * GLOBAL.CELL_SIZE
