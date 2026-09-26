extends Control


@onready var pause_menu = $PauseMenu


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.visible = false
	get_tree().paused = false

func _on_pause_button_pressed():
	AudioManager.play_ui_click()
	if get_tree().paused:
		get_tree().paused = false
		pause_menu.visible = false
	else:
		pause_menu.visible = true
		get_tree().paused = true


func _on_resume_button_pressed():
	AudioManager.play_ui_click()
	get_tree().paused = false
	pause_menu.visible = false

func _on_quest_button_pressed():
	AudioManager.play_ui_click()
	if not UITransitionManager.try_transition():
		return

	$QuestMenu.visible = true

func _on_setting_button_pressed():
	AudioManager.play_ui_click()
	if not UITransitionManager.try_transition():
		return

	$PauseMenu.visible = false

	var main_menu = get_tree().get_first_node_in_group("main_menu")

	if main_menu:
		main_menu.open_settings_from_pause()

func _on_credits_button_pressed():
	AudioManager.play_ui_click()
	if not UITransitionManager.try_transition():
		return

	$PauseMenu.visible = false

	var main_menu = get_tree().get_first_node_in_group("main_menu")

	if main_menu:
		main_menu.open_credits_from_pause()

func _on_main_menu_button_pressed():
	AudioManager.play_ui_click()
	if not UITransitionManager.try_transition():
		return

	AudioManager.play_ui_click()
	AudioManager.play_main_menu_bgm()

	get_tree().paused = false
	$PauseMenu.visible = false

	var main_menu = get_tree().get_first_node_in_group("main_menu")

	if main_menu:
		main_menu.visible = true
		get_tree().paused = true


func _on_inventory_button_pressed():
	AudioManager.play_ui_click()
	if not UITransitionManager.try_transition():
		return

	$InventoryMenu.visible = true

	if $InventoryMenu.has_method("refresh_inventory"):
		$InventoryMenu.refresh_inventory()


func _on_player_menu_button_pressed() -> void:
	AudioManager.play_ui_click()
	if not UITransitionManager.try_transition():
		return

	$HUD/PlayerMenu.visible = true
