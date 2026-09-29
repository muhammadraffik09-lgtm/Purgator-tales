extends Control

@onready var dim_overlay: ColorRect = $DimOverlay
@onready var highlight: Panel = $Highlight
@onready var tutorial_arrow: TextureRect = $TutorialArrow

@onready var continue_button: BaseButton = $TutorialPanel/ContinueButton
@onready var tutorial_panel: Panel = $TutorialPanel
@onready var title_label: Label = $TutorialPanel/Title
@onready var description_label: Label = $TutorialPanel/Description

var current_target: Control = null
var current_world_target: Node2D = null

const HIGHLIGHT_PADDING := 12.0
const WORLD_HIGHLIGHT_SIZE := Vector2(100.0, 120.0)
const ARROW_GAP := 12.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	visible = false

	TutorialManager.tutorial_started.connect(
		_on_tutorial_started
	)

	TutorialManager.tutorial_step_changed.connect(
		_on_tutorial_step_changed
	)


func _process(_delta: float) -> void:
	if not visible:
		return

	if current_target != null:
		if not is_instance_valid(current_target):
			current_target = null
			return

		_update_target_visuals()
		return

	if current_world_target != null:
		if not is_instance_valid(current_world_target):
			current_world_target = null
			return

		_update_world_target_visuals()


func _on_tutorial_started() -> void:
	visible = true


func _on_tutorial_step_changed(step: TutorialManager.TutorialStep) -> void:
	match step:
		TutorialManager.TutorialStep.PAUSE_MENU:
			_show_pause_menu_tutorial()

		TutorialManager.TutorialStep.SETTINGS_BUTTON:
			_show_settings_button_tutorial()

		TutorialManager.TutorialStep.SETTINGS_MENU:
			_show_settings_menu_tutorial()

		TutorialManager.TutorialStep.COMPLETED:
			hide_tutorial()
			
		TutorialManager.TutorialStep.CREDITS_BUTTON:
			_show_credits_button_tutorial()
			
		TutorialManager.TutorialStep.CREDITS_MENU:
			_show_credits_menu_tutorial()
			
		TutorialManager.TutorialStep.RESUME_BUTTON:
			_show_resume_button_tutorial()
		TutorialManager.TutorialStep.INTRO_ORGANIC_BIN:
			_show_organic_bin_intro()

		TutorialManager.TutorialStep.INTRO_INORGANIC_BIN:
			_show_inorganic_bin_intro()

		TutorialManager.TutorialStep.INTRO_B3_BIN:
			_show_b3_bin_intro()

		_:
			pass

func _show_credits_menu_tutorial() -> void:
	_set_continue_button_visible(false)
	var target := get_tree().get_first_node_in_group(
		"tutorial_credits_panel"
	) as Control

	if target == null:
		push_error(
			"TutorialUI: Credits Panel dengan group tutorial_credits_panel tidak ditemukan."
		)
		return

	current_target = target
	current_world_target = null

	title_label.text = "Credits Menu"
	description_label.text = (
		"Credits Menu menampilkan informasi pembuat game."
	)

	visible = true
	_update_target_visuals()

func _show_credits_button_tutorial() -> void:
	_set_continue_button_visible(false)
	var target := get_tree().get_first_node_in_group(
		"tutorial_credits_button"
	) as Control

	if target == null:
		push_error(
			"TutorialUI: CreditsButton dengan group tutorial_credits_button tidak ditemukan."
		)
		return

	current_target = target
	current_world_target = null

	title_label.text = "Credits"
	description_label.text = (
		"Tekan Credits untuk membuka Credits Menu."
	)

	visible = true

	_update_target_visuals()

func _show_settings_menu_tutorial() -> void:
	_set_continue_button_visible(false)
	var target := get_tree().get_first_node_in_group(
		"tutorial_settings_panel"
	) as Control

	if target == null:
		push_error(
			"TutorialUI: Settings Panel dengan group tutorial_settings_panel tidak ditemukan."
		)
		return

	current_target = target
	current_world_target = null

	title_label.text = "Settings Menu"
	description_label.text = (
		"Di Settings Menu, kamu dapat mengatur pengaturan permainan."
	)

	visible = true
	_update_target_visuals()

func _show_settings_button_tutorial() -> void:
	_set_continue_button_visible(false)
	var target := get_tree().get_first_node_in_group(
		"tutorial_settings_button"
	) as Control

	if target == null:
		push_error(
			"TutorialUI: SettingButton dengan group tutorial_settings_button tidak ditemukan."
		)
		return

	current_target = target
	current_world_target = null

	title_label.text = "Settings"
	description_label.text = (
		"Settings digunakan untuk mengatur Audio dan tampilan UI."
	)

	visible = true

	_update_target_visuals()


func _show_pause_menu_tutorial() -> void:
	_set_continue_button_visible(false)
	var target := get_tree().get_first_node_in_group(
		"tutorial_pause_button"
	) as Control

	if target == null:
		push_error(
			"TutorialUI: PauseMenuButton dengan group tutorial_pause_button tidak ditemukan."
		)
		return

	current_target = target
	current_world_target = null

	title_label.text = "Pause Menu"
	description_label.text = (
		"Tekan tombol Pause untuk membuka Pause Menu."
	)

	visible = true

	_update_target_visuals()


