shader_type canvas_item;
void fragment(){
 vec4 paint=texture(TEXTURE,UV)*COLOR;
 float edge=smoothstep(0.0,0.07,UV.x)*smoothstep(0.0,0.07,1.0-UV.x)*smoothstep(0.0,0.06,UV.y)*smoothstep(0.0,0.06,1.0-UV.y);
 COLOR=vec4(paint.rgb,paint.a*edge);
}
