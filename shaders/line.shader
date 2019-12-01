


shader_type canvas_item;
render_mode unshaded;

uniform vec4 color: hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float line_width = 0.5;
uniform float line_length = 10.0;
uniform int segment_size = 8;

float lerp(float a, float b, float t) {
	return a + (b - a) * t;
}

void fragment() {
	vec2 pos = UV;
	float final_width = line_width;
	vec4 col = color;

	int x = int(pos.x * line_length);

	if (x % segment_size == 0) {
		col = vec4(1.0, 1.0, 1.0, 0.0);
	}
	

	if (pos.x > 0.65) {
		float t = (pos.x - 0.65) / 0.35;
		final_width = lerp(final_width, 0.0, t*t);
	}

	if (pos.x < 0.25) {
		float t = abs(pos.x - 0.25) / 0.25;
		final_width = lerp(final_width, 0.0, t*t*t*t*t*t);
	}


	if (abs(pos.y - 0.5) * 2.0 >= final_width) {
		col = vec4(1.0, 1.0, 1.0, 0.0);
	}

	COLOR = col;

}
