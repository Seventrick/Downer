shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,unshaded,shadows_disabled,ambient_light_disabled;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color;
uniform float specular;
uniform float metallic;
uniform float alpha_scissor_threshold;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;
uniform float speed = 5.0;
uniform float frequency_uniform = 30.0;

uniform bool is_breath = false;
uniform float breath_speed = 0.368;
uniform float breath_freq = 0.021;


varying float world_vertex_y;
varying float world_vertex_x;
varying float world_vertex_z;

void vertex() {
    UV=UV*uv1_scale.xy+uv1_offset.xy;
    world_vertex_y = VERTEX.y;
    world_vertex_x = VERTEX.x;
    world_vertex_z = VERTEX.z;
}





void fragment() {
	float frequency = frequency_uniform;
	if (is_breath){
		frequency = breath_freq * sin(TIME*breath_speed);
	}


    vec2 base_uv = UV;
    vec4 albedo_tex = texture(texture_albedo,base_uv);
    albedo_tex *= COLOR;
    //ALBEDO = albedo.rgb * albedo_tex.rgb;
    float oh_no = cos(world_vertex_x* TIME*speed)+ sin(world_vertex_y* TIME*speed);
    float oh_god = sin(world_vertex_z* TIME*speed)+ cos(world_vertex_x* TIME*speed);
    float oh_feck = sin(world_vertex_z* TIME*speed)+ cos(world_vertex_x* TIME*speed);

    ALBEDO = vec3(sin(oh_no*frequency * TIME*speed),cos(oh_god*frequency * TIME*speed),tan(oh_feck*frequency * TIME*speed) );

    METALLIC = metallic;
    ROUGHNESS = roughness;
    SPECULAR = specular;
    //ALPHA = round(sin(albedo.a + world_vertex_y*frequency + TIME*speed) );



    ALPHA_SCISSOR_THRESHOLD=alpha_scissor_threshold;
}