shader_type canvas_item;
void fragment() {
	vec4 paint = texture(TEXTURE,UV);
	COLOR = vec4(vec3(0.23,0.32,0.23) * (0.8+paint.r*0.3),paint.a);
}
