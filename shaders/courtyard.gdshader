shader_type canvas_item;
uniform sampler2D restored : source_color, filter_nearest;
uniform vec3 restoration = vec3(0.0);
uniform float wind_time = 0.0;
float box(vec2 p, vec2 a, vec2 b) {
    vec2 lo = smoothstep(a, a + vec2(0.006), p);
    vec2 hi = 1.0 - smoothstep(b - vec2(0.006), b, p);
    return lo.x * lo.y * hi.x * hi.y;
}
void fragment() {
    vec2 uv = UV;
    // Localized UV sway: trunk base and architecture remain anchored.
    float crown = (1.0-smoothstep(0.21,0.29,uv.y)) * (1.0-smoothstep(0.30,0.39,uv.x));
    float gust = sin(wind_time*1.15) + 0.35*sin(wind_time*2.7+uv.y*20.0);
    uv.x += crown * gust * 0.0018;
    uv.y += crown * sin(wind_time*1.4+uv.x*24.0)*0.00075;
    vec4 original = texture(TEXTURE,uv);
    float steps = box(uv,vec2(0.255,0.365),vec2(0.746,0.465));
    float roof = box(uv,vec2(0.255,0.045),vec2(0.785,0.241));
    float facade = box(uv,vec2(0.255,0.229),vec2(0.746,0.395));
    float amount = max(steps*restoration.x,max(roof*restoration.y,facade*restoration.z));
    COLOR = mix(original,texture(restored,uv),amount);
}
