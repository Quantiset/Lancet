shader_type canvas_item;

uniform float ring_width = 0.025;
uniform float ring_rad = 0.3;

void fragment() {
	float l = length(UV - vec2(0.5));
	float a = 0.;
	if (l > ring_rad - ring_width && l < ring_rad + ring_width) {
		a = 1.;
	}
	COLOR = vec4(vec3(1.), a);
}
