extends Control

@onready var pause_menu = $PauseMenu


func _ready():
	pause_menu.visible = false
	get_tree().paused = false


func _on_pause_button_pressed():
	if get_tree().paused:
		get_tree().paused = false
		pause_menu.visible = false
	else:
		pause_menu.visible = true
		get_tree().paused = true


func _on_resume_button_pressed():
	get_tree().paused = false
	pause_menu.visible = false


func _on_setting_button_pressed():
	$PauseMenu.visible = false

	var main_menu = get_tree().get_first_node_in_group("main_menu")

	if main_menu:
		main_menu.open_settings_from_pause()


func _on_credits_button_pressed():
	$PauseMenu.visible = false

	var main_menu = get_tree().get_first_node_in_group("main_menu")

	if main_menu:
		main_menu.open_credits_from_pause()


func _on_settings_menu_back_pressed():
	$SettingsMenu.visible = false
	$PauseMenu.visible = true


func _on_credits_menu_back_pressed():
	$CreditsMenu.visible = false
	$PauseMenu.visible = true

func _on_main_menu_button_pressed():
	get_tree().paused = false

	$PauseMenu.visible = false

	var main_menu = get_tree().get_first_node_in_group("main_menu")

	if main_menu:
		main_menu.visible = true
		get_tree().paused = true

func _on_quest_button_pressed():
	$QuestMenu.visible = true
