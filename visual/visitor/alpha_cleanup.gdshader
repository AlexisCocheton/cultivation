shader_type canvas_item;
// Generated cutouts retain near-transparent matte pixels (alpha 1–2/255).
// Reject only that residue; preserve the painted silhouette and soft edges.
void fragment() {
	if (texture(TEXTURE, UV).a < 0.02) discard;
}
