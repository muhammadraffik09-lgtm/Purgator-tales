extends Area2D

@onready var timer: Timer = $Timer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hide()
		collision_shape.set_deferred("disabled", true)
		timer.start() # Jalankan timer

func _on_timer_timeout() -> void:
	show()
	collision_shape.set_deferred("disabled", false)
