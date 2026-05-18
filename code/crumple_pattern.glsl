// crumple_pattern.glsl
// Random and statistical origami — what emerges from crumpling a sheet.
// Models the fractal geometry of a heavily crumpled paper ball unfolded.
//
// MATHEMATICS:
//   Crumpled paper forms a fractal object with Hausdorff dimension ≈ 2.5
//   (between surface and volume). The crease density follows a power law:
//     N(r) ~ r^(-D)  where D ≈ 2.0–2.5 for typical crumpling
//
//   The crease pattern of a crumpled sheet has been studied by
//   Lobkovsky et al. (1995) and Witten (2007). Key results:
//   - Ridges concentrate bending energy along 1D lines
//   - Vertices (d-cones) are points of true singularity
//   - The pattern is scale-free: zoom in and find more creases
//
// PARAMETERS:
//   creaseDensity – controls fractal depth / crumple intensity
//   mountainRatio – fraction of folds that are mountain
//   shadowDepth   – depth of inter-crease shadows
//   foldAngle     – 0=flat, 180=fully crumpled

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_creaseDensity; // crumple intensity [1, 100]
uniform float u_mountainRatio; // [0.3, 0.7]
uniform float u_shadowDepth;
uniform float u_foldAngle;     // [0, 180]

const float PI = 3.14159265358979;

// ── Noise / hash ──────────────────────────────────────────────────────────
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}
vec2 hash2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453);
}
float noise(vec2 p) {
    vec2 i = floor(p), f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(hash2(i),         f),
                   dot(hash2(i + vec2(1,0)), f - vec2(1,0)), u.x),
               mix(dot(hash2(i + vec2(0,1)), f - vec2(0,1)),
                   dot(hash2(i + vec2(1,1)), f - vec2(1,1)), u.x), u.y);
}

// ── Fractal crumple field ─────────────────────────────────────────────────
// Returns a crease-density value using layered noise (fBm) scaled by
// the power-law ridge distribution D ≈ 2.0.
float crumpleField(vec2 uv, float intensity, int octaves) {
    float val = 0.0;
    float amp = 0.5;
    float freq = intensity * 0.3;
    for (int o = 0; o < 8; o++) {
        if (o >= octaves) break;
        val += amp * abs(noise(uv * freq));
        freq *= 2.1;
        amp  *= 0.48;
    }
    return val;
}

// ── D-cone (conical defect) singularity ──────────────────────────────────
// D-cones are points where all creases converge — energy localisation.
float dcone(vec2 uv, vec2 centre, float radius) {
    float d = length(uv - centre) - radius;
    // Radial crease fans emanate from d-cone
    float angle = atan(uv.y - centre.y, uv.x - centre.x);
    float fanN = 8.0;
    float fan = abs(sin(angle * fanN * 0.5));
    return smoothstep(0.0, 1.0, fan) * smoothstep(radius * 3.0, 0.0, length(uv - centre));
}

// ── Ridge highlight ───────────────────────────────────────────────────────
// Ridges = 1D bending-energy concentrations; visualised as bright lines
float ridge(vec2 uv, float scale) {
    float n = noise(uv * scale);
    float dn = n - noise(uv * scale + vec2(0.01, 0.0));
    return abs(dn) * scale;
}

// ── Main ──────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;

    float t = u_foldAngle / 180.0;  // crumple progress
    float intensity = u_creaseDensity * t + 1.0;

    // How many fractal octaves? More = deeper crumple
    int octaves = int(clamp(u_creaseDensity * 0.06 + 2.0, 2.0, 7.0));

    // ── Paper base ────────────────────────────────────────────────────────
    vec3 paper = vec3(0.94, 0.91, 0.85);
    vec3 col = paper;

    // ── Fractal crease field ──────────────────────────────────────────────
    float field = crumpleField(uv, intensity, octaves);
    // The field modulates brightness: higher field = deeper in the crumple
    col *= (1.0 - field * u_shadowDepth * 0.7);

    // ── Mountain/valley colouring ─────────────────────────────────────────
    float h = hash(floor(uv * intensity * 2.0));
    vec3 mtnCol = vec3(0.78, 0.20, 0.15);
    vec3 valCol = vec3(0.18, 0.30, 0.72);
    vec3 foldCol = mix(valCol, mtnCol, step(1.0 - u_mountainRatio, h));
    // Blend colour in proportion to crease density at that point
    float creaseProb = smoothstep(0.3, 0.7, field);
    col = mix(col, mix(col, foldCol, 0.6), creaseProb * t);

    // ── Ridge lines (high-energy bending) ─────────────────────────────────
    float r1 = ridge(uv, intensity * 1.5);
    float r2 = ridge(uv + vec2(0.5, 0.3), intensity * 2.7);
    float ridgeVal = max(r1, r2);
    col += vec3(0.95, 0.93, 0.88) * ridgeVal * 0.2 * t;

    // ── D-cone singularities ──────────────────────────────────────────────
    float h1 = hash(vec2(3.1, 7.7)), h2 = hash(vec2(1.3, 9.1));
    float h3 = hash(vec2(6.2, 4.5));
    float cone1 = dcone(uv, vec2(0.3 + h1 * 0.4, 0.3 + h2 * 0.4), 0.005);
    float cone2 = dcone(uv, vec2(0.5 + h3 * 0.3, 0.6 + h1 * 0.3), 0.005);
    col = mix(col, vec3(1.0, 0.9, 0.5), (cone1 + cone2) * t * 0.7);

    // ── Paper grain ───────────────────────────────────────────────────────
    float grain = noise(uv * 600.0) * 0.018;
    col += grain;

    // ── Vignette ──────────────────────────────────────────────────────────
    vec2 cv = uv - 0.5;
    col *= 1.0 - 0.3 * dot(cv, cv) * 4.0;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
