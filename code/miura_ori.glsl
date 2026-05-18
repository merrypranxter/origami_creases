// miura_ori.glsl
// Miura-ori tessellation — the rigid-foldable space-filling pattern used in
// deployable satellite solar panels and architectural facades.
//
// MATHEMATICS:
//   The Miura-ori is parameterised by a single sector angle α (typically ~45°).
//   All parallelogram panels share the same dihedral fold angle φ, satisfying:
//
//     tan(φ/2)² = (1 - sin²(α)·sin²(θ)) / cos²(θ)
//
//   where θ is the deployment parameter ∈ [0, π/2].
//   The pattern is rigid-foldable with a single DOF.
//
// PARAMETERS:
//   foldAngle     – global fold angle [0, 180]; drives the deployment
//   creaseDensity – rows of cells
//   paperColor    – white / kraft / washi / metallic
//   shadowDepth   – inter-panel shadow intensity [0, 1]

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_foldAngle;    // [0, 180] degrees
uniform float u_creaseDensity;
uniform float u_shadowDepth;
// paperColor encoded: 0=white 1=kraft 2=washi 3=metallic
uniform float u_paperColor;

const float PI = 3.14159265358979;

// ── Paper colours ──────────────────────────────────────────────────────────
vec3 paperPalette(float id) {
    if (id < 0.5) return vec3(0.97, 0.95, 0.90);          // white
    if (id < 1.5) return vec3(0.82, 0.68, 0.48);          // kraft
    if (id < 2.5) return vec3(0.90, 0.88, 0.84);          // washi (off-white)
    return vec3(0.78, 0.78, 0.82);                          // metallic
}

// ── Miura-ori cell geometry ────────────────────────────────────────────────
// Returns a shading value in [0,1] for a point inside the Miura grid.
// The shading encodes which face of the folded panel is visible.
float miuraCell(vec2 uv, float N, float phi) {
    // phi in [0, pi] — fold angle in radians
    float alpha = PI * 0.25; // sector angle ≈ 45°

    vec2 cell = floor(uv * N);
    vec2 f    = fract(uv * N);

    // Miura parallelogram: every other column is offset vertically by sin(alpha)
    float colOffset = mod(cell.x, 2.0) * sin(alpha);
    float row = cell.y + colOffset;

    // Deployment ratio t: 0=fully open (flat), 1=fully closed
    float t = phi / PI;

    // Shear: the horizontal compression follows cos(phi)
    float compress = cos(phi * 0.5); // x-compression factor

    // Panel normal approximation: alternating panels tilt ±phi/2
    float tilt = (mod(cell.x + cell.y, 2.0) < 1.0 ? 1.0 : -1.0);
    float shade = 0.5 + 0.5 * tilt * sin(phi * 0.5);

    // Add crease highlight at panel edges
    float edgeDist = min(min(f.x, 1.0 - f.x), min(f.y, 1.0 - f.y));
    float crease = smoothstep(0.04, 0.01, edgeDist);

    return mix(shade, 0.1, crease);
}

// ── Panel depth (fake 3D parallax) ─────────────────────────────────────────
float panelDepth(vec2 uv, float N, float phi) {
    vec2 cell = floor(uv * N);
    float parity = mod(cell.x + cell.y, 2.0);
    float t = phi / PI;
    // Depth = how far the panel sits in Z
    return parity * t * 0.5;
}

// ── Main ───────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float aspect = u_resolution.x / u_resolution.y;
    uv.x *= aspect;

    // Animated fold angle: use uniform if non-zero, else auto-animate
    float phi = u_foldAngle > 0.0
        ? u_foldAngle * PI / 180.0
        : (PI * 0.5) * (0.5 + 0.5 * sin(u_time * 0.6));

    float N = max(2.0, u_creaseDensity * 0.4); // cells per axis

    float shade = miuraCell(uv, N, phi);
    float depth = panelDepth(uv, N, phi);

    // Paper base colour + shading
    vec3 paper = paperPalette(u_paperColor);
    vec3 col = paper * shade;

    // Inter-panel shadow proportional to depth difference
    float shadow = depth * u_shadowDepth;
    col = mix(col, vec3(0.1, 0.08, 0.06), shadow);

    // Specular highlight (metallic only)
    if (u_paperColor > 2.5) {
        float spec = pow(max(0.0, shade - 0.6) * 2.5, 3.0);
        col += vec3(0.9, 0.9, 1.0) * spec * 0.4;
    }

    // Deployment progress bar at bottom (subtle)
    float barY = 0.015;
    if (gl_FragCoord.y / u_resolution.y < barY) {
        float progress = phi / PI;
        vec3 barCol = uv.x / aspect < progress ? vec3(0.3, 0.6, 0.9) : vec3(0.2);
        col = barCol;
    }

    // Vignette
    vec2 centred = uv - vec2(aspect * 0.5, 0.5);
    col *= 1.0 - 0.25 * dot(centred, centred);

    gl_FragColor = vec4(col, 1.0);
}
