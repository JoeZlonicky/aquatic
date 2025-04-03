shader_type canvas_item;

instance uniform vec4 filled_color: source_color = vec4(1.0);
instance uniform vec4 unfilled_color: source_color = vec4(vec3(0.0), 1.0);

instance uniform float outer_radius = 50.f;
instance uniform float inner_radius = 25.f;
instance uniform float fill_span_rad : hint_range(0.f, 6.283185307179586f)  = 6.283185307179586f;
instance uniform float fill_span_offset_rad : hint_range(0.f, 6.283185307179586f) = 0.f;
instance uniform float fill_ratio : hint_range(0.f, 1.f) = 1.f;

bool is_in_radius(float dist) {
	return dist < outer_radius && dist > inner_radius;
}

float calc_ratio(float angle) {
	angle += fill_span_offset_rad;
	if (angle < 0.f) {
		angle += TAU;
	} else if (angle > TAU) {
		angle -= TAU;
	}
	float ratio = angle / fill_span_rad;
	return ratio;
}

bool is_in_span(float ratio) {
	return ratio >= 0.0 && ratio <= 1.0;
}

bool is_filled(float ratio) {
	return ratio < fill_ratio;
}

void fragment() {
	vec2 uv = 2.f * UV - vec2(1.f);
	vec2 pos = uv / TEXTURE_PIXEL_SIZE;
	vec2 center = vec2(0.f);
	float dist = distance(pos, center);
	float angle = atan(pos.y, pos.x);
	float ratio = calc_ratio(angle);

	if (is_in_radius(dist) && is_in_span(ratio)) {
		if (is_filled(ratio)) {
			COLOR = filled_color;
		} else {
			COLOR = unfilled_color;
		}
	} else {
		COLOR = vec4(0.f);
	}
}