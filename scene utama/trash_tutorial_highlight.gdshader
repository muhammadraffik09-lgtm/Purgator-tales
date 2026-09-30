shader_type canvas_item;

uniform bool highlight_enabled = false;

uniform vec4 outline_color : source_color = vec4(
	1.0,
	0.85,
	0.2,
	1.0
);

uniform float outline_size : hint_range(1.0, 8.0) = 2.0;

void fragment() {
	vec4 original = texture(TEXTURE, UV);

	vec2 pixel = TEXTURE_PIXEL_SIZE * outline_size;

	float surrounding_alpha = 0.0;

	surrounding_alpha = max(
		surrounding_alpha,
		texture(TEXTURE, UV + vec2(pixel.x, 0.0)).a
	);

	surrounding_alpha = max(
		surrounding_alpha,
		texture(TEXTURE, UV + vec2(-pixel.x, 0.0)).a
	);

	surrounding_alpha = max(
		surrounding_alpha,
		texture(TEXTURE, UV + vec2(0.0, pixel.y)).a
	);

	surrounding_alpha = max(
		surrounding_alpha,
		texture(TEXTURE, UV + vec2(0.0, -pixel.y)).a
	);

	surrounding_alpha = max(
		surrounding_alpha,
		texture(TEXTURE, UV + vec2(pixel.x, pixel.y)).a
	);

	surrounding_alpha = max(
		surrounding_alpha,
		texture(TEXTURE, UV + vec2(-pixel.x, pixel.y)).a
	);

	surrounding_alpha = max(
		surrounding_alpha,
		texture(TEXTURE, UV + vec2(pixel.x, -pixel.y)).a
	);

	surrounding_alpha = max(
		surrounding_alpha,
		texture(TEXTURE, UV + vec2(-pixel.x, -pixel.y)).a
	);

	float outline_alpha = (
		surrounding_alpha
		* (1.0 - original.a)
	);

	vec4 highlighted_result = mix(
		vec4(
			outline_color.rgb,
			outline_color.a * outline_alpha
		),
		original,
		original.a
	);

	COLOR = mix(
		original,
		highlighted_result,
		float(highlight_enabled)
	);
}