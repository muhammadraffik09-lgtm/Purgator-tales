extends Node2D

const MAX_TRASH_ON_MAP := 100
const MAX_RESPAWN_PER_BATCH := 25
const RESPAWN_INTERVAL := 30.0

const ORGANIC_CHANCE := 0.40
const INORGANIC_CHANCE := 0.40

const SPAWN_ATTEMPTS_PER_TRASH := 30
const TRASH_COLLISION_RADIUS := 16.0

@export var trash_scene: PackedScene
@export var spawn_area: Area2D
@export_flags_2d_physics var blocked_collision_mask: int = 1

@onready var trash_items: Node2D = $TrashItems

var rng := RandomNumberGenerator.new()
var respawn_timer: Timer


func _ready() -> void:
	rng.randomize()
	_create_respawn_timer()
	_spawn_trash_batch(MAX_TRASH_ON_MAP)


func _create_respawn_timer() -> void:
	respawn_timer = Timer.new()
	respawn_timer.wait_time = RESPAWN_INTERVAL
	respawn_timer.one_shot = false

	add_child(respawn_timer)

	respawn_timer.timeout.connect(_on_respawn_timer_timeout)
	respawn_timer.start()


func _on_respawn_timer_timeout() -> void:
	var current_count := trash_items.get_child_count()

	if current_count >= MAX_TRASH_ON_MAP:
		return

	var available_space := MAX_TRASH_ON_MAP - current_count

	var amount_to_spawn := mini(
		MAX_RESPAWN_PER_BATCH,
		available_space
	)

	_spawn_trash_batch(amount_to_spawn)


func _spawn_trash_batch(amount: int) -> void:
	if trash_scene == null:
		push_error("TrashSpawner: Trash Scene belum diisi.")
		return

	var spawned := 0

	for i in range(amount):
		var spawn_position: Variant = _find_valid_spawn_position()

		if spawn_position == null:
			print("Tidak menemukan posisi spawn valid.")
			continue

		_spawn_trash(spawn_position)
		spawned += 1

	print(
		"Respawn sampah: +",
		spawned,
		" | Total di map: ",
		trash_items.get_child_count()
	)


func _spawn_trash(spawn_position: Vector2) -> void:
	var trash = trash_scene.instantiate()

	var trash_type: String = _get_random_trash_type()
	var trash_id: String = _get_random_trash_id(trash_type)

	trash.trash_type = trash_type
	trash.trash_id = trash_id

	trash_items.add_child(trash)
	trash.global_position = spawn_position


func _get_random_trash_type() -> String:
	var roll := rng.randf()

	if roll < ORGANIC_CHANCE:
		return "Organik"

	if roll < ORGANIC_CHANCE + INORGANIC_CHANCE:
		return "Anorganik"

	return "B3"


func _get_random_trash_id(trash_type: String) -> String:
	match trash_type:
		"Organik":
			if rng.randi_range(0, 1) == 0:
				return "Kumpulan Tanah"

			return "Pisang"

		"Anorganik":
			if rng.randi_range(0, 1) == 0:
				return "Botol Plastik"

			return "Kantong Sampah"

		"B3":
			if rng.randi_range(0, 1) == 0:
				return "Baterai"

			return "Jarum Suntik"

	return "Kumpulan Tanah"


func _find_valid_spawn_position() -> Variant:
	if spawn_area == null:
		push_error("TrashSpawner: Spawn Area belum diisi.")
		return null

	var collision_shape := spawn_area.get_node_or_null(
		"CollisionShape2D"
	) as CollisionShape2D

	if collision_shape == null:
		push_error(
			"TrashSpawner: CollisionShape2D tidak ditemukan."
		)
		return null

	var rectangle := collision_shape.shape as RectangleShape2D

	if rectangle == null:
		push_error(
			"TrashSpawner: Shape SpawnArea harus RectangleShape2D."
		)
		return null

	var half_size := rectangle.size / 2.0

	for attempt in range(SPAWN_ATTEMPTS_PER_TRASH):
		var local_position := Vector2(
			rng.randf_range(-half_size.x, half_size.x),
			rng.randf_range(-half_size.y, half_size.y)
		)

		var global_position := collision_shape.to_global(
			local_position
		)

		if _is_spawn_position_valid(global_position):
			return global_position

	return null


func _is_spawn_position_valid(position: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state

	var query := PhysicsShapeQueryParameters2D.new()

	var circle := CircleShape2D.new()
	circle.radius = TRASH_COLLISION_RADIUS

	query.shape = circle
	query.transform = Transform2D(0.0, position)

	query.collision_mask = blocked_collision_mask
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var results := space_state.intersect_shape(query)

	return results.is_empty()
