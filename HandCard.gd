@tool
class_name HandCard
extends Node2D


@onready var nineRect: NinePatchRect = $NinePatchRect
@onready var textureRect: TextureRect = $NinePatchRect/Control/TextureRect
@onready var textureControl: Control = $NinePatchRect/Control
@onready var label: Label = $NinePatchRect/TextureRect2/Label

var hoveredTween: Tween = null
var selectedTween: Tween = null
var type: String 
func _ready() -> void:
	nineRect.size = Vector2(2,3) * GLOBAL.CELL_SIZE


func set_type(_type: String)-> void:
	type = _type
	var card_data: Dictionary = GLOBAL.CARD.get(type)
	textureRect.texture = load(card_data.get("tex"))
	textureRect.position = textureControl.size/2.0 - textureRect.size/2.0
	set_text(type.capitalize())

func get_type()-> String:
	return type


func set_text(text: String)-> void:
	label.text = text
	


func tween_collapse()-> void:
	if hoveredTween:
		hoveredTween.stop()
		hoveredTween = null
	
	hoveredTween = create_tween()
	var dur: float = 0.2
	hoveredTween.set_trans(Tween.TRANS_CUBIC)
	hoveredTween.set_ease(Tween.EASE_IN)
	hoveredTween.tween_property(self, "scale", Vector2(1.0, 1.0), dur)


func tween_expand()-> void:
	if hoveredTween:
		hoveredTween.stop()
		hoveredTween = null
	
	hoveredTween = create_tween()
	var dur: float = 0.2
	hoveredTween.set_trans(Tween.TRANS_CUBIC)
	hoveredTween.set_ease(Tween.EASE_OUT)
	hoveredTween.tween_property(self, "scale", Vector2(1.15, 1.15), dur)


func tween_selected()-> void:
	hoveredTween.stop()
	if selectedTween:
		selectedTween.stop()
		selectedTween = null
	
	selectedTween = create_tween()
	var dur: float = 0.15
	selectedTween.set_trans(Tween.TRANS_CUBIC)
	#selectedTween.set_ease(Tween.EASE_IN)
	var v: float = 1.4
	rotation_degrees = sign(randf()) * 10.0
	selectedTween.tween_property(self, "rotation_degrees", 0.0, dur)
	selectedTween.parallel().tween_property(nineRect, "modulate", Color(v,v,v), dur)
	selectedTween.parallel().tween_property(self, "scale", Vector2(1.45, 1.45), dur)



func tween_deselected()-> void:
	hoveredTween.stop()
	if selectedTween:
		selectedTween.stop()
		selectedTween = null
	
	selectedTween = create_tween()
	var dur: float = 0.15
	selectedTween.set_trans(Tween.TRANS_CUBIC)
	#selectedTween.set_trans(Tween.TRANS_CUBIC)
	#selectedTween.set_ease(Tween.EASE_IN)
	var v: float = 1.0
	selectedTween.parallel().tween_property(nineRect, "modulate", Color(v,v,v), dur)
	selectedTween.parallel().tween_property(self, "scale", Vector2(1.0, 1.0), dur)
