shader_type canvas_item;
uniform sampler2D base_plate : source_color, filter_linear;
varying vec4 tint;
void vertex() { tint = COLOR; }
void fragment() {
    vec2 lo = smoothstep(vec2(0.63,0.14),vec2(0.638,0.148),UV);
    vec2 hi = 1.0-smoothstep(vec2(0.792,0.352),vec2(0.80,0.36),UV);
    COLOR = mix(texture(base_plate,UV),texture(TEXTURE,UV),lo.x*lo.y*hi.x*hi.y)*tint;
}
