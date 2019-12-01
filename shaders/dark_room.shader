shader_type canvas_item;

uniform vec4 color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float blackness : hint_range(0.0, 2.0);


float lerp(float a, float b, float t) {
	return a + (b - a) * t;
}


float blend(float t_a, float t_b, float weight) {
	return (1.0 - weight) * t_a + weight * t_b;
}

void fragment() {
	
	vec2 pos = UV;
	vec4 col = color;
	float cutoff = 0.4;
	pos.x = pos.x - 0.5;
	pos.y = pos.y - 0.5;
	
	float rad = (pos.x * pos.x) + (pos.y * pos.y);
	
	col.a = 1.2 * blackness;
	if (rad < cutoff * cutoff) {
		col.a = lerp(0.9, 0.98, rad / (cutoff * cutoff)) * blackness;
	}
	

	COLOR = col;
}
