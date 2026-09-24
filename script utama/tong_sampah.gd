extends Area2D

@export_enum("Organik", "Anorganik", "B3")
var trash_type: String = "Organik"

@export var menu_path: NodePath


func _ready() -> void:
	add_to_group("trash_bin")

func interact() -> void:
	var menu = get_node_or_null(menu_path)

	if menu == null:
		push_error("Menu tong belum dihubungkan.")
		return

	menu.setup_bin(trash_type)
	menu.visible = true
