extends Control

@onready var pause_menu = $PauseMenu

func _ready():
	pause_menu.visible = false

func _on_pause_button_pressed():
	pause_menu.visible = !pause_menu.visible


func _on_pause_menu_pressed() -> void:
	pass # Replace with function body.
