shader_type canvas_item;
uniform sampler2D base_plate : source_color, filter_linear;
uniform vec4 variant_region = vec4(0.0);
uniform float breeze_time = 0.0;
uniform float motion_amount = 1.0;
varying vec4 canvas_tint;
void vertex() { canvas_tint = COLOR; }
void fragment() {
    vec2 uv = UV;
    // Only outer foliage moves: face, hands, sword, cup and architecture stay anchored.
    float canopy = (1.0-smoothstep(0.09,0.17,uv.y)) * (1.0-smoothstep(0.49,0.59,uv.x));
    float bamboo = smoothstep(0.72,0.88,uv.x)*(1.0-smoothstep(0.18,0.29,uv.y));
    float flowers = smoothstep(0.79,0.91,uv.x)*smoothstep(0.64,0.79,uv.y);
    float mask = max(canopy,max(bamboo,flowers));
    float wave = sin(breeze_time*0.78+uv.y*11.0)+0.3*sin(breeze_time*1.31+uv.x*17.0);
    uv.x += mask*wave*0.0017*motion_amount;
    uv.y += mask*sin(breeze_time*0.9+uv.x*12.0)*0.0008*motion_amount;
    vec2 edge = vec2(0.006);
    vec2 lower = smoothstep(variant_region.xy,variant_region.xy+edge,uv);
    vec2 upper = 1.0-smoothstep(variant_region.zw-edge,variant_region.zw,uv);
    float mask_variant = lower.x*lower.y*upper.x*upper.y;
    COLOR = mix(texture(base_plate,uv),texture(TEXTURE,uv),mask_variant)*canvas_tint;
}
