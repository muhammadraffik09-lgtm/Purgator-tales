extends Control

@onready var master_volume_slider: HSlider = $Panel/SettingsScroll/SettingsList/MasterVolume/MasterVolumeSlider
@onready var master_volume_value: Label = $Panel/SettingsScroll/SettingsList/MasterVolume/MasterVolumeValue

@onready var audio_slider: HSlider = $Panel/SettingsScroll/SettingsList/Audio/AudioSlider
@onready var audio_value: Label = $Panel/SettingsScroll/SettingsList/Audio/AudioValue

@onready var bgm_slider: HSlider = $Panel/SettingsScroll/SettingsList/BGM/BGMSlider
@onready var bgm_value: Label = $Panel/SettingsScroll/SettingsList/BGM/BGMValue

@onready var transparency_slider: HSlider = $Panel/SettingsScroll/SettingsList/UITransparency/TransparencyRow/UITransparencySlider
@onready var transparency_value: Label = $Panel/SettingsScroll/SettingsList/UITransparency/TransparencyRow/UITransparencyValue


signal back_pressed


const SETTINGS_FILE := "user://settings.cfg"

const SETTINGS_SECTION := "UI"
const AUDIO_SECTION := "Audio"

const DEFAULT_TRANSPARENCY := 20.0
const DEFAULT_MASTER_VOLUME := 100.0
const DEFAULT_AUDIO_VOLUME := 100.0
const DEFAULT_BGM_VOLUME := 100.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	# =========================================================
	# LOAD AUDIO SETTINGS
	# =========================================================

	var master_volume := _load_setting(
		AUDIO_SECTION,
		"master_volume",
		DEFAULT_MASTER_VOLUME
	)

	var audio_volume := _load_setting(
		AUDIO_SECTION,
		"audio_volume",
		DEFAULT_AUDIO_VOLUME
	)

	var bgm_volume := _load_setting(
		AUDIO_SECTION,
		"bgm_volume",
		DEFAULT_BGM_VOLUME
	)

	master_volume_slider.value = master_volume
	audio_slider.value = audio_volume
	bgm_slider.value = bgm_volume

	_set_bus_volume("Master", master_volume)
	_set_bus_volume("Audio", audio_volume)
	_set_bus_volume("BGM", bgm_volume)

	_update_audio_value_labels()


	# =========================================================
	# LOAD UI TRANSPARENCY
	# =========================================================

	var transparency := _load_setting(
		SETTINGS_SECTION,
		"transparency",
		DEFAULT_TRANSPARENCY
	)

	transparency_slider.value = transparency

	_apply_transparency(transparency)


# =========================================================
# UI TRANSPARENCY
# =========================================================

func _on_ui_transparency_slider_value_changed(value: float) -> void:
	_apply_transparency(value)
	_save_setting(
		SETTINGS_SECTION,
		"transparency",
		value
	)


func _apply_transparency(value: float) -> void:
	var alpha := 1.0 - (value / 100.0)

	for node in get_tree().get_nodes_in_group("ui_transparent"):
		if node is CanvasItem:
			node.modulate.a = alpha

	transparency_value.text = str(int(value)) + "%"


# =========================================================
# AUDIO
# =========================================================

func _on_master_volume_slider_value_changed(value: float) -> void:
	_set_bus_volume("Master", value)

	_save_setting(
		AUDIO_SECTION,
		"master_volume",
		value
	)

	master_volume_value.text = str(int(value)) + "%"


func _on_audio_slider_value_changed(value: float) -> void:
	_set_bus_volume("Audio", value)

	_save_setting(
		AUDIO_SECTION,
		"audio_volume",
		value
	)

	audio_value.text = str(int(value)) + "%"


func _on_bgm_slider_value_changed(value: float) -> void:
	_set_bus_volume("BGM", value)

	_save_setting(
		AUDIO_SECTION,
		"bgm_volume",
		value
	)

	bgm_value.text = str(int(value)) + "%"


func _set_bus_volume(bus_name: String, value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)

	if bus_index == -1:
		push_error("Audio bus tidak ditemukan: " + bus_name)
		return

	var volume := clampf(value / 100.0, 0.0, 1.0)

	if volume <= 0.0:
		AudioServer.set_bus_volume_db(bus_index, -80.0)
	else:
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(volume)
		)


func _update_audio_value_labels() -> void:
	master_volume_value.text = str(int(master_volume_slider.value)) + "%"
	audio_value.text = str(int(audio_slider.value)) + "%"
	bgm_value.text = str(int(bgm_slider.value)) + "%"


# =========================================================
# SETTINGS SAVE / LOAD
# =========================================================

func _save_setting(
	section: String,
	setting_name: String,
	value: float
) -> void:
	var config := ConfigFile.new()

	config.load(SETTINGS_FILE)

	config.set_value(
		section,
		setting_name,
		value
	)

	config.save(SETTINGS_FILE)


func _load_setting(
	section: String,
	setting_name: String,
	default_value: float
) -> float:
	var config := ConfigFile.new()

	var error: Error = config.load(SETTINGS_FILE)

	if error != OK:
		return default_value

	return float(
		config.get_value(
			section,
			setting_name,
			default_value
		)
	)


# =========================================================
# BACK BUTTON
# =========================================================

func _on_back_button_pressed() -> void:
	if not UITransitionManager.try_transition():
		return

	back_pressed.emit()

	if (
		TutorialManager.is_tutorial_active
		and TutorialManager.current_step
		== TutorialManager.TutorialStep.SETTINGS_MENU
	):
		TutorialManager.complete_current_step()
