class_name HandHolder
extends Node2D

signal card_selected(card)
signal card_deselected()
signal selectable_card_hovered(card)

@export var curveRes: Curve = Curve.new()
const DISTANCE_TO_SELECTED: float = 32.0
const handCardPacked: PackedScene = preload("res://hand_card.tscn")
var hand: Array[HandCard] = []
var hovered_card: HandCard = null
var selectable_card: HandCard = null
var selected_card: HandCard = null

var echo: bool = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if selected_card != null:
			selected_card.tween_deselected()
			selected_card = null
			card_deselected.emit()
			
	
	if Input.is_key_pressed(KEY_0):
		if echo:
			return
		echo = true
		add_card(GLOBAL.CARD.keys()[randi() % GLOBAL.CARD.keys().size()])
	else:
		echo = false
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	_update_hovered_card(mouse_pos)
	
	if hovered_card != null:
		_update_selectable_card(hovered_card, mouse_pos)
	#print(selectable_card , "=", selected_card)
	_update_selected_card()


func _update_selectable_card(card: HandCard, mouse_pos: Vector2)-> void:
	if card.global_position.distance_to(mouse_pos) <= DISTANCE_TO_SELECTED:
		if card != selectable_card:
			#if selectable_card != null:
				#selectable_card.tween_deselected()
			selectable_card = card
			selectable_card_hovered.emit(card)
			#selectable_card.tween_selected()
	else:
		if selectable_card != null:
			#selectable_card.tween_deselected()
			selectable_card = null
			selectable_card_hovered.emit(null)


func _update_selected_card()-> void:
	if Input.is_action_just_pressed("mouse_left"):
		#_set_selected_card(selectable_card)
		if selectable_card == null:
			pass
#			if selected_card != null:
#				selected_card.tween_deselected()
#				selected_card = null
#				card_deselected.emit()
		else:
			if selected_card != null:
				if selected_card == selectable_card:
					selected_card.tween_deselected()
					selected_card.z_index = 0
					selected_card = null
					card_deselected.emit()
				else:
					selected_card.tween_deselected()
					selected_card.z_index = 0
					selected_card = selectable_card
					selected_card.z_index = 10
					selected_card.tween_selected()
					card_selected.emit(selected_card)
			else:
				selected_card = selectable_card
				selected_card.tween_selected()
				selected_card.z_index = 10
				card_selected.emit(selected_card)
#
#func _set_selected_card(card: HandCard)-> void:
#	if selected_card == card:
#		return
#
#	if selected_card != null:
#		selected_card.tween_deselected()
#		selected_card = card
#		if card == null:
#			card_deselected.emit()
#		else:
#			selected_card.tween_selected()
#			card_selected.emit(selected_card)
#	else:
#		selected_card = card
#		selected_card.tween_selected()
#		card_deselected.emit()


func _update_hovered_card(mouse_pos: Vector2)-> void:
	var lowest_dist: float = 1000000.0
	var closest_card: HandCard = null
	for card in hand:
		var mouse_to_card: float = card.global_position.distance_to(mouse_pos)
		if mouse_to_card < lowest_dist:
			lowest_dist = mouse_to_card
			closest_card = card
	
	if hovered_card != closest_card:
		if hovered_card != null:
			if selected_card != hovered_card:
				hovered_card.tween_collapse()
		hovered_card = closest_card
		if selected_card != hovered_card:
			hovered_card.tween_expand()


func add_card(type: String)-> int:
	var inst: HandCard = _create_handCard()
	inst.set_type(type)
	var x_incre: float = get_card_x_increment()
	inst.global_position.x = (x_incre * hand.size()) + global_position.x
	inst.global_position.y = global_position.y
	hand.append(inst)
	update_hand_tweens()
	return hand.size()


func set_cards(card_types: Array[String])-> void:
	var delay_offset: float = 0.15
	for i in card_types.size():
		var delay: float = float(i) * delay_offset
		var type: String = card_types[i]
		var tween: Tween = create_tween()
		tween.tween_callback(add_card.bind(type)).set_delay(delay)
	
	var delay: float = float(card_types.size()) * delay_offset
	var tween: Tween = create_tween()
	var random_card: String = GLOBAL.get_random_card_type()
	tween.tween_callback(add_card.bind(random_card)).set_delay(delay)


func get_cards()-> Array[String]:
	var card_types: Array[String] = []
	for hand_card in hand:
		card_types.append(hand_card.get_type())
	return card_types


func clear_cards()-> void:
	selected_card = null
	selectable_card = null
	hovered_card = null
	var dur: float = 0.5
	for hand_card in hand:
		var tween: Tween = hand_card.create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(hand_card, "global_position:x", -300, dur)
		tween.tween_callback(hand_card.queue_free)
	hand.clear()
	

var card_movement_tweens: Array = []
func update_hand_tweens()-> void:
	var x_incre: float = get_card_x_increment()
	var dur: float = 0.3
	for tween in card_movement_tweens:
		tween.stop()
	card_movement_tweens.clear()
	
	var card_count: int = hand.size()
	for i in hand.size():
		var card: HandCard = hand[i]
		var tween: Tween = create_tween()
		card_movement_tweens.append(tween)
		#card.global_position.x = global_position.x
		var value: float = curveRes.sample(i/float(card_count))
		value *= 20
		#card.global_position.y = global_position.y - value
		
		var y_pos: float = GLOBAL.camera.get_target_position().y 
		var y_buffer: float = 24.0
		if GLOBAL.flip_board:
			var card_y_size: float = 48.0
			y_pos -= GLOBAL.SCREEN_SIZE.y / 2.0 + y_buffer - value - card_y_size
		else:
			y_pos += GLOBAL.SCREEN_SIZE.y / 2.0 - y_buffer - value
		tween.parallel().tween_property(card, "global_position:x",  x_incre * i + global_position.x + 30.0, dur)
		tween.parallel().tween_property(card, "global_position:y", y_pos, dur)
		
	#print(value)

func get_card_x_increment()-> float:
	var card_count: int = hand.size()
	var screen_size: Vector2 = GLOBAL.SCREEN_SIZE
	var x_size: float = screen_size.x - 60.0
	var x_incre: float = x_size / float(card_count)
	return x_incre


func _create_handCard()-> HandCard:
	var inst = handCardPacked.instantiate()
	add_child(inst)
	return inst


func remove_card_from_hand(card: HandCard)-> void:
	hand.erase(card)
	card.free()
	update_hand_tweens()


func _on_mouse_place_card_from_hand(card) -> void:
	remove_card_from_hand(card)
