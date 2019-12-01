shader_type canvas_item;

uniform vec4 back_col: hint_color;
uniform float wave_speed: hint_range(0.0, 1.0);

float lerp(float a, float b, float t) {
	return a + (b - a) * t;
}

void fragment() {
	
	float bar_count = 8.0;
	float bar_size = 10.0;
	float freq = 1.5;
	float amp = 0.75;
	
	vec2 pos = UV;
	//vec4 col = texture(TEXTURE, pos);
	vec4 col = back_col;
	pos.x += cos(TIME*wave_speed);
	pos.y += sin(pos.x * 2.0 * 3.1416 * freq) * 0.052525 * amp;
	float t = (1.0 - pos.y);

	float colr_start = col.r;
	float colr_end = col.r * 0.5;
	float colb_start = col.b;
	float colb_end = col.b * 0.75;
	float colg_start = col.g;
	float colg_end = col.g * 0.5;
	
	float factor = floor(lerp(0, bar_count, t)) / bar_count;
	
	
	col.r = lerp(colr_start, colr_end, factor);
	col.b = lerp(colb_start, colb_end, factor);
	col.g = lerp(colg_start, colg_end, factor);
	
	COLOR = col;
}