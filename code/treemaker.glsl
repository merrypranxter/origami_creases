// treemaker.glsl
// Simplified visualisation of Robert Lang's TreeMaker algorithm.
// Given a "tree" (stick figure of desired flaps), packs circles on the paper
// so each leaf node maps to a circle. Creases emerge from the circle packing.
//
// MATHEMATICS:
//   TreeMaker encodes an origami model as a metric tree T = (V, E, l).
//   Each leaf maps to a disc of radius = half the path-length to its neighbours.
//   Circles must be packed within the unit square without overlap.
//   The crease pattern is the projection of the touching-circle boundaries
//   (the "active paths").
//
//   Key constraint: For any two flap nodes i, j:
//     |ci - cj| ≥ ri + rj   (no overlap)
//     |ci - cj| = ri + rj   iff path(i,j) is active (generates a crease)
//
// PARAMETERS:
//   creaseDensity – controls the complexity / number of flap nodes
//   foldAngle     – animates the "reveal" from tree diagram to crease pattern
//   showMath      – overlay node labels and radius indicators

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_creaseDensity; // controls #nodes (1–20 range used)
uniform float u_foldAngle;     // [0, 180] — transition tree→CP
uniform bool  u_showMath;

const float PI = 3.14159265358979;

// ── Hash / random ─────────────────────────────────────────────────────────
float hash1(float n) { return fract(sin(n) * 43758.5453); }
vec2  hash2(float n) { return vec2(hash1(n), hash1(n + 7.3)); }

// ── SDF primitives ─────────────────────────────────────────────────────────
float sdCircle(vec2 p, vec2 c, float r) { return length(p - c) - r; }
float sdSegment(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    return length(pa - ba * clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0));
}

// ── Deterministic circle packing for N circles ────────────────────────────
// Returns centre and radius for circle i given total count N.
vec3 packCircle(int i, int N) {
    // Fibonacci phyllotaxis packing
    float golden = 2.399963; // 2π / φ²
    float fi = float(i);
    float fn = float(N);
    float r = sqrt(fi / fn) * 0.45;         // radial distance
    float a = fi * golden;
    vec2  c = vec2(0.5) + r * vec2(cos(a), sin(a));
    // Radius = inversely proportional to local density
    float radius = 0.38 / sqrt(fn) * (0.7 + 0.3 * hash1(fi));
    return vec3(c, radius);
}

// ── Crease line between two circles (active path) ────────────────────────
// The crease is the perpendicular bisector of the segment joining two circles
// whose active path is touching. Approximated here as the midpoint-normal.
float activePath(vec2 uv, vec3 ci, vec3 cj) {
    vec2 mid = (ci.xy + cj.xy) * 0.5;
    vec2 dir = normalize(cj.xy - ci.xy);
    vec2 perp = vec2(-dir.y, dir.x);
    // Render the perpendicular bisector segment through 'mid'
    vec2 a = mid - perp * 0.5;
    vec2 b = mid + perp * 0.5;
    return sdSegment(uv, a, b);
}

// ── Tree edge (stick figure line) ─────────────────────────────────────────
float treeEdge(vec2 uv, vec3 ci, vec3 cj) {
    return sdSegment(uv, ci.xy, cj.xy);
}

// ── Main ──────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float aspect = u_resolution.x / u_resolution.y;
    uv.x *= aspect;

    // Centre the view
    vec2 p = vec2(uv.x / aspect, uv.y);

    int N = int(clamp(u_creaseDensity * 0.18, 3.0, 18.0));

    // Transition factor: 0=tree diagram, 1=crease pattern
    float trans = smoothstep(0.0, 180.0, u_foldAngle);

    vec3 col = vec3(0.96, 0.94, 0.88); // paper

    // ── Draw active-path creases ──────────────────────────────────────────
    for (int i = 0; i < 18; i++) {
        if (i >= N) break;
        vec3 ci = packCircle(i, N);
        for (int j = i + 1; j < 18; j++) {
            if (j >= N) break;
            vec3 cj = packCircle(j, N);
            // Only draw crease if circles are "touching" (active path)
            float gap = length(ci.xy - cj.xy) - ci.z - cj.z;
            if (gap < 0.05) {
                float d = activePath(p, ci, cj);
                float lineW = 0.0025;
                bool isMtn = mod(float(i + j), 2.0) < 1.0;
                vec3 cCol = isMtn ? vec3(0.80, 0.18, 0.12) : vec3(0.15, 0.32, 0.78);
                float line = smoothstep(lineW, lineW * 0.2, d) * trans;
                col = mix(col, cCol, line * 0.85);
            }
        }
    }

    // ── Draw tree edges (fade out as creases fade in) ─────────────────────
    for (int i = 0; i < 17; i++) {
        if (i >= N - 1) break;
        vec3 ci = packCircle(i, N);
        vec3 cj = packCircle(i + 1, N);
        float d = treeEdge(p, ci, cj);
        float line = smoothstep(0.003, 0.0005, d) * (1.0 - trans);
        col = mix(col, vec3(0.3, 0.3, 0.3), line * 0.7);
    }

    // ── Draw circles ──────────────────────────────────────────────────────
    for (int i = 0; i < 18; i++) {
        if (i >= N) break;
        vec3 ci = packCircle(i, N);

        // Circle outline
        float d = sdCircle(p, ci.xy, ci.z);
        float ring = smoothstep(0.004, 0.0, abs(d));
        col = mix(col, vec3(0.5, 0.7, 0.5), ring * (1.0 - trans * 0.8));

        // Circle fill
        float fill = smoothstep(0.0, -0.01, d) * 0.12 * (1.0 - trans);
        col = mix(col, vec3(0.7, 0.9, 0.7), fill);
    }

    // ── Math overlay: radius indicators ───────────────────────────────────
    if (u_showMath) {
        vec3 c0 = packCircle(0, N);
        float radLine = abs(length(p - c0.xy) - c0.z * 0.5);
        col = mix(col, vec3(1.0, 0.8, 0.0), smoothstep(0.003, 0.0, radLine) * 0.6);
    }

    // Vignette
    vec2 cv = p - 0.5;
    col *= 1.0 - 0.25 * dot(cv, cv) * 3.5;

    gl_FragColor = vec4(col, 1.0);
}
