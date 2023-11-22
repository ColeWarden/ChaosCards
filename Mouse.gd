class_name Mouse
extends AnimatedSprite2D

signal place_card_from_hand(card)

@onready var cardManager: CardManager = get_parent()
@onready var selected_handCard: HandCard = null

@onready var card: Card = $Card
@onready var selectTexture = $Card/Select

var card_origin_pos: Vector2 = Vector2i(-1,-1)
var hovering_over_hand: bool = false

func _process(delta: float) -> void:
	var pos_in_screen: Vector2 = get_global_mouse_position()
	if selected_handCard != null:
		var in_board: bool = _is_pos_within_board(pos_in_screen)
		if !in_board or hovering_over_hand:
			modulate = Color.RED
		else:
			modulate = Color.WHITE
		if in_board and !hovering_over_hand:
			
			pos_in_screen = local_to_map(pos_in_screen)
			var card_end_pos: Vector2 = pos_in_screen
			if Input.is_action_just_pressed("mouse_left"):
				#card_origin_pos += Vector2(GLOBAL.CELL_SIZE,GLOBAL.CELL_SIZE) / 2.0
				
				card_origin_pos = pos_in_screen #- Vector2(GLOBAL.CELL_SIZE,GLOBAL.CELL_SIZE) / 2.0
				card_origin_pos /= GLOBAL.CELL_SIZE_VEC
				#print(card_origin_pos)
			elif Input.is_action_just_released("mouse_left"):
				var placed_card: Card = cardManager.create_card(card_origin_pos, selected_handCard.get_type(), card.get_card_size())
				if placed_card != null:
					place_card_from_hand.emit(selected_handCard)
					card.tween_kill()
					set_selected_handCard(null)
				card_origin_pos = Vector2(-1,-1)
			
			if card_origin_pos != Vector2(-1,-1):
				card_end_pos = pos_in_screen #- Vector2(GLOBAL.CELL_SIZE,GLOBAL.CELL_SIZE) / 2.0
				card_end_pos /= GLOBAL.CELL_SIZE_VEC
				var card_size: Vector2 = card_end_pos - card_origin_pos + Vector2(1,1)
				card.set_card_size(card_size)
				var clamped_card_size: Vector2i = card.get_card_size()
				selectTexture.size = Vector2(clamped_card_size.x, clamped_card_size.y) * GLOBAL.CELL_SIZE_VEC
				selectTexture.global_position = card_origin_pos * GLOBAL.CELL_SIZE_VEC
			else:
				card.global_position = pos_in_screen
				card.set_card_size(Vector2(-1,-1))
				var clamped_card_size: Vector2i = card.get_card_size()
				selectTexture.size = Vector2(clamped_card_size.x, clamped_card_size.y) * GLOBAL.CELL_SIZE_VEC
				selectTexture.global_position = pos_in_screen
		else:
			card.global_position = pos_in_screen
			selectTexture.global_position = pos_in_screen


func local_to_map(pos: Vector2)-> Vector2:
	var cell_size_vec: Vector2 = GLOBAL.CELL_SIZE_VEC
	pos -= cell_size_vec / 2.0
	pos = pos.snapped(cell_size_vec)
	#pos += cell_size_vec / 2.0
	return pos


func set_selected_handCard(handCard: HandCard)-> void:
	selectTexture.visible = handCard != null
	card.visible = handCard != null
	card.rotation_degrees = 0.0
	card.scale = Vector2(1,1)
	if handCard == null:
		GLOBAL.board.reset_valid_card_placement()
	else:
		var rot: float = 5.0
		var dur: float = 0.45
		card.tween_rotate_start(rot, dur)
		card.tween_scale_start(Vector2(0.95, 0.95), Vector2(1.1, 1.1), dur)
		var card_type: String = handCard.get_type()
		card.set_type(card_type)
		var card_size: Vector2i = card.get_card_size()
		selectTexture.size = Vector2(card_size.x, card_size.y) * GLOBAL.CELL_SIZE
		selectTexture.position = -GLOBAL.CELL_SIZE_VEC/ 2.0
		card.position = -GLOBAL.CELL_SIZE_VEC/ 2.0
		
		var card_data: Dictionary = GLOBAL.CARD[card_type]
		GLOBAL.board.set_valid_card_placement(card_data["place_player"], card_data["place_enemy"])
		
		
	selected_handCard = handCard


func _on_hand_holder_card_deselected() -> void:
	set_selected_handCard(null)


func _on_hand_holder_card_selected(card) -> void:
	set_selected_handCard(card)


func _is_pos_within_board(pos: Vector2)-> bool:
	return cardManager.is_pos_in_grid(pos)


func _on_hand_holder_selectable_card_hovered(card) -> void:
	hovering_over_hand = card != null
