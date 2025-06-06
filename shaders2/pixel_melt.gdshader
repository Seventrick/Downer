shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
// Animate from 0 to 1
uniform float progress: hint_range(0.0, 1.0) = 0.0;

// How jagged each band of melting pixels are
uniform float meltiness: hint_range(0.0, 16.0) = 1.0;

float psuedo_rand(float x) {
	return mod(x * 2048103.0 + cos(x * 1912.0), 1.0);
}

void fragment() {
	COLOR = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec2 uv = UV;

	// Move pixels near the top faster
	uv.y -= progress / UV.y;

	// Created jagged edges for each pixel on the x-axis
	uv.y -= progress * meltiness * psuedo_rand(UV.x - mod(UV.x, TEXTURE_PIXEL_SIZE.x));

	COLOR = texture(TEXTURE, uv);

	// "delete" pixels out of range
	if (uv.y <= 0.0) {
		COLOR.a = 0.0;
	}
}
