// curved_crease.glsl
// David Huffman-style curved-crease origami.
// Folds along smooth curves instead of straight lines, creating
// sculptural developable surfaces with parabolic rulings.
//
// MATHEMATICS:
//   A curved crease on a developable surface must satisfy:
//     - The surface has zero Gaussian curvature (K = 0) everywhere
//     - The crease curve has equal geodesic curvatures on both sides
//     - Rulings (generators) of the developable surface are tangent to the
//       osculating plane of the crease curve
//   For a fold along curve γ(t), the "ruling angle" ψ obeys:
//     dψ/ds = κg  (geodesic curvature of the fold curve)
//
// PARAMETERS:
//   curvature     – [0,1] 0=straight creases, 1=fully curved
//   foldAngle     – dihedral angle [0,180]
//   creaseDensity – number of curved fold lines
//   origamiStyle  – geometric/organic/modular/curved (encoded 0-3)

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_curvature;    // [0, 1]
uniform float u_foldAngle;    // [0, 180]
uniform float u_creaseDensity;
uniform float u_origamiStyle; // 0=geometric 1=organic 2=modular 3=curved

const float PI = 3.14159265358979;
const float TWO_PI = 6.28318530717959;

// ── Noise ─────────────────────────────────────────────────────────────────
vec2 hash2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}
float noise(vec2 p) {
    vec2 i = floor(p), f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(hash2(i + vec2(0,0)), f - vec2(0,0)),
                   dot(hash2(i + vec2(1,0)), f - vec2(1,0)), u.x),
               mix(dot(hash2(i + vec2(0,1)), f - vec2(0,1)),
                   dot(hash2(i + vec2(1,1)), f - vec2(1,1)), u.x), u.y);
}

// ── Curved crease function ────────────────────────────────────────────────
// Returns signed distance to a curved crease at level k.
// The crease is a sine-based curve modulated by noise to simulate Huffman arcs.
float curvedCreaseDist(vec2 uv, float k, float curvature) {
    float t = u_time * 0.2;
    // Base: sine wave with frequency from density
    float freq = k * TWO_PI;
    float yc = sin(uv.x * freq + t * 0.3) * curvature * 0.1;

    // Add geodesic curvature perturbation (noise-driven)
    if (curvature > 0.3) {
        float n = noise(uv * 2.0 + vec2(k * 3.7, t));
        yc += n * curvature * 0.06;
    }

    return abs(uv.y - k / u_creaseDensity - 0.5 + 0.5 / u_creaseDensity - yc);
}

// ── Ruling lines (generators of the developable surface) ─────────────────
// Rulings are straight lines tangent to the crease osculating plane.
float rulingLine(vec2 uv, float k, float curvature) {
    float freq = k * TWO_PI;
    float t = u_time * 0.2;
    // Slope of ruling = derivative of crease curve
    float dydx = cos(uv.x * freq + t * 0.3) * curvature * 0.1 * freq;
    float yc = sin(uv.x * freq + t * 0.3) * curvature * 0.1;
    float yRef = k / u_creaseDensity - 0.5 + 0.5 / u_creaseDensity + yc;
    float ruling = abs((uv.y - yRef) - dydx * (uv.x - 0.5));
    return ruling;
}

// ── Shading from fold angle ───────────────────────────────────────────────
float panelShade(vec2 uv, float phi, float curvature) {
    // Panel index (which side of each curved crease are we on?)
    float panelRow = floor((uv.y + 0.5) * u_creaseDensity);
    float tilt = (mod(panelRow, 2.0) < 1.0 ? 1.0 : -1.0);

    // Gaussian curvature perturbation for organic style
    if (u_origamiStyle > 0.5) {
        float n = noise(uv * 4.0);
        tilt *= (1.0 + n * 0.3 * curvature);
    }

    return 0.5 + 0.45 * tilt * sin(phi * 0.5);
}

// ── Main ──────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float aspect = u_resolution.x / u_resolution.y;
    uv.x *= aspect;
    uv.x /= aspect; // normalise back — keep in [0,1]²

    float phi = u_foldAngle * PI / 180.0;
    float curv = u_curvature;

    // Paper colour base (cream)
    vec3 paper = vec3(0.96, 0.94, 0.88);
    vec3 col = paper;

    // Shading (fold direction per panel)
    float shade = panelShade(uv, phi, curv);
    col *= shade;

    float n = max(1.0, u_creaseDensity);
    float lineW = 0.003;

    // Mountain crease colour: red / Valley: blue
    for (float k = 1.0; k < 20.0; k++) {
        if (k > n) break;

        float d = curvedCreaseDist(uv, k, curv);
        bool isMtn = mod(k, 2.0) < 1.0;
        vec3 cCol = isMtn ? vec3(0.80, 0.18, 0.12) : vec3(0.15, 0.32, 0.78);
        float line = smoothstep(lineW, lineW * 0.2, d);
        col = mix(col, cCol, line * 0.9);

        // Draw rulings (faint grey)
        float rd = rulingLine(uv, k, curv);
        float ruling = smoothstep(0.004, 0.001, rd);
        col = mix(col, vec3(0.6, 0.6, 0.6), ruling * 0.3 * curv);
    }

    // Osculating plane highlight
    float oscGlow = noise(uv * 8.0 + u_time * 0.1) * curv * 0.08;
    col += vec3(0.9, 0.95, 1.0) * oscGlow;

    // Vignette
    vec2 cv = uv - 0.5;
    col *= 1.0 - 0.3 * dot(cv, cv) * 4.0;

    gl_FragColor = vec4(col, 1.0);
}
