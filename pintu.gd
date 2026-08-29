extends Area2D


var is_player_near = false
@export var inside_house_scene : String = "res://Living_room.tscn" 

func _on_body_entered(body):
	if body.is_in_group("player"):
		is_player_near = true
		print("Tekan Backspace untuk masuk")

func _on_body_exited(body):
	if body.is_in_group("player"):
		is_player_near = false # Sudah diperbaiki menjadi false

func _process(_delta):
	# Spasi di akhir "buka_pintu" sudah dihapus
	if is_player_near and Input.is_action_just_pressed("masuk"):
		get_tree().change_scene_to_file(inside_house_scene)
