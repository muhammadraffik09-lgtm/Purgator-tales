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
	
	PROCESSING_INFO,
	TAKE_RESULT,
	INTRO_INVENTORY,

	WAIT_PROCESSING,
	TAKE_RESULTS,

	OPEN_INVENTORY,

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

		TutorialStep.INTRO_TRASH_BAG:
			set_step(TutorialStep.FILL_TRASH_BAG)

		TutorialStep.FILL_TRASH_BAG:
			set_step(TutorialStep.SORT_ORGANIC)

		TutorialStep.SORT_ORGANIC:
			set_step(TutorialStep.SORT_INORGANIC)

		TutorialStep.SORT_INORGANIC:
			set_step(TutorialStep.SORT_B3)

		TutorialStep.SORT_B3:
			set_step(TutorialStep.PROCESSING_INFO)
			
		TutorialStep.PROCESSING_INFO:
			set_step(TutorialStep.TAKE_RESULT)
			
		TutorialStep.TAKE_RESULT:
			set_step(TutorialStep.INTRO_INVENTORY)
		_:
			pass


func finish_tutorial() -> void:
	current_step = TutorialStep.COMPLETED
	is_tutorial_active = false
	tutorial_completed_this_session = true

	tutorial_step_changed.emit(current_step)
	tutorial_completed.emit()

func notify_result_taken() -> void:
	if not is_tutorial_active:
		return

	if current_step != TutorialStep.TAKE_RESULT:
		return

	complete_current_step()

func notify_result_created() -> void:
	if not is_tutorial_active:
		return

	if current_step != TutorialStep.PROCESSING_INFO:
		return

	complete_current_step()

func _is_any_result_available() -> bool:
	var tong_menus := get_tree().get_nodes_in_group(
		"tong_sampah_menu"
	)

	print(
		"[TUTORIAL] Jumlah TongSampahMenu ditemukan: ",
		tong_menus.size()
	)

	for tong_menu in tong_menus:
		if tong_menu == null:
			continue

		if not is_instance_valid(tong_menu):
			continue

		if not tong_menu.has_method(
			"has_result_available"
		):
			print(
				"[TUTORIAL] Tidak punya has_result_available: ",
				tong_menu.name
			)
			continue

		if tong_menu.has_result_available():
			print(
				"[TUTORIAL] RESULT DITEMUKAN DI: ",
				tong_menu.name
			)
			return true

	return false
