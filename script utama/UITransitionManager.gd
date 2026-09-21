extends Node

const MENU_COOLDOWN := 1.0

var can_transition: bool = true


func try_transition() -> bool:
	if not can_transition:
		return false

	can_transition = false
	_start_cooldown()

	return true


func _start_cooldown():
	await get_tree().create_timer(MENU_COOLDOWN, true).timeout
	can_transition = true
