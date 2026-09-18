extends CharacterBody2D

const DIALOGUE_FILE = preload("res://percakapan.dialogue")
const CustomBalloon = preload("res://Asset/balloon.tscn")

func _unhandled_input(event: InputEvent) -> void:
	var animasi = $AnimatedSprite2D
	if event.is_action_pressed("ui_accept"): # Tekan Enter / Spasi
		DialogueManager.show_example_dialogue_balloon(DIALOGUE_FILE, "start")
	else:
			animasi.play("idle_npc1")
