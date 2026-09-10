extends Area2D

var speed: float = 100.0
var target_marker: Node2D

func _physics_process(delta: float) -> void:
	# Cari marker jika belum ketemu
	if not is_instance_valid(target_marker):
		target_marker = get_tree().get_first_node_in_group("anjing_target")
		return
	print("Status Target Marker: ", target_marker)
	var marker_pos: Vector2 = target_marker.global_position
	
	# Bergerak mendekati marker jika jaraknya lebih dari 15 piksel
	if global_position.distance_to(marker_pos) > 15.0:
		var direction: Vector2 = global_position.direction_to(marker_pos)
		global_position += direction * speed * delta
