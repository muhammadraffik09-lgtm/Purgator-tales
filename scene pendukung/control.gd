extends Control

@onready var coin_text: Label = $HUD/TopRight/VBoxContainer/Coin/Coin_Bar/Coin_text
@onready var pause_menu = $PauseMenu

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	pause_menu.visible = false
	get_tree().paused = false

	CoinManager.coin_changed.connect(_on_coin_changed)

	_update_coin_display()


func _on_coin_changed(_amount: int) -> void:
	_update_coin_display()


func _update_coin_display() -> void:
	coin_text.text = str(CoinManager.get_coins())

func _on_pause_button_pressed():
	AudioManager.play_ui_click()
	if get_tree().paused:
		get_tree().paused = false
		pause_menu.visible = false
	else:
		pause_menu.visible = true
		get_tree().paused = true

		if (
			TutorialManager.is_tutorial_active
			and TutorialManager.current_step
			== TutorialManager.TutorialStep.PAUSE_MENU
		):
			TutorialManager.complete_current_step()


func _on_resume_button_pressed():
	AudioManager.play_ui_click()
	get_tree().paused = false
	pause_menu.visible = false

	if (
		TutorialManager.is_tutorial_active
		and TutorialManager.current_step
		== TutorialManager.TutorialStep.RESUME_BUTTON
	):
		TutorialManager.complete_current_step()

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

	if (
		TutorialManager.is_tutorial_active
		and TutorialManager.current_step
		== TutorialManager.TutorialStep.SETTINGS_BUTTON
	):
		TutorialManager.complete_current_step()

func _on_credits_button_pressed():
	AudioManager.play_ui_click()
	if not UITransitionManager.try_transition():
		return

	$PauseMenu.visible = false

	var main_menu = get_tree().get_first_node_in_group("main_menu")

	if main_menu:
		main_menu.open_credits_from_pause()

	if (
		TutorialManager.is_tutorial_active
		and TutorialManager.current_step
		== TutorialManager.TutorialStep.CREDITS_BUTTON
	):
		TutorialManager.complete_current_step()

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
	TutorialManager.notify_inventory_opened()

	if $InventoryMenu.has_method("refresh_inventory"):
		$InventoryMenu.refresh_inventory()


func _on_player_menu_button_pressed() -> void:
	AudioManager.play_ui_click()
	if not UITransitionManager.try_transition():
		return

	$HUD/PlayerMenu.visible = true
