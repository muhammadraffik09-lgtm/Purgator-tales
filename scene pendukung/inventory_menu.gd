extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false


func _on_close_button_pressed():
	visible = false
