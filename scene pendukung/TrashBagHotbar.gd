extends TextureButton


const DOUBLE_CLICK_TIME := 400


var last_click_time: int = 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_NONE


func _gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return

	if event.button_index != MOUSE_BUTTON_LEFT:
		return

	if not event.pressed:
		return

	var current_time: int = Time.get_ticks_msec()

	if current_time - last_click_time <= DOUBLE_CLICK_TIME:
		_open_trash_bag()

	last_click_time = current_time


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return

	if not event.pressed:
		return

	if event.echo:
		return

	if event.keycode != KEY_K:
		return

	if not is_hovered():
		return

	_open_trash_bag()


func _open_trash_bag() -> void:
	print("Mencoba membuka Karung Sampah...")

	var trash_bag_menu := get_tree().get_first_node_in_group(
		"trash_bag_menu"
	) as Control

	if trash_bag_menu == null:
		push_error(
			"TrashBagHotbar: TrashBagMenu tidak ditemukan!"
		)
		return
	
	AudioManager.play_ui_click()
	trash_bag_menu.visible = true

	print("TrashBagMenu BERHASIL dibuka.")
