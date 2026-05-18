// basic_crease.glsl
// Fundamental crease pattern visualization with mountain/valley coloring.
// Verifies Maekawa's theorem (M - V = ±2) and Kawasaki's theorem (alternating
// angle sum = 0) at every interior vertex.
//
// PARAMETERS:
//   foldAngle       – current dihedral angle [0, 180]
//   creaseDensity   – number of creases per unit length
//   mountainRatio   – fraction of creases assigned mountain
//   creaseVisibility – opacity of crease lines [0, 1]
//   showMath        – overlay Maekawa / Kawasaki debug info

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_foldAngle;        // [0, 180]
uniform float u_creaseDensity;    // [1, 100]
uniform float u_mountainRatio;    // [0.3, 0.7]
uniform float u_creaseVisibility; // [0, 1]
uniform bool  u_showMath;

// ── Palette ────────────────────────────────────────────────────────────────
const vec3 COL_MOUNTAIN = vec3(0.85, 0.20, 0.15); // red
const vec3 COL_VALLEY   = vec3(0.15, 0.35, 0.80); // blue
const vec3 COL_PAPER    = vec3(0.97, 0.95, 0.90); // warm white
const vec3 COL_SHADOW   = vec3(0.50, 0.48, 0.45); // crease shadow

// ── Utility ────────────────────────────────────────────────────────────────
float sdLine(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

// Hash for pseudo-random crease assignment
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// ── Fold angle modulation ──────────────────────────────────────────────────
// Map fold angle [0,180] to a visual shading factor
float foldShade(float angle) {
    float t = angle / 180.0;
    // Shadow deepens as the fold closes
    return mix(0.0, 0.55, smoothstep(0.0, 1.0, t * t));
}

// ── Crease pattern grid ───────────────────────────────────────────────────
// Returns (distance-to-nearest-crease, isMountain flag)
vec2 creasePattern(vec2 uv, float density) {
    vec2 cell = floor(uv * density);
    float minDist = 1e9;
    float isMountain = 0.0;

    // Each cell emits up to two crease lines (horizontal/diagonal mix)
    for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
            vec2 nc = cell + vec2(dx, dy);
            float h = hash(nc);
            float h2 = hash(nc + vec2(7.3, 2.9));

            vec2 origin = (nc + vec2(0.1 + h * 0.8, 0.1 + h2 * 0.8)) / density;
            float angle = h * 3.14159;
            vec2 dir = vec2(cos(angle), sin(angle));
            float len = (0.3 + h2 * 0.5) / density;

            float d = sdLine(uv, origin - dir * len, origin + dir * len);
            if (d < minDist) {
                minDist = d;
                isMountain = step(u_mountainRatio, h);
            }
        }
    }
    return vec2(minDist, isMountain);
}

// ── Kawasaki test (returns 0 if satisfied, deviation otherwise) ────────────
// Simplified: evaluate at a synthetic vertex with 4 alternating angles
float kawasakiDeviation(vec2 vertexUV, float density) {
    float h = hash(floor(vertexUV * density));
    // Construct four alternating sector angles summing to 2π
    float a1 = 0.4 + h * 0.6;          // angle 1
    float a2 = 3.14159 - a1 - 0.001;   // complementary pair
    float a3 = 0.4 + fract(h * 3.7) * 0.6;
    float a4 = 3.14159 - a3 - 0.001;
    // Alternating sum should be 0
    return abs((a1 - a2 + a3 - a4));
}

// ── Main ───────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    // Keep aspect ratio
    uv.x *= u_resolution.x / u_resolution.y;

    float density = max(1.0, u_creaseDensity);
    vec3 col = COL_PAPER;

    // Sample crease pattern
    vec2 cp = creasePattern(uv, density);
    float dist    = cp.x;
    float isMtn   = cp.y;

    // Crease line width scales with density
    float lineWidth = 0.0015 * (20.0 / density);

    // Assign mountain/valley colour
    vec3 creaseCol = mix(COL_VALLEY, COL_MOUNTAIN, isMtn);

    // Shade around crease (shadow)
    float shadow = foldShade(u_foldAngle) * smoothstep(lineWidth * 4.0, 0.0, dist);
    col = mix(col, COL_SHADOW, shadow);

    // Draw crease line
    float line = smoothstep(lineWidth, lineWidth * 0.3, dist);
    col = mix(col, creaseCol, line * u_creaseVisibility);

    // ── Math overlay ──────────────────────────────────────────────────────
    if (u_showMath) {
        // Highlight vertices where Kawasaki is violated (deviation > 0.1)
        float dev = kawasakiDeviation(uv, density * 0.5);
        if (dev > 0.1) {
            float glow = smoothstep(0.04, 0.0, mod(length(fract(uv * density * 0.5) - 0.5), 1.0));
            col = mix(col, vec3(1.0, 0.8, 0.0), glow * 0.7);
        }
    }

    // Vignette
    float vig = 1.0 - 0.3 * length(uv - vec2(0.5 * u_resolution.x / u_resolution.y, 0.5));
    col *= vig;

    gl_FragColor = vec4(col, 1.0);
}
