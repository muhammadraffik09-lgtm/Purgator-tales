extends Control

signal back_pressed

@onready var pause_menu = get_parent().get_node("PauseMenu")

const SETTINGS_FILE := "user://settings.cfg"
const SETTINGS_SECTION := "UI"
const DEFAULT_TRANSPARENCY := 20.0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	var config = ConfigFile.new()
	var error = config.load(SETTINGS_FILE)

	var transparency := DEFAULT_TRANSPARENCY

	if error == OK:
		transparency = config.get_value(
			SETTINGS_SECTION,
			"transparency",
			DEFAULT_TRANSPARENCY
		)

	$Panel/SettingsScroll/SettingsList/UITransparency/TransparencyRow/UITransparencySlider.value = transparency

	_apply_transparency(transparency)


func _on_ui_transparency_slider_value_changed(value: float):
	_apply_transparency(value)
	_save_transparency(value)


func _apply_transparency(value: float):
	var alpha = 1.0 - (value / 100.0)

	$Panel.modulate.a = alpha
	pause_menu.modulate.a = alpha

	$Panel/SettingsScroll/SettingsList/UITransparency/TransparencyRow/UITransparencyValue.text = str(int(value)) + "%"

func _save_transparency(value: float):
	var config = ConfigFile.new()

	config.load(SETTINGS_FILE)

	config.set_value(
		SETTINGS_SECTION,
		"transparency",
		value
	)

	config.save(SETTINGS_FILE)


func _on_back_button_pressed():
	back_pressed.emit()
