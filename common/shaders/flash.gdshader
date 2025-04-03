shader_type canvas_item;

instance uniform vec3 flash_color: source_color = vec3(1.f);
instance uniform float flash_strength: hint_range(0.0, 1.0) = 0.f;

varying flat vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec4 color = texture(TEXTURE, UV) * modulate;
	vec3 mixed = mix(color.rgb, flash_color, flash_strength);
	COLOR = vec4(mixed, color.a);
}