extends TextureButton

var tong_menu: Control
var slot_index: int = -1


func setup(menu: Control, index: int) -> void:
	tong_menu = menu
	slot_index = index


func _pressed() -> void:
	if tong_menu == null:
		return

	if slot_index < 0:
		return

	if not tong_menu.has_method("take_result"):
		return

	var berhasil: bool = tong_menu.take_result(slot_index)

	if not berhasil:
		print("Hasil tidak dapat diambil.")
