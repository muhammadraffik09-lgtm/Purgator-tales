extends Area2D

var player_in_range: bool = false
var player: Node2D = null
var interaction_prompt: Control = null
var sell_menu: Control = null

@onready var interaction_area: Area2D = $InteractionArea


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	interaction_area.body_entered.connect(_on_interaction_body_entered)
	interaction_area.body_exited.connect(_on_interaction_body_exited)

	interaction_prompt = get_tree().get_first_node_in_group("interaction_prompt")
	sell_menu = get_tree().get_first_node_in_group("sell_menu")

	if interaction_prompt == null:
		push_error("PrakasaBuya: InteractionPrompt tidak ditemukan.")

	if sell_menu == null:
		push_error("PrakasaBuya: SellMenu tidak ditemukan.")


func _on_interaction_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	player = body
	player_in_range = true

	_show_interaction_prompt()

	print("Player masuk area Prakasa Buya.")


func _on_interaction_body_exited(body: Node2D) -> void:
	if body != player:
		return

	player = null
	player_in_range = false

	_hide_interaction_prompt()

	print("Player keluar area Prakasa Buya.")


func _show_interaction_prompt() -> void:
	if interaction_prompt == null:
		return

	if interaction_prompt.has_method("show_interaction"):
		interaction_prompt.show_interaction(
			"Tekan E untuk menjual hasil olahan"
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

	_open_sell_menu()


func _open_sell_menu() -> void:
	if sell_menu == null:
		push_error("PrakasaBuya: SellMenu tidak ditemukan.")
		return

	sell_menu.visible = true

	_hide_interaction_prompt()

	AudioManager.play_ui_click()

	print("SellMenu dibuka oleh Prakasa Buya.")
