shader_type canvas_item;
uniform vec2 tilt = vec2(0.0);
uniform float sheen = 0.0;
void vertex() {
 vec2 pivot = vec2(97.0,105.0);
 vec3 p = vec3(VERTEX-pivot,0.0);
 float cy=cos(tilt.x), sy=sin(tilt.x), cx=cos(tilt.y), sx=sin(tilt.y);
 p = vec3(p.x*cy,p.y,-p.x*sy);
 p = vec3(p.x,p.y*cx-p.z*sx,p.y*sx+p.z*cx);
 VERTEX = pivot+p.xy*(650.0/(650.0-p.z));
}
void fragment() {
 vec4 c=texture(TEXTURE,UV);
 float light = pow(max(0.0,1.0-abs(UV.x-(0.5+tilt.x))*2.0),5.0)*sheen;
 COLOR.rgb += vec3(light)*COLOR.a;
}
