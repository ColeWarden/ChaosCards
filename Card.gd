@tool
extends Node2D
class_name Card

@onready var nineRect: NinePatchRect = $NineRectCard
@onready var nineRectShadow: NinePatchRect = $NineRectShadow
@onready var textureRect: TextureRect = $NineRectCard/Control/TextureRect

var color: Color = Color.WEB_MAROON
var card_cell_size: Vector2i = Vector2i(1,1)
var card_min_cell_size: Vector2i = Vector2i(1,1)
var card_max_cell_size: Vector2i = Vector2i(2,3)
var type: String
var tween: Tween = null

func set_type(_type: String)-> void:
	type = _type
	var card_data: Dictionary = GLOBAL.CARD.get(type)
	textureRect.texture = load(card_data.get("tex"))
	card_min_cell_size = card_data.get("min")
	card_max_cell_size = card_data.get("max")
	set_card_size(card_min_cell_size)

func get_type()-> String:
	return type

func set_card_size(value: Vector2i):
	value = value.clamp(card_min_cell_size, card_max_cell_size)
	card_cell_size = value
	nineRect.size = Vector2(card_cell_size.x * 16.0, card_cell_size.y * 16.0)
	nineRectShadow.size = nineRect.size + Vector2(1,1)
	nineRect.pivot_offset = nineRect.size / 2.0
	nineRectShadow.pivot_offset = nineRectShadow.size / 2.0
	#var tex_size: Vector2 = textureRect.size / 2.0
	#textureRect.position = tex_size + (nineRect.size / 2.0)


func get_card_size()-> Vector2i:
	return card_cell_size


func set_color(_color: Color)-> void:
	color = _color
	nineRect.modulate = color


func tween_rotate_start(rot: float, dur: float, loops: int = 0)-> void:
	if !tween:
		tween = create_tween()
	
	tween.set_loops(loops).tween_property(nineRect, "rotation_degrees", rot, dur)
	tween.set_loops(loops).set_parallel().tween_property(nineRectShadow, "rotation_degrees", rot, dur)
	tween.set_loops(loops).chain().tween_property(nineRect, "rotation_degrees", -rot, dur)
	tween.set_loops(loops).set_parallel().tween_property(nineRectShadow, "rotation_degrees", -rot, dur)


func tween_scale_start(min_scale: Vector2, max_scale: Vector2, dur: float, loops: int = 0)-> void:
	if !tween:
		tween = create_tween()
	
	tween.set_loops(loops).tween_property(nineRect, "scale", min_scale, dur)
	tween.set_loops(loops).set_parallel().tween_property(nineRectShadow, "scale", min_scale, dur)
	tween.set_loops(loops).chain().tween_property(nineRect, "scale", max_scale, dur)
	tween.set_loops(loops).set_parallel().tween_property(nineRectShadow, "scale", max_scale, dur)


func tween_kill()-> void:
	if tween:
		tween.kill()
		tween = null

