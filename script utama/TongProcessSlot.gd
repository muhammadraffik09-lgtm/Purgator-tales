extends TextureButton


var tong_menu: Control = null
var slot_index: int = -1


func setup(menu: Control, index: int) -> void:
	tong_menu = menu
	slot_index = index


func _can_drop_data(
	_at_position: Vector2,
	data: Variant
) -> bool:

	if tong_menu == null:
		return false

	if slot_index < 0:
		return false

	if typeof(data) != TYPE_DICTIONARY:
		return false

	if not data.has("trash_id"):
		return false

	if not data.has("trash_type"):
		return false

	if not tong_menu.has_method("can_accept_trash"):
		return false

	return tong_menu.can_accept_trash(
		data["trash_type"]
	)


func _drop_data(
	_at_position: Vector2,
	data: Variant
) -> void:

	if tong_menu == null:
		return

	if typeof(data) != TYPE_DICTIONARY:
		return

	if not data.has("trash_id"):
		return

	if not data.has("trash_type"):
		return

	if not tong_menu.has_method("receive_trash"):
		return

	tong_menu.receive_trash(
		data,
		slot_index
	)
