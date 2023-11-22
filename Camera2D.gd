extends Camera2D

var target_position: Vector2 = global_position
var speed: float = 100.0


func _process(delta: float) -> void:
	var input = false
	if Input.is_action_just_pressed("w"):
		set_target_position(get_enemy_board_center_pos())
	elif Input.is_action_just_pressed("s"):
		set_target_position(get_player_board_center_pos())


func set_target_position(pos: Vector2)-> void:
	target_position = pos
	var tween = create_tween()
	var dur: float = 0.6
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target_position, dur)


func get_enemy_board_center_pos()-> Vector2:
	var board = get_parent().enemyBoard
	return board.global_position + board.region_rect.size/2.0


func get_player_board_center_pos()-> Vector2:
	var board = get_parent().playerBoard
	return board.global_position + board.region_rect.size/2.0


#	var direction: Vector2 = Vector2.ZERO
#	direction.x = float(Input.is_action_pressed("d")) - float(Input.is_action_pressed("a"))
#	direction.y = float(Input.is_action_pressed("s")) - float(Input.is_action_pressed("w"))
#	var velocity: Vector2 = direction * speed * delta
#	global_position += velocity
