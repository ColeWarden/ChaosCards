class_name SoundEffectManager
extends AudioStreamPlayer2D

@onready var wavSfx: Dictionary = {}


func _ready() -> void:
	var card_types: Array = GLOBAL.CARD.keys()
	for type in GLOBAL.CARD:
		wavSfx[type] = load(GLOBAL.CARD[type]["snd"])


func play_card_sfx(type: String)-> void:
	stream = wavSfx[type]
	print(stream)
	play()


func _on_finished() -> void:
	stream = null
