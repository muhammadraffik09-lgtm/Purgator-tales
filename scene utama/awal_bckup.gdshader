shader_type canvas_item;

uniform vec2 hole_position = vec2(0.5, 0.5);
uniform vec2 hole_size = vec2(0.1, 0.1);
uniform float darkness : hint_range(0.0, 1.0) = 0.65;
uniform float softness : hint_range(0.001, 0.1) = 0.01;

void fragment() {
	vec2 distance_from_center = abs(UV - hole_position);
	vec2 half_size = hole_size * 0.5;

	float dx = smoothstep(
		half_size.x,
		half_size.x + softness,
		distance_from_center.x
	);

	float dy = smoothstep(
		half_size.y,
		half_size.y + softness,
		distance_from_center.y
	);

	float outside_hole = max(dx, dy);

	COLOR = vec4(
		0.0,
		0.0,
		0.0,
		darkness * outside_hole
	);
}