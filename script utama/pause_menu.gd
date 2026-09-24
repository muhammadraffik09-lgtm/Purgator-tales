extends Control

@onready var button_container: VBoxContainer = $Panel/VBoxContainer

var buttons: Array[BaseButton] = []
var current_index: int = 0


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Ambil semua button dari VBoxContainer
	for child in button_container.get_children():
		if child is BaseButton:
			buttons.append(child)

	# Aktifkan focus
	for i in range(buttons.size()):
		var button = buttons[i]

		button.focus_mode = Control.FOCUS_ALL

		button.mouse_entered.connect(
			_on_button_mouse_entered.bind(i)
		)

		button.focus_entered.connect(
			_on_button_focus_entered.bind(i)
		)


func _input(event):
	if not visible:
		return

	# PgUp
	if event.is_action_pressed("pause_menu_up"):
		_select_previous()
		get_viewport().set_input_as_handled()
		return

	# PgDn
	if event.is_action_pressed("pause_menu_down"):
		_select_next()
		get_viewport().set_input_as_handled()
		return


func _select_previous():
	if buttons.is_empty():
		return

	current_index -= 1

	if current_index < 0:
		current_index = buttons.size() - 1

	buttons[current_index].grab_focus()


func _select_next():
	if buttons.is_empty():
		return

	current_index += 1

	if current_index >= buttons.size():
		current_index = 0

	buttons[current_index].grab_focus()


func select_first_button():
	if buttons.is_empty():
		return

	current_index = 0
	buttons[current_index].grab_focus()


func _on_button_mouse_entered(index: int):
	current_index = index


func _on_button_focus_entered(index: int):
	current_index = index
