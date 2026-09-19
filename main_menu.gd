extends Control

@onready var settings_menu = $SettingsMenu
@onready var credits_menu = $CreditsMenu

var opened_from_pause: bool = false


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	visible = true

	get_tree().paused = true

	$SettingsMenu.visible = false
	$CreditsMenu.visible = false

	if GameState.has_played:
		$StartButton/StartLabel.text = "CONTINUE"
	else:
		$StartButton/StartLabel.text = "START"

func _on_start_button_pressed():
	GameState.has_played = true

	settings_menu.visible = false
	credits_menu.visible = false

	visible = false
	get_tree().paused = false


func _on_settings_button_pressed():
	opened_from_pause = false

	settings_menu.visible = true
	credits_menu.visible = false


func _on_credits_button_pressed():
	opened_from_pause = false

	credits_menu.visible = true
	settings_menu.visible = false


func _on_exit_button_pressed():
	get_tree().quit()


func _on_settings_menu_back_pressed():
	settings_menu.visible = false

	if opened_from_pause:
		_return_to_pause_menu()


func _on_credits_menu_back_pressed():
	credits_menu.visible = false

	if opened_from_pause:
		_return_to_pause_menu()


func open_settings_from_pause():
	opened_from_pause = true

	visible = true

	$Background.visible = false
	$Title.visible = false
	$StartButton.visible = false
	$SettingsButton.visible = false
	$CreditsButton.visible = false
	$ExitButton.visible = false

	settings_menu.visible = true
	credits_menu.visible = false


func open_credits_from_pause():
	opened_from_pause = true

	visible = true

	$Background.visible = false
	$Title.visible = false
	$StartButton.visible = false
	$SettingsButton.visible = false
	$CreditsButton.visible = false
	$ExitButton.visible = false

	credits_menu.visible = true
	settings_menu.visible = false


func _return_to_pause_menu():
	settings_menu.visible = false
	credits_menu.visible = false

	$Background.visible = true
	$Title.visible = true
	$StartButton.visible = true
	$SettingsButton.visible = true
	$CreditsButton.visible = true
	$ExitButton.visible = true

	visible = false

	var pause_menu = get_tree().get_first_node_in_group("pause_menu")

	if pause_menu:
		pause_menu.visible = true
