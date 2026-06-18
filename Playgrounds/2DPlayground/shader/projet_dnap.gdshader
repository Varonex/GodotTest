shader_type canvas_item;

group_uniforms ciel;

// Hauteur du ciel, en pourcentage.
uniform float hauteur_ciel: hint_range(0., 1.);

group_uniforms sphere;

// Hauteur de la sphère, en pourcentage.
uniform vec2 coords_sphere;

// Rayon de la sphère, en pourcentage.
uniform float rayon_sphere: hint_range(0., 1.);

group_uniforms tache;

// Coordonnées de la tâche, en pourcentage.
uniform vec2 coords_tache;

// Rayon de la tâche, en pourcentage.
uniform float rayon_tache: hint_range(0., 1.);

group_uniforms ombre;

// Coordonnées du centre de l'ombre, en pourcentage.
uniform vec2 uv_ombre;

// Point supérieur gauche de l'ombre, en pourcentage.
uniform vec2 ombre_point_gauche;

// Point inférieur droit de l'ombre, en pourcentage.
uniform vec2 ombre_point_droit;

group_uniforms couleurs;

// Couleur de l'herbe.
uniform vec4 couleur_herbe: source_color = vec4(.298, .6, 0, 1.);

// Couleur du ciel.
uniform vec4 couleur_ciel: source_color = vec4(.812, .812, 1., 1.);

// Couleur de la sphère.
uniform vec4 couleur_sphere: source_color = vec4(.424, .086, .227, 1.);

// Couleur de la tâche.
uniform vec4 couleur_tache: source_color = vec4(1., 1., 1., 1.);

// Couleur de l'ombre.
uniform vec4 couleur_ombre: source_color = vec4(0., 0., 0., 1.);

varying float m;
varying float m1;
varying float m2;
varying float p;
varying float q;

float Q(vec2 uv)
{
	return m1 * pow(uv.x, 2.) + 2. * m * uv.x * uv.y + m2 * pow(uv.y, 2.);
}

float f(vec2 uv)
{
	return Q(uv) - 2. * (p * uv.x + q * uv.y) + Q(uv_ombre) - 1.;
}

float calcul_m(float i, float j, float a, float b)
{
	return pow(i, 2.) / pow(a, 2.) + pow(j, 2.) / pow(b, 2.);
}

// Pour chaque vertex,
void vertex()
{
	// On fait tout ça ici pour éviter de devoir tout recalculer h24.

	/* ELLIPSE */

	// Devrait être un uniform ou du moins calculé du rect2.
	float angle_ellipse = PI/2.725;

	float a_ombre = length(vec2(ombre_point_gauche.x - uv_ombre.x, ombre_point_gauche.y - uv_ombre.y));
	float b_ombre = length(vec2(ombre_point_droit.x - uv_ombre.x, ombre_point_droit.y - uv_ombre.y));

	float cos_angle_ellipse = cos(angle_ellipse);
	float sin_angle_ellipse = sin(angle_ellipse);

	m = cos_angle_ellipse * sin_angle_ellipse * ( (1. / pow(a_ombre, 2.)) - (1. / pow(b_ombre, 2.)) );
	m1 = calcul_m(cos_angle_ellipse, sin_angle_ellipse, a_ombre, b_ombre);
	m2 = calcul_m(sin_angle_ellipse, cos_angle_ellipse, a_ombre, b_ombre);

	p = m1 * uv_ombre.x + m * uv_ombre.y;
	q = m * uv_ombre.x + m2 * uv_ombre.y;
}

// Appelé pour chaque pixel.
void fragment()
{
	/* DESSIN */
	
	// Ciel.
	if (UV.y < hauteur_ciel)
	{
		COLOR = couleur_ciel;
	}
	
	else
	{
		// Sphère.
		float x_shift, y_shift;
		float dist;
		
		x_shift = UV.x - coords_sphere.x;
		y_shift = UV.y - coords_sphere.y;

		dist = length(vec2(x_shift, y_shift));
		
		if (dist <= rayon_sphere)
		{
			// Point dans la sphère, gestion de la tâche.
			x_shift = UV.x - coords_tache.x;
			y_shift = UV.y - coords_tache.y;
			
			dist = length(vec2(x_shift, y_shift));
			
			COLOR = mix(couleur_tache, couleur_sphere, dist /rayon_tache);
		}
		
		else
		{
			// Ellipse.
			dist = f(UV);
			
			if (dist <= 0.)
			{
				// Est dans l'ombre.
				COLOR = couleur_ombre;
			}
			
			else
			{
				// Herbe.
				COLOR = couleur_herbe;	
			}
		}
	}
}
