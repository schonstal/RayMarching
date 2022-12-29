shader_type canvas_item;

uniform int max_steps = 100;
uniform float hit_distance = 0.01;
uniform float draw_distance = 100.;
// fragColor => COLOR
// fragCoord => FRAGCOORD
// uv => UV
// iResolution => 1.0 / SCREEN_PIXEL_SIZE
// iTime => TIME

struct Ray {
	vec3 position;
	vec3 direction;
	float magnitude;
};

float GetDistance(vec3 point) {
	vec4 sphere = vec4(0, 1, 3, 0.5);
	float plane_y = 0.;
	
	float sphere_distance = length(point - sphere.xyz) - sphere.w;
	float plane_distance = point.y - plane_y; 
	
 	return min(sphere_distance, plane_distance);
}

Ray ray_march(Ray ray) {
	for(int i = 0; i < max_steps; i++) {
		vec3 sphere_center = ray.position + ray.magnitude * ray.direction;
		float dist = GetDistance(sphere_center);
		ray.magnitude += dist;
		
		if (ray.magnitude > draw_distance || dist < hit_distance) break;
	}
	
	return ray;
}

void fragment() {
	vec2 uv = UV - vec2(0.5);
	Ray ray = Ray(
		vec3(sin(TIME), 1, cos(TIME)),
		normalize(vec3(uv.x, -uv.y, 1)),
		0.
	);
	ray = ray_march(ray);
	
	float d = ray.magnitude;
	d /= 4.;
	COLOR.r = vec3(1.0 - d).r;
	COLOR.gb = vec2(0.1, 0.2);
}