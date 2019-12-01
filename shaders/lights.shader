shader_type canvas_item;

float lerp(float a, float b, float t) {
	return a + (b - a) * t;
}
void light() { 
	vec4 c = texture( TEXTURE, UV ).rgba; 
	if( c.r > 0.3 || c.b > 0.7 ) 
	{ 
		//LIGHT *= 1.0; 
		float limit = lerp(0.27, 0.31,( sin(TIME * 30.0) + 1.0)/2.0);
		if( LIGHT.a > limit ) { 
			LIGHT = LIGHT_COLOR * lerp(1.0, 1.4+0.2, LIGHT.a); 
		} else { 
			LIGHT *= 0.0; 
		} 
	} else { 
	LIGHT *= 0.0; 
	} 

}
