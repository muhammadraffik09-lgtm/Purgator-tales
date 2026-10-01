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

const ARROW_TEXTURE_ANGLE_OFFSET := 0.0
const SCREEN_ARROW_MARGIN := 80.0
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
	
	TutorialManager.tutorial_finished.connect(
		_on_tutorial_finished
	)
	
	var player := _get_player()

	if player != null:
		if not player.trash_bag_changed.is_connected(
			_on_trash_bag_changed
		):
			player.trash_bag_changed.connect(
				_on_trash_bag_changed
			)


func _process(_delta: float) -> void:
	if not visible:
		return

	if (
		TutorialManager.is_tutorial_active
		and TutorialManager.current_step
		== TutorialManager.TutorialStep.PROCESSING_INFO
	):
		if _is_any_result_available():
			TutorialManager.complete_current_step()

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
		return


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
			
		TutorialManager.TutorialStep.INTRO_TRASH_BAG:
			_show_trash_bag_tutorial()
			
		TutorialManager.TutorialStep.FILL_TRASH_BAG:
			_start_fill_trash_bag_tutorial()

		TutorialManager.TutorialStep.SORT_ORGANIC:
			_show_sort_organic_tutorial()

		TutorialManager.TutorialStep.SORT_INORGANIC:
			_show_sort_inorganic_tutorial()

		TutorialManager.TutorialStep.SORT_B3:
			_show_sort_b3_tutorial()
			
		TutorialManager.TutorialStep.PROCESSING_INFO:
			_show_processing_info()

		TutorialManager.TutorialStep.TAKE_RESULT:
			_show_take_result_tutorial()

		TutorialManager.TutorialStep.INTRO_INVENTORY:
			_show_inventory_tutorial()

		TutorialManager.TutorialStep.SHOW_INVENTORY:
			_show_inventory_menu_tutorial()

		TutorialManager.TutorialStep.GO_TO_PRAKASA:
			_show_go_to_prakasa_tutorial()

		TutorialManager.TutorialStep.INTRO_SELL_MENU:
			_show_sell_menu_tutorial()

		TutorialManager.TutorialStep.SELL_RESULT:
			_show_sell_result_tutorial()

		TutorialManager.TutorialStep.COMPLETED:
			hide_tutorial()
		_:
			pass

func _show_trash_bag_tutorial() -> void:
	var target := get_tree().get_first_node_in_group(
		"tutorial_trash_bag"
	) as Control

	if target == null:
		push_error(
			"TutorialUI: Trash Bag dengan group tutorial_trash_bag tidak ditemukan."
		)
		return

	current_world_target = null
	current_target = target

	highlight.visible = true
	dim_overlay.visible = true

	title_label.text = "Trash Bag"
	description_label.text = (
		"Trash Bag digunakan untuk menyimpan sampah yang kamu ambil.\n\n"
		+ "Isi Trash Bag sampai penuh untuk melanjutkan tutorial."
	)

	_set_continue_button_visible(true)

	visible = true
	_update_target_visuals()

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

