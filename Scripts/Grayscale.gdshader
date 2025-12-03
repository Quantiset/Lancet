shader_type canvas_item;

uniform bool enabled = false;
uniform bool turn_red = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	if (enabled) {
		col = vec4(vec3(length(col.rgb) * 0.7), 1.0);
	}
	if (turn_red) {
		col = vec4(col.g, col.r, col.b, col.a);
	}
	COLOR = col;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
