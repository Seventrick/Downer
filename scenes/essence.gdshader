shader_type spatial;

render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx, unshaded;

group_uniforms wind;
uniform sampler2D noise_tex;
uniform float wind_speed = .1;
uniform float wind_strength = .01;

uniform sampler2D noise_tex2;
uniform vec2 scroll = vec2(0.05, 0.05);
uniform vec2 scroll2 = vec2(0.025, 0.025);

void vertex() {
	vec3 GLOBAL_VERTEX = (MODEL_MATRIX * vec4(VERTEX, 1.)).xyz;
 
	float offset = TIME * wind_speed;
	float noise = texture(noise_tex, vec2(GLOBAL_VERTEX.x-offset)).r;
	noise -= 1.0;
	noise *= wind_strength;
	VERTEX.xy += noise * length(VERTEX.y) * length(VERTEX.xz);
	
	VERTEX.y += sin(TIME) * 0.1;
}

void fragment() {
	vec4 noise_col = texture(noise_tex2, UV + scroll * TIME);
	vec4 noise_col2 = texture(noise_tex2, UV + scroll2 * TIME);
	float noise_val = noise_col.z * noise_col2.z;
	
	ALBEDO = vec3(0.9,0.15,0.02);
	ALPHA = noise_val;
	
	
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
