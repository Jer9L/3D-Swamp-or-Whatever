shader_type spatial;

uniform vec3 albedo : source_color;
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform float roughness : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D textures;
uniform sampler2D textures2;
uniform vec2 wave = vec2(2.0, 0.0);
uniform vec2 wave2 = vec2(2.0, 0.0);
uniform float time_scale : hint_range(0.0, 0.3, 0.0025);

void fragment() {

	vec2 motion = (TIME * wave) * time_scale;
	vec2 motion2 = (TIME*wave2) * time_scale;
	vec3 normal = mix(texture(textures,UV + motion).rgb, texture(textures2,UV + motion2).rgb,0.5);

	ALBEDO = albedo;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal;
}