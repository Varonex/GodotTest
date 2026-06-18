// 3D shader.
shader_type spatial;

// Mode de rendu de profondeur à toujours dessiner.
render_mode depth_draw_always;

// CONSTANTS

// Epsilon value for float comparison.
const float EPSILON = 1e-5;

// VARIABLES

group_uniforms textures;

// Screen texture.
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;

// Depth texture.
uniform sampler2D DEPTH_TEXTURE: hint_depth_texture, filter_nearest;


group_uniforms aspect;

// Water colors for shallow parts.
uniform vec3 color_shallow: source_color = vec3(.01, .2, .3);

// Color of depth.
uniform vec3 color_depth: source_color = vec3(.3, .5, .6);

// Water transparency.
uniform float transparency: hint_range(0., 1.) = .6;

// Metalness of water.
uniform float metallic: hint_range(0., 1.) = 0.;

// Water roughness.
uniform float roughness: hint_range(0., 1.) = .25;

// Refraction intensity.
uniform float refraction_intensity: hint_range(0., 1.) = .4;

// Max depth in terms of perception.
uniform float max_visible_depth: hint_range(.1, 100., .1) = 20.;

// Height scale for waves.
uniform float wave_height_scale = 1.;

// Flatness of all waves.
uniform float wave_normal_flatness: hint_range(.1, 100., .1) = 50.;

// Roughness for surfaces.
uniform float surface_texture_roughness: hint_range(0., 1.) = .15;

// Scale of surface texture.
uniform float surface_texture_scale: hint_range(.001, 2.) = .1;

// Time scale for normal movement.
uniform float surface_texture_time_scale: hint_range(.001, 2.) = .06;


group_uniforms wave_a;

// Wave A texture.
uniform sampler2D wave_a: hint_default_black;

// Direction for wave A.
uniform vec2 wave_move_direction_a = vec2(-1., 0.);

// Scale of wave A.
uniform float wave_noise_scale_a = 15.;

// Time scale of wave A.
uniform float wave_time_scale_a = .15;

// Surface normal for wave A.
uniform sampler2D surface_normals_a: hint_default_black;

// Surface move direction for wave A.
uniform vec2 surface_normals_move_direction_a = vec2(-1, .2);


group_uniforms wave_b;

// Wave B texture.
uniform sampler2D wave_b: hint_default_black;

// Direction for wave B.
uniform vec2 wave_move_direction_b = vec2(0., 1.);

// Scale of wave B.
uniform float wave_noise_scale_b = 15.;

// Time scale of wave B.
uniform float wave_time_scale_b = .15;

// Surface normal for wave B.
uniform sampler2D surface_normals_b: hint_default_black;

// Surface move direction for wave B.
uniform vec2 surface_normals_move_direction_b = vec2(.2, 1.);


group_uniforms ssr;

// SSR resolution factor.
uniform float ssr_resolution: hint_range(.01, 10., .1) = 1.;

// SSR max travel factor.
uniform float ssr_max_travel: hint_range(0., 200., .1) = 30.;

// SSR max difference.
uniform float ssr_max_diff: hint_range(.1, 10., .1) = 4.;

// SSR mixing strength.
uniform float ssr_mix_strength: hint_range(0., 1., .01) = .7;

// SSR screen border fadeout factor.
uniform float ssr_screen_border_fadeout: hint_range(0., 1., .1) = .3;


group_uniforms border;

// Border color.
uniform vec3 border_color: source_color = vec3(1.);

// Scale of border.
uniform float border_scale: hint_range(0., 5.) = 2.;

// Nearest threshold for border.
uniform float border_near = .5;

// Farthest threshold for border.
uniform float border_far = 300.;

group_uniforms cutout;

// X cutout.
uniform float cut_out_x = 0.;

// Z cutout.
uniform float cut_out_z = 0.;


// Vertex to pass from vertex() to fragment().
varying vec2 vertex_uv;

// Position to pass from vertex() to fragment().
varying vec3 local_position;

// FUNCTIONS

// Averages heights of wave A and wave B textures at specific coordinates.
float get_wave_height(vec2 uv_a, vec2 uv_b)
{
	// Height on wave a texture at uv_a.
	float height1 = texture(wave_a, uv_a).y;
	
	// Height on wave b texture at uv_b.
	float height2 = texture(wave_b, uv_b).y;
	
	// Averaging the two.
	return (height1 + height2) / 2.;
}

// Mixes normals.
vec3 get_mixed_normals(vec3 normal1, vec3 normal2)
{
	// Shifts normals from [0, 1] to [-1, 1] and then normalizes them.
	normal1 = normalize(normal1 * 2. - 1.);
	normal2 = normalize(normal2 * 2. - 1.);
	
	vec3 up = vec3(0., 0., 1.);
	vec3 tangent = normalize(normal1 + normal2);
	
	// Reminder : cross is v * w, it's not the dot product, it gives out a
	// vector that is orthogonal to up & tangent.
	vec3 binomial = normalize(cross(up, tangent));
	vec3 mixed_normal = normalize(cross(tangent, binomial));
	
	return mixed_normal /** .5*/;
}

// States whether a position is within the screen boundaries.
bool is_within_screen_boundaries(vec2 position)
{
	return position.x > 0. && position.x < 1. && position.y > 0. && position.y < 1.;
}

// Gets uv from a position.
vec2 get_uv_from_view_position(vec3 position_view_space, mat4 proj_m)
{
	vec4 position_clip_space = proj_m * vec4(position_view_space.xyz, 1.);
	vec2 position_ndc = position_clip_space.xy / position_clip_space.w;
	return position_ndc.xy * .5 + .5;
}

// Gets position from uv. Inverse of get_uv_from_view_position.
vec3 get_view_position_from_uv(vec2 uv, float depth, mat4 inv_proj_m)
{
	vec4 position_ndc = vec4((uv * 2.) - 1., depth, 1.);
	vec4 view_position = inv_proj_m * position_ndc;
	return view_position.xyz /= view_position.w;
}

// Determines whether a float is approx. zero.
bool is_zero(float v)
{
	return abs(v) < EPSILON;
}

// Calculates alpha depending on the screen position.
float get_screen_border_alpha(vec2 screen_position)
{
	// Shifts the screen position.
	vec2 shifted_screen_position = 4. * screen_position * (1. - screen_position);
	
	// Estimates the mask value. Ranging in [0, 1], 0 being the edge and 1 being
	// the center.
	float mask = shifted_screen_position.x * shifted_screen_position.y;
	
	// Calculates the offset in [0, .5] range for screen fadeout > .75.
	// Ensures alpha smoothly transitions to zero.
	float offset = mix(0., .5, (clamp(ssr_screen_border_fadeout, .75, 1.) - .75) / .25);
	
	// Calculates the alpha with the fadeout & mask for smoother transition.
	float alpha = clamp(smoothstep(0., 2. * ssr_screen_border_fadeout, mask) - offset, 0., 1.);
	
	// If ssr fadeout is null, alpha is 1. Otherwise sends the calculated alpha.
	return is_zero(ssr_screen_border_fadeout) ? 1. : alpha;
}

// SSR color fetch. ?
vec4 get_ssr_color(vec3 surface_view_position, vec3 normal_view_space, vec3 view_view_space, mat4 proj_m, mat4 inv_proj_m)
{
	if (ssr_max_travel < EPSILON)
	{
		return vec4(0.);
	}
	
	// Caching.
	vec3 current_position_view_space = surface_view_position;
	
	// Changing direction.
	vec3 view_direction_view_space = view_view_space * -1.;
	
	// Reflection vector.
	vec3 reflect_vector_view_space = normalize(reflect(view_direction_view_space.xyz, normal_view_space.xyz));
	
	vec2 current_screen_position = vec2(0.);
	vec3 resulting_color = vec3(-1.);
	
	for (float travel = 0.; resulting_color.x < 0. && travel < ssr_max_travel; travel = travel + ssr_resolution)
	{
		current_position_view_space += reflect_vector_view_space * ssr_resolution;
		current_screen_position = get_uv_from_view_position(current_position_view_space, proj_m);
		
		float depth_texture_probe_raw = texture(DEPTH_TEXTURE, current_screen_position).x;
		vec3 depth_texture_probe_view_position = get_view_position_from_uv(current_screen_position, depth_texture_probe_raw, inv_proj_m);
		
		float depth_diff = depth_texture_probe_view_position.z - current_position_view_space.z;
		
		vec3 ssr_screen_color = texture(SCREEN_TEXTURE, current_screen_position.xy).rgb;
		
		if (is_within_screen_boundaries(current_screen_position) && depth_diff >= 0. && depth_diff < ssr_max_diff)
			resulting_color = ssr_screen_color; 
		else
			resulting_color = vec3(-1.);
	}
	
	float alpha = get_screen_border_alpha(current_screen_position);
	return vec4(resulting_color, alpha);
}

// Remaps depth to cur_depth.
float linear_depth(float cur_depth)
{
	return border_far * border_near / (border_near + cur_depth * (border_far - border_near));
}

// Normalizes floats.
float normalize_float(float min_v, float max_v, float v)
{
	float clamped = clamp(v, min_v, max_v);
	return (clamped - min_v) / (max_v - min_v);
}

