extends Node

signal tutorial_started
signal tutorial_step_changed(step: TutorialStep)
signal tutorial_completed

enum TutorialStep {
	NONE,
	PAUSE_MENU,
	SETTINGS_BUTTON,
	SETTINGS_MENU,
	CREDITS_BUTTON,
	CREDITS_MENU,
	RESUME_BUTTON,

	INTRO_ORGANIC_BIN,
	INTRO_INORGANIC_BIN,
	INTRO_B3_BIN,

	INTRO_TRASH_BAG,
	FILL_TRASH_BAG,

	SORT_ORGANIC,
	SORT_INORGANIC,
	SORT_B3,

	WAIT_PROCESSING,
	TAKE_RESULTS,

	OPEN_INVENTORY,
	INTRO_INVENTORY,

	GO_TO_PRAKASA,
	OPEN_SELL_MENU,
	SELL_RESULT,
	INTRO_COIN,

	COMPLETED
}

var current_step: TutorialStep = TutorialStep.NONE
var is_tutorial_active: bool = false
var tutorial_completed_this_session: bool = false


func start_tutorial() -> void:
	if tutorial_completed_this_session:
		return

	if is_tutorial_active:
		return

	is_tutorial_active = true

	tutorial_started.emit()

	set_step(TutorialStep.PAUSE_MENU)


func set_step(new_step: TutorialStep) -> void:
	if current_step == new_step:
		return

	current_step = new_step

	print(
		"Tutorial Step: ",
		TutorialStep.keys()[current_step]
	)

	tutorial_step_changed.emit(current_step)


func complete_current_step() -> void:
	if not is_tutorial_active:
		return

	match current_step:
		TutorialStep.PAUSE_MENU:
			set_step(TutorialStep.SETTINGS_BUTTON)

		TutorialStep.SETTINGS_BUTTON:
			set_step(TutorialStep.SETTINGS_MENU)

		TutorialStep.SETTINGS_MENU:
			set_step(TutorialStep.CREDITS_BUTTON)

		TutorialStep.CREDITS_BUTTON:
			set_step(TutorialStep.CREDITS_MENU)

		TutorialStep.CREDITS_MENU:
			set_step(TutorialStep.RESUME_BUTTON)

		TutorialStep.RESUME_BUTTON:
			set_step(TutorialStep.INTRO_ORGANIC_BIN)

		TutorialStep.RESUME_BUTTON:
			set_step(TutorialStep.INTRO_ORGANIC_BIN)

		TutorialStep.INTRO_ORGANIC_BIN:
			set_step(TutorialStep.INTRO_INORGANIC_BIN)

		TutorialStep.INTRO_INORGANIC_BIN:
			set_step(TutorialStep.INTRO_B3_BIN)

		TutorialStep.INTRO_B3_BIN:
			set_step(TutorialStep.INTRO_TRASH_BAG)
		_:
			pass


func finish_tutorial() -> void:
	current_step = TutorialStep.COMPLETED
	is_tutorial_active = false
	tutorial_completed_this_session = true

	tutorial_step_changed.emit(current_step)
	tutorial_completed.emit()
