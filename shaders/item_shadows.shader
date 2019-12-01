shader_type canvas_item;

uniform vec2 spot = vec2(0.0, 0.0);
uniform float size = 1.0;

uniform float vertical_radio = 0.05;
uniform float horizontal_radio = 0.06;

uniform vec4 color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	

	float vradio = vertical_radio * size * 0.5;
	float hradio = horizontal_radio * size * 0.5;
	vec4 col = texture(TEXTURE, UV);
	vec2 point = spot - UV;
	
	float ellipsis = (point.x * point.x) / (hradio * hradio) + (point.y * point.y) / (vradio * vradio);
	
	if (ellipsis <= 1.0 && col.a > 0.0) {
		col = color;
	}

	
	COLOR = col;
}


/*
shader_type canvas_item;
render_mode unshaded;

uniform float cutoff: hint_range(0.0, 1.0);

float lerp(float a, float b, float t) {
	return (b - a) * t;
}

void fragment() {
	vec2 pos = SCREEN_UV;
	float blur_fact = lerp(0.0, 0.8, cutoff * cutoff);
	vec4 col = texture(SCREEN_TEXTURE, pos, blur_fact);
	float fact = 0.0;
	

	pos.x = 1.0 - abs(pos.x - 0.5);
	pos.y = 1.0 - abs(pos.y - 0.5);
	fact = ((1.0 - ((1.0 - pos.x) * (1.0 - pos.x))) + pos.y) / 2.0;
	
	if (fact < cutoff) {
		float t = fact / (cutoff + 0.01);
		float gray = lerp(0.0, 0.05, t * t * t * t * t * t *t);
		COLOR = vec4(gray, gray, gray, 1.0);
	}
	else {
		COLOR = col;
	}

*/