shader_type canvas_item;
float hash(vec2 p) { return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453); }
void fragment() {
	vec4 ink = texture(TEXTURE,UV) * COLOR;
	float grain = hash(FRAGCOORD.xy) * 0.025;
	float wash = sin(UV.x*37.0+sin(UV.y*17.0))*0.006;
	COLOR = vec4(mix(ink.rgb,vec3(0.97,0.94,0.86),0.60) - grain * 0.3 + wash,ink.a);
}
