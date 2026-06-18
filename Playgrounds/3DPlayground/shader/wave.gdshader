// 3D shader.
shader_type spatial;

/*
*	specular_toon : changing from specular to toon mode has larger specular highlight.
*/
render_mode specular_toon;

// Noisemap assigned for the waves.
uniform sampler2D noise: hint_default_black;

// Water color.
uniform vec3 water_color: source_color = vec3(.01, .03, .05);

// Height.
uniform float height_scale = .5;

// Position translation from vertex to fragment.
varying vec2 tex_pos;

// Wave calculation.
float wave(vec2 position)
{
	// Position offset by noise to avoid straight lines.
	position += texture(noise, position / 10.).r * 2. - 1.;

	// Wave-like function.
	vec2 wv = 1. - abs(sin(position));

	// Result.
	return pow(1. - pow(wv.x * wv.y, .65), 4.);
}

// Height calculation.
float height(vec2 position, float time)
{
	// Makes the water displacement go in several directions at once. The pattern is still visible tho.
	float d = wave((position + time) * .4) * .3;
	d += wave((position - time) * .3) * .3;
	d += wave((position + time) * .5) * .2;
	d += wave((position - time) * .6) * .2;
	return d;
}

// For each vertex,
void vertex()
{
	// We calculate the position.
	// Since coordinates of the plane are within [-1, 1], we just remap them to [0, 1].
	tex_pos = VERTEX.xz / 2. + .5;
	
	// Position.
	vec2 pos = VERTEX.xz;
	
	// We read from the texture at the vertex's coordinates, we shift everything a little and since
	// it gives grayscale colors (due to the noise), we can take a single operand (here r, could be g or b)
	float k = height(pos, TIME);
	
	// Calculating normals by hand.
	NORMAL = normalize(vec3(
		k - height(pos + vec2(.1, 0.), TIME),
		.1,
		k - height(pos + vec2(0., .1), TIME)
	));
	
	// We modify the vertex's y position.
	VERTEX.y = k * height_scale;
}

// For each pixel interpolated between vertices,
void fragment()
{
	// Calculating fresnel reflectance.
	float fresnel = sqrt(1. - dot(NORMAL, VIEW));
	
	// Rim increases the effect of light at glancing angles.
	RIM = .2;
	
	// Setting metalness to 0 as water is not metallic.
	METALLIC = 0.;
	
	// Setting a little bit of roughness to avoid the shininess of plastic. With fresnel.
	ROUGHNESS = .01 * (1. - fresnel);

	// Assigning water color with fresnel reflectance.
	ALBEDO = water_color + (.1 * fresnel);
}