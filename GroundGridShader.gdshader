shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec2 grid(vec2 uv, float columns, float rows){
	return fract(vec2(uv.x * columns, uv.y * rows));
}

void fragment() {
    vec2 grid = grid(UV, 3.0, 7.0);
	float lineAA = fwidth(UV.x);
	float lineWidth = 0.01;
	float grid_x = smoothstep(lineWidth + lineAA, lineWidth - lineAA, grid.x);
	float grid_y = smoothstep(lineWidth + lineAA, lineWidth - lineAA, grid.y);
    ALBEDO.rgb = vec3(grid_x, grid_y, 0.0);
}


//
//void fragment() {
	//// Called for every pixel the material is visible on.
	//float lineWidth = 1.;
	//float lineAA = fwidth(UV.x);
	//float lineUV = abs(UV.x * 2.0);
	//float line = smoothstep(lineWidth + lineAA, lineWidth - lineAA, lineUV);
	//COLOR = line * vec3(1.,1.,1.);
//}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
