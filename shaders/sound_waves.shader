


shader_type canvas_item;
render_mode unshaded;

uniform float cutoff: hint_range(0.0, 1.0);
uniform float border_size: hint_range(0.0, 0.3);
uniform float screen_width = 320.0;
uniform float screen_height = 180.0;
uniform vec4 color: hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float top_margin: hint_range(0.0, 1.0) = 0.0;
uniform float bottom_margin: hint_range(0.0, 1.0) = 0.0;
uniform float left_margin: hint_range(0.0, 1.0) = 0.0;
uniform float right_margin: hint_range(0.0, 1.0) = 0.0;

float lerp(float a, float b, float t) {
	return (b - a) * t;
}

void fragment() {
	vec2 pos = UV;
	vec2 pos_uv = pos;

	vec4 col = color;
	float fact = 0.0;
	float cutoff_squared = (1.0 - cutoff) * (1.0 - cutoff);
	float ratio = screen_width / screen_height;
	float border_squared = border_size * border_size;

	pos.x = (pos.x - 0.5) * ratio;
	pos.y = pos.y - 0.5;
	fact = (pos.x * pos.x) + (pos.y * pos.y);


	if ((pos_uv.y < top_margin) || (pos_uv.y > (1.0 - bottom_margin)) || 
		(pos_uv.x < left_margin) || (pos_uv.x > (1.0 - right_margin))) {
		// Outside of the margins is transparent
		COLOR = vec4(1.0, 1.0, 1.0, 0.0);
	}
	else {
		
		if ( (top_margin > 0.0 && (pos_uv.y < top_margin + border_squared)) ||
			 (bottom_margin > 0.0 && ( (1.0 - pos_uv.y) < bottom_margin + border_squared)) ||
			 (left_margin > 0.0 && (pos_uv.x < left_margin + border_squared)) ||
			 (right_margin > 0.0 && ( (1.0 - pos_uv.x) < right_margin + border_squared))) {
			// Inside border of the margins is painted if inside of the circle

			if ( fact < cutoff_squared )
				COLOR = col;
			else
				COLOR = vec4(1.0, 1.0, 1.0, 0.0);

		}
		else {
			
			if (border_size < 0.001) {
			// If border is too small, don't paint anything (it bugs out)

				COLOR = vec4(1.0, 1.0, 1.0, 0.0);
			}
			else if (fact > cutoff_squared || fact < (cutoff_squared - border_squared)) {
				// If outside of circle, don't paint anything
				COLOR = vec4(1.0, 1.0, 1.0, 0.0);
			}
			else {
				// Else (if inside cirlce) do!

				COLOR = col;
			}		
		}
	}


}
