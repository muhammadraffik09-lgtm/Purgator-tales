extends Control


signal back_pressed


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_back_button_pressed() -> void:
	if not UITransitionManager.try_transition():
		return

	back_pressed.emit()

	if (
		TutorialManager.is_tutorial_active
		and TutorialManager.current_step
		== TutorialManager.TutorialStep.CREDITS_MENU
	):
		TutorialManager.complete_current_step()