func hide_tutorial() -> void:
	current_target = null
	current_world_target = null

	dim_overlay.visible = false
	highlight.visible = false

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
		TutorialManager.TutorialStep.INTRO_B3_BIN, \
		TutorialManager.TutorialStep.INTRO_TRASH_BAG:
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


	highlight.position = highlight_position
	highlight.size = highlight_size

	_update_spotlight(
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

	_update_world_target_visuals()

	return true

func _start_fill_trash_bag_tutorial() -> void:
	current_target = null
	current_world_target = null

	dim_overlay.visible = false
	highlight.visible = false

	title_label.text = "Isi Trash Bag"

	description_label.text = (
	"Cari dan ambil sampah yang diberi highlight "
	+ "sampai Trash Bag penuh."
)

	_set_continue_button_visible(false)

	visible = true

	# Highlight semua sampah di map.
	_set_all_trash_highlight(true)

	var player := _get_player()

	if player != null:
		_update_trash_bag_progress(player)

func _get_player() -> Node2D:
	return get_tree().get_first_node_in_group(
		"player"
	) as Node2D


func _on_trash_bag_changed() -> void:
	if not TutorialManager.is_tutorial_active:
		return

	if (
		TutorialManager.current_step
		!= TutorialManager.TutorialStep.FILL_TRASH_BAG
	):
		return

	var player := _get_player()

	if player == null:
		return

	_update_trash_bag_progress(player)

	if player.is_trash_bag_full():
		TutorialManager.complete_current_step()

func _update_trash_bag_progress(player: Node) -> void:
	var current_count: int = player.get_trash_bag_count()
	var capacity: int = player.TRASH_BAG_CAPACITY

	description_label.text = (
		"Cari dan ambil sampah sampai Trash Bag penuh.\n"
		+ "Benda yang bercahaya disekitarnya adalah sampah(Tutorial Only!).\n\n"
		+ "Trash Bag: "
		+ str(current_count)
		+ "/"
		+ str(capacity)
	)

func _set_all_trash_highlight(enabled: bool) -> void:
	var trash_nodes := get_tree().get_nodes_in_group(
		"tutorial_trash"
	)

	for node in trash_nodes:
		if node == null:
			continue

		if not is_instance_valid(node):
			continue

		if node.has_method("set_tutorial_highlight"):
			node.set_tutorial_highlight(enabled)

func _show_sort_organic_tutorial() -> void:
	current_target = null
	current_world_target = null

	dim_overlay.visible = false
	highlight.visible = false

	title_label.text = "Pisahkan Sampah Organik"

	description_label.text = (
		"Pergi ke Tong Sampah Organik dan tekan E.\n"
		+ "Sampah Organik di Trash Bag akan dimasukkan ke tong."
	)

	_set_continue_button_visible(false)

	visible = true

func _show_sort_inorganic_tutorial() -> void:
	current_target = null
	current_world_target = null

	dim_overlay.visible = false
	highlight.visible = false

	title_label.text = "Pisahkan Sampah Anorganik"

	description_label.text = (
		"Pergi ke Tong Sampah Anorganik dan tekan E.\n"
		+ "Sampah Anorganik di Trash Bag akan dimasukkan ke tong."
	)

	_set_continue_button_visible(false)

	visible = true

func _show_sort_b3_tutorial() -> void:
	current_target = null
	current_world_target = null

	dim_overlay.visible = false
	highlight.visible = false

	title_label.text = "Pisahkan Sampah B3"

	description_label.text = (
		"Pergi ke Tong Sampah B3 dan tekan E.\n"
		+ "Sampah B3 di Trash Bag akan dimasukkan ke tong."
	)

	_set_continue_button_visible(false)

	visible = true

func _show_processing_info() -> void:
	_set_all_trash_highlight(false)

	current_target = null
	current_world_target = null

	dim_overlay.visible = false
	highlight.visible = false

	title_label.text = "Proses Pengolahan"

	description_label.text = (
		"Sampah sedang diproses.\n\n"
		+ "Tunggu 10 detik sampai Result Sampah selesai dibuat."
	)

	_set_continue_button_visible(false)

	visible = true


func _show_take_result_tutorial() -> void:
	current_target = null
	current_world_target = null

	dim_overlay.visible = false
	highlight.visible = false
	title_label.text = "Ambil Result Sampah"

	description_label.text = (
		"Result Sampah sudah selesai diproses.\n\n"
		+ "Klik kiri 2 kali pada Result Sampah "
		+ "untuk memasukkannya ke Inventory."
	)

	_set_continue_button_visible(false)

	visible = true

func _show_inventory_tutorial() -> void:
	var target := get_tree().get_first_node_in_group(
		"tutorial_inventory_button"
	) as Control

	if target == null:
		push_error(
			"TutorialUI: InventoryButton tidak ditemukan."
		)
		return

	current_world_target = null
	current_target = target

	dim_overlay.visible = true
	highlight.visible = true

	title_label.text = "Inventory"

	description_label.text = (
		"Result Sampah yang kamu ambil "
		+ "disimpan di Inventory.\n\n"
		+ "Buka Inventory untuk melihat Result Sampah."
	)

	_set_continue_button_visible(false)

	visible = true

	_update_target_visuals()

func _is_any_result_available() -> bool:
	var tong_menus := get_tree().get_nodes_in_group(
		"tong_sampah_menu"
	)

	for tong_menu in tong_menus:
		if tong_menu == null:
			continue

		if not is_instance_valid(tong_menu):
			continue

		if not tong_menu.has_method(
			"has_result_available"
		):
			continue

		if tong_menu.has_result_available():
			return true

	return false

func _show_inventory_menu_tutorial() -> void:
	var target := get_tree().get_first_node_in_group(
		"tutorial_inventory_menu"
	) as Control

	if target == null:
		push_error(
			"TutorialUI: InventoryMenu dengan group "
			+ "tutorial_inventory_menu tidak ditemukan."
		)
		return

	current_world_target = null
	current_target = target

	dim_overlay.visible = true
	highlight.visible = true

	title_label.text = "Inventory"

	description_label.text = (
		"Di Inventory, kamu dapat melihat Result Sampah "
		+ "yang sudah kamu ambil.\n\n"
		+ "Tutup Inventory untuk melanjutkan."
	)

	_set_continue_button_visible(false)

	visible = true

	_update_target_visuals()

func _show_go_to_prakasa_tutorial() -> void:
	var target := get_tree().get_first_node_in_group(
		"tutorial_prakasa"
	) as Node2D

	if target == null:
		push_error(
			"TutorialUI: PrakasaBuya dengan group "
			+ "tutorial_prakasa tidak ditemukan."
		)
		return

	current_target = null
	current_world_target = target

	# Jangan gelapkan gameplay.
	dim_overlay.visible = false
	highlight.visible = false

	title_label.text = "Prakasa Buya"

	description_label.text = (
		"Pergi ke Prakasa Buya untuk menjual Result Sampah.\n\n"
		+ "Tekan E saat berada di dekat Prakasa Buya."
	)

	_set_continue_button_visible(false)

	visible = true

	_update_world_target_visuals()

func _show_sell_menu_tutorial() -> void:
	var target := get_tree().get_first_node_in_group(
		"tutorial_sell_menu"
	) as Control

	if target == null:
		push_error(
			"TutorialUI: SellMenu tidak ditemukan."
		)
		return

	current_world_target = null
	current_target = target

	dim_overlay.visible = true
	highlight.visible = true

	title_label.text = "Sell Menu"

	description_label.text = (
		"Di Sell Menu, kamu dapat menjual Result Sampah "
		+ "kepada Prakasa Buya.\n\n"
		+ "Tekan JUAL untuk menjual Result Sampah."
	)

	_set_continue_button_visible(false)

	visible = true

	_update_target_visuals()

func _show_sell_result_tutorial() -> void:
	current_target = null
	current_world_target = null

	dim_overlay.visible = false
	highlight.visible = false

	title_label.text = "Jual Result Sampah"

	description_label.text = (
		"Tekan tombol JUAL pada Result Sampah yang kamu miliki.\n\n"
		+ "Setelah dijual, jumlah Result Sampah akan berkurang "
		+ "dan Coin akan bertambah."
	)

	_set_continue_button_visible(false)

	visible = true

func _on_tutorial_finished() -> void:
	print("[TutorialUI] Menutup tutorial.")

	current_target = null
	current_world_target = null

	dim_overlay.visible = false
	highlight.visible = false

	visible = false
