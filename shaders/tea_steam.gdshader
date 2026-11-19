shader_type canvas_item;
uniform float steam_time = 0.0;
uniform float strength = 1.0;
void fragment() {
    vec2 p = UV;
    float height = 1.0-p.y;
    float density = 0.0;
    for (int i=0;i<3;i++) {
        float phase = float(i)*2.094;
        float center = 0.5 + sin(height*8.0-steam_time*0.75+phase)*height*0.14 + sin(height*16.0-steam_time*1.2+phase)*0.035;
        float width = mix(0.018,0.07,height);
        float ribbon = exp(-pow((p.x-center)/width,2.0));
        float pulse = 0.55+0.45*sin(height*10.0-steam_time*1.3+phase);
        density += ribbon*pulse;
    }
    float fade = smoothstep(0.0,0.13,height)*(1.0-smoothstep(0.52,1.0,height));
    COLOR = vec4(vec3(1.0,0.95,0.85),density*fade*0.17*strength);
}