vec2 get_refracted_uv(vec2 raw_screen_uv, float screen_depth_raw, vec3 view, vec3 normal, mat4 proj_m, mat4 inv_proj_m)
{
	vec3 screen_view_position_original = get_view_position_from_uv(raw_screen_uv, screen_depth_raw, inv_proj_m);
	float screen_center_distance = clamp(abs(length(raw_screen_uv - vec2(0.5, 0.5))) * 2.0, 0.0, 1.0);
	float refraction_intensity_deglitched = mix(1.0 - refraction_intensity, 1.0, screen_center_distance);
	vec3 refraction_position_view_space = screen_view_position_original + normalize(refract(view, -normal, refraction_intensity_deglitched));
	vec2 refraction_uv = get_uv_from_view_position(refraction_position_view_space, proj_m);
	return refraction_uv;
}
// ENGINE

// For each vertex,
void vertex()
{
	local_position = VERTEX;
	
	// Isolates the coordinates of vertex_uv from the model matrix.
	vertex_uv = (MODEL_MATRIX * vec4(local_position, 1.)).xz;
	
	vec2 uv_a = vertex_uv / wave_noise_scale_a + (wave_move_direction_a * TIME * wave_time_scale_a);
	vec2 uv_b = vertex_uv / wave_noise_scale_b + (wave_move_direction_b * TIME * wave_time_scale_b);
	
	// Offsetting the y coord of the current vertex.
	VERTEX.y += get_wave_height(uv_a, uv_b) * wave_height_scale;
	
	// Calculating height scale for the normal.
	float normal_height_scale = wave_height_scale / wave_normal_flatness;
	
	// Estimating normal.
	vec2 e = vec2(.01, 0.);
	vec3 normal = normalize(vec3(
			get_wave_height(uv_a - e, uv_b - e) * normal_height_scale - get_wave_height(uv_a + e, uv_b + e) * normal_height_scale,
			2. * e.x,
			get_wave_height(uv_a - e.yx, uv_b - e.yx) * normal_height_scale - get_wave_height(uv_a + e.yx, uv_b + e.yx) * normal_height_scale
	));
	
	// Assigning normal.
	NORMAL = normal;
}

// For each pixel interpolated between vertices,
void fragment()
{
	vec3 normal = NORMAL;
	
	float screen_depth_raw = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	
	vec2 refraction_uv = refraction_intensity > 0. ? get_refracted_uv(SCREEN_UV, screen_depth_raw, VIEW, normal, PROJECTION_MATRIX, INV_PROJECTION_MATRIX) : SCREEN_UV;
	
	float screen_depth = texture(DEPTH_TEXTURE, refraction_uv).x;
	float surface_depth = FRAGCOORD.z;
	
	float border_diff = linear_depth(screen_depth_raw) - linear_depth(surface_depth);
	
	vec2 time_vector_a = (TIME * surface_normals_move_direction_a) * surface_texture_time_scale;
	vec2 time_vector_b = (TIME * surface_normals_move_direction_b) * surface_texture_time_scale;
	
	vec3 normal_texture_blend = get_mixed_normals(
			texture(surface_normals_a, vertex_uv * surface_texture_scale + time_vector_a).xyz,
			texture(surface_normals_b, vertex_uv * surface_texture_scale + time_vector_b).xyz
	);
	vec3 normal_blend = mix(normal, normal_texture_blend, surface_texture_roughness);
	
	vec3 screen_view_position = get_view_position_from_uv(refraction_uv, screen_depth, INV_PROJECTION_MATRIX);
	vec3 surface_view_position = get_view_position_from_uv(SCREEN_UV, surface_depth, INV_PROJECTION_MATRIX);
	float depth_visibility = 1. - normalize_float(0., max_visible_depth, length(surface_view_position - screen_view_position));
	
	vec3 screen_color = texture(SCREEN_TEXTURE, refraction_uv).rgb;
	vec4 ssr_color = get_ssr_color(surface_view_position, normal, VIEW, PROJECTION_MATRIX, INV_PROJECTION_MATRIX);
	vec3 surface_color_transparency = mix(color_shallow, screen_color, transparency);
	vec3 surface_depth_color_mix = mix(color_depth, surface_color_transparency, depth_visibility);
	vec3 surface_color_ssr_mix = (ssr_max_travel > EPSILON) ? mix(surface_depth_color_mix, ssr_color.rgb, ssr_mix_strength * ssr_color.a) : vec3(0.);
	vec3 water_color = (ssr_color.x >= 0.) ? surface_color_ssr_mix : surface_depth_color_mix;
	vec3 final_color = mix(border_color, water_color, step(border_scale, border_diff));
	
	float cut_out_x_half = cut_out_x / 2.;
	float cut_out_z_half = cut_out_z / 2.;
	
	// We discard pixels that are not within the range.
	if ((local_position.x < cut_out_x_half && local_position.x > -cut_out_x_half) &&
		(local_position.z < cut_out_z_half && local_position.z > -cut_out_z_half)
	)
		discard;
	
	ALBEDO.rgb = final_color;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL = normal_blend;
}