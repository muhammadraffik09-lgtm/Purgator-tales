extends Area2D


@export_enum("Organik", "Anorganik", "B3")
var trash_type: String = "Organik"


var player_in_range: bool = false
var player: Node2D = null

var interaction_prompt: Control = null


@onready var interaction_area: Area2D = $InteractionArea


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	interaction_area.body_entered.connect(
		_on_interaction_body_entered
	)

	interaction_area.body_exited.connect(
		_on_interaction_body_exited
	)

	interaction_prompt = get_tree().get_first_node_in_group(
		"interaction_prompt"
	)

	if interaction_prompt == null:
		push_error(
			"TongSampah: InteractionPrompt tidak ditemukan."
		)


func _on_interaction_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	player = body
	player_in_range = true

	_show_interaction_prompt()

	print(
		"Player masuk area Tong: ",
		trash_type
	)


func _on_interaction_body_exited(body: Node2D) -> void:
	if body != player:
		return

	player = null
	player_in_range = false

	_hide_interaction_prompt()

	print(
		"Player keluar area Tong: ",
		trash_type
	)


func _show_interaction_prompt() -> void:
	if interaction_prompt == null:
		return

	if interaction_prompt.has_method("show_interaction"):
		interaction_prompt.show_interaction(
			"Tekan E untuk menggunakan Tong"
		)


func _hide_interaction_prompt() -> void:
	if interaction_prompt == null:
		return

	if interaction_prompt.has_method("hide_interaction"):
		interaction_prompt.hide_interaction()


func _unhandled_input(event: InputEvent) -> void:
	if not player_in_range:
		return

	if not event.pressed:
		return

	if event.is_echo():
		return

	if event.keycode != KEY_E:
		return

	_open_tong_menu()


func _open_tong_menu() -> void:
	var tong_menu: Control = null

	match trash_type:
		"Organik":
			tong_menu = get_tree().get_first_node_in_group(
				"tong_organik_menu"
			)

		"Anorganik":
			tong_menu = get_tree().get_first_node_in_group(
				"tong_anorganik_menu"
			)

		"B3":
			tong_menu = get_tree().get_first_node_in_group(
				"tong_b3_menu"
			)

	if tong_menu == null:
		push_error(
			"TongSampah: Menu untuk "
			+ trash_type
			+ " tidak ditemukan."
		)
		return

	if not tong_menu.has_method("setup_bin"):
		push_error(
			"TongSampah: Menu "
			+ trash_type
			+ " tidak memiliki fungsi setup_bin()."
		)
		return

	tong_menu.setup_bin(trash_type, self)
	tong_menu.visible = true

	_hide_interaction_prompt()

	print(
		"Menu Tong dibuka: ",
		trash_type
	)
	_hide_interaction_prompt()

func show_prompt_again() -> void:
	if not player_in_range:
		return

	_show_interaction_prompt()
