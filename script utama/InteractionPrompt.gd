extends Control


@onready var e_button: TextureButton = $EButton
@onready var interaction_text: Label = $InteractionText


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false


func show_interaction(text: String) -> void:
	interaction_text.text = text
	visible = true


func hide_interaction() -> void:
	visible = false
