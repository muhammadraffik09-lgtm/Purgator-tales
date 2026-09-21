extends Control


signal back_pressed


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_back_button_pressed():
	if not UITransitionManager.try_transition():
		return

	back_pressed.emit()
