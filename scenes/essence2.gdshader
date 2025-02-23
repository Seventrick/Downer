shader_type spatial;

render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx, unshaded;

group_uniforms wind;
uniform sampler2D noise_tex;
uniform float wind_speed = .1;
uniform float wind_strength = .01;


void vertex() {
	vec3 GLOBAL_VERTEX = (MODEL_MATRIX * vec4(VERTEX, 1.)).xyz;
 
	float offset = TIME * wind_speed;
	float noise = texture(noise_tex, vec2(GLOBAL_VERTEX.x-offset)).r;
	noise -= .5;
	noise *= wind_strength;
	VERTEX.xz += noise * length(VERTEX.y) * length(VERTEX.xy);
	
	VERTEX.y += sin(TIME) * 0.07;
}

void fragment() {
	ALBEDO = vec3(0.8,0.4,0.2);
	ALPHA = 0.7;
}
