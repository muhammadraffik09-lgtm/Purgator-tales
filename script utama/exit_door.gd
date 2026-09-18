extends Area2D

var is_player_near = false
@export var outside_house_scene : String = "res://awal_bckup.tscn"

func _on_body_entered(body):
	if body.is_in_group("player"):
		is_player_near = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		is_player_near = false

func _process(_delta):
	if is_player_near and Input.is_action_just_pressed("keluar"):
		# Beri tahu Global bahwa player baru saja keluar pintu
		Global.is_spawning = true
		get_tree().change_scene_to_file(outside_house_scene)
