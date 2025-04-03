shader_type canvas_item;

uniform sampler2D refraction_map;

uniform vec2 refraction_stretch = vec2(1.0, 1.0);
uniform float refraction_strength : hint_range(0.0, 0.1) = 0.02;

uniform float speed : hint_range(0.0, 1.0) = 0.1;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

varying flat vec4 modulate;
varying vec2 globalposition;

void vertex(){
	globalposition = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	modulate = COLOR;
}

void fragment()
{
	vec2 uv = globalposition / 512.0;

	vec2 refraction_offset = textureLod(
		refraction_map,
		vec2(
			mod(uv.x * refraction_stretch.x + TIME * speed, 1.0),
			mod(uv.y * refraction_stretch.y + TIME * speed, 1.0)), 0.0).xy;
	// Set values between -0.5 and 0.5 (instead of 0 and 1). Otherwise the reflection will move whith increased refraction_strength
	refraction_offset -= 0.5;

	// Get the screen texture and distort it
	vec4 refraction = textureLod(SCREEN_TEXTURE, SCREEN_UV - refraction_offset * refraction_strength, 0.0);

	vec4 color = vec4(1.0);

	color.rgb = mix(refraction.rgb, modulate.rgb, modulate.a);
	COLOR = color;
}