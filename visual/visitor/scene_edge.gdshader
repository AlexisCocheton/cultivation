shader_type canvas_item;
varying vec2 panel_uv;
uniform vec2 panel_size = vec2(780.0,635.0);
void vertex() {
	panel_uv = VERTEX / panel_size;
}
void fragment() {
	vec4 paint = texture(TEXTURE,UV) * COLOR;
	float edge = smoothstep(0.0,0.07,panel_uv.x) * smoothstep(0.0,0.10,1.0-panel_uv.x);
	edge *= smoothstep(0.0,0.06,panel_uv.y) * smoothstep(0.0,0.07,1.0-panel_uv.y);
	COLOR = vec4(paint.rgb,paint.a*edge);
}