func _update_target_visuals() -> void:
	var target_rect := current_target.get_global_rect()

	var highlight_position := Vector2(
		target_rect.position.x - HIGHLIGHT_PADDING,
		target_rect.position.y - HIGHLIGHT_PADDING
	)

	var highlight_size := Vector2(
		target_rect.size.x + HIGHLIGHT_PADDING * 2.0,
		target_rect.size.y + HIGHLIGHT_PADDING * 2.0
	)

	highlight.position = highlight_position
	highlight.size = highlight_size

	_update_spotlight(
		highlight_position,
		highlight_size
	)

	_update_arrow(
		highlight_position,
		highlight_size
	)


func _update_spotlight(
	hole_position_pixels: Vector2,
	hole_size_pixels: Vector2
) -> void:

	var viewport_size := get_viewport_rect().size

	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return

	var hole_center_pixels := (
		hole_position_pixels +
		hole_size_pixels / 2.0
	)

	var normalized_position := Vector2(
		hole_center_pixels.x / viewport_size.x,
		hole_center_pixels.y / viewport_size.y
	)

	var normalized_size := Vector2(
		hole_size_pixels.x / viewport_size.x,
		hole_size_pixels.y / viewport_size.y
	)

	var material := dim_overlay.material as ShaderMaterial

	if material == null:
		return

	material.set_shader_parameter(
		"hole_position",
		normalized_position
	)

	material.set_shader_parameter(
		"hole_size",
		normalized_size
	)


func _update_arrow(
	target_position: Vector2,
	target_size: Vector2
) -> void:

	var arrow_size := tutorial_arrow.size

	tutorial_arrow.position = Vector2(
		target_position.x
			- arrow_size.x
			- ARROW_GAP,

		target_position.y
			+ target_size.y / 2.0
			- arrow_size.y / 2.0
	)


func hide_tutorial() -> void:
	current_target = null
	visible = false

func _show_resume_button_tutorial() -> void:
	_set_continue_button_visible(false)
	var target := get_tree().get_first_node_in_group(
		"tutorial_resume_button"
	) as Control

	if target == null:
		push_error(
			"TutorialUI: ResumeButton dengan group tutorial_resume_button tidak ditemukan."
		)
		return

	current_target = target
	current_world_target = null

	title_label.text = "Resume"
	description_label.text = (
		"Tekan Resume untuk kembali ke permainan."
	)

	visible = true
	_update_target_visuals()


func _on_continue_button_pressed() -> void:
	if not TutorialManager.is_tutorial_active:
		return

	match TutorialManager.current_step:
		TutorialManager.TutorialStep.INTRO_ORGANIC_BIN, \
		TutorialManager.TutorialStep.INTRO_INORGANIC_BIN, \
		TutorialManager.TutorialStep.INTRO_B3_BIN:
			TutorialManager.complete_current_step()

func _set_continue_button_visible(show_button: bool) -> void:
	continue_button.visible = show_button

func _clear_ui_target() -> void:
	current_target = null
	highlight.visible = false
	tutorial_arrow.visible = false

func _set_full_dim() -> void:
	var material := dim_overlay.material as ShaderMaterial

	if material == null:
		return

	material.set_shader_parameter(
		"hole_position",
		Vector2(-1.0, -1.0)
	)

	material.set_shader_parameter(
		"hole_size",
		Vector2.ZERO
	)

func _show_organic_bin_intro() -> void:
	var berhasil := _set_world_target(
		"tutorial_tong_organik"
	)

	if not berhasil:
		return

	title_label.text = "Tong Sampah Organik"

	description_label.text = (
		"Ini adalah Tong Sampah Organik.\n\n"
		+ "Masukkan sampah Organik seperti:\n"
		+ "• Kumpulan Tanah\n"
		+ "• Pisang"
	)

	_set_continue_button_visible(true)

	visible = true

func _show_inorganic_bin_intro() -> void:
	var berhasil := _set_world_target(
		"tutorial_tong_anorganik"
	)

	if not berhasil:
		return

	title_label.text = "Tong Sampah Anorganik"

	description_label.text = (
		"Ini adalah Tong Sampah Anorganik.\n\n"
		+ "Masukkan sampah Anorganik seperti:\n"
		+ "• Botol Plastik\n"
		+ "• Kantong Sampah"
	)

	_set_continue_button_visible(true)

	visible = true

	visible = true

func _show_b3_bin_intro() -> void:
	var berhasil := _set_world_target(
		"tutorial_tong_b3"
	)

	if not berhasil:
		return

	title_label.text = "Tong Sampah B3"

	description_label.text = (
		"Ini adalah Tong Sampah B3.\n\n"
		+ "Masukkan sampah B3 seperti:\n"
		+ "• Baterai\n"
		+ "• Jarum Suntik"
	)

	_set_continue_button_visible(true)

	visible = true

func _update_world_target_visuals() -> void:
	if current_world_target == null:
		return

	var canvas_transform := get_viewport().get_canvas_transform()

	var screen_position := canvas_transform * current_world_target.global_position

	var highlight_size := WORLD_HIGHLIGHT_SIZE

	var highlight_position := (
		screen_position
		- highlight_size / 2.0
	)

	highlight.visible = true
	tutorial_arrow.visible = true

	highlight.position = highlight_position
	highlight.size = highlight_size

	_update_spotlight(
		highlight_position,
		highlight_size
	)

	_update_arrow(
		highlight_position,
		highlight_size
	)

func _set_world_target(group_name: String) -> bool:
	var target := get_tree().get_first_node_in_group(
		group_name
	) as Node2D

	if target == null:
		push_error(
			"TutorialUI: World target tidak ditemukan: "
			+ group_name
		)
		return false

	current_target = null
	current_world_target = target

	highlight.visible = true
	tutorial_arrow.visible = true

	_update_world_target_visuals()

	return true
