shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

void fragment()
{
	float rad = distance(UV, vec2(.5))/.3;
	rad = clamp(rad, 0., 1.);
	
	COLOR.rgb = mix(COLOR.rgb, vec3(1.) - texture(SCREEN_TEXTURE, UV).rgb, rad);
}
