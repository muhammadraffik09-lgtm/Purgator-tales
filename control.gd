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

func _on_back_button_pressed():
	$PauseMenu.visible = true
	$PauseMenu/SettingsMenu.visible = false


func _on_settings_menu_back_pressed():
	$SettingsMenu.visible = false
	$PauseMenu.visible = true

func _on_setting_button_pressed():
	$PauseMenu.visible = false
	$SettingsMenu.visible = true
