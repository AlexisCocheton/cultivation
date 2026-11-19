shader_type canvas_item;
uniform bool customize = false;
uniform vec4 robe_color : source_color;
uniform vec4 skin_color : source_color;
uniform vec4 hair_color : source_color;
varying vec4 actor_tint;
void vertex() {
    actor_tint = COLOR;
}
void fragment() {
    vec4 c = texture(TEXTURE, UV);
    vec2 cell = fract(UV * 4.0);
    if (customize) {
        float light = dot(c.rgb, vec3(0.299,0.587,0.114));
        // Jade fabric, excluding skin and the white under-robe.
        if (c.g > c.r * 0.99 && c.g > c.b * 1.05 && cell.y > 0.18) {
            c.rgb = mix(c.rgb, robe_color.rgb * (light / 0.63), 0.82);
        }
        if (cell.y < 0.22 && c.r > c.g * 1.10 && c.g > c.b * 1.08 && light > 0.38) {
            c.rgb *= skin_color.rgb / vec3(0.90,0.73,0.59);
        }
        if (cell.y < 0.30 && light < 0.30 && c.a > 0.5) {
            c.rgb = mix(c.rgb, hair_color.rgb * (0.6 + light), 0.65);
        }
    }
    COLOR = c * actor_tint;
}
