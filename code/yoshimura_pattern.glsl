// yoshimura_pattern.glsl
// Yoshimura diamond-fold pattern — the natural buckling mode of thin cylindrical
// shells under axial compression. First described by Yoshimaru Yoshimura (1955).
// Used in crash-energy-absorbing tubes, deployable cylinders, and corrugated structures.
//
// MATHEMATICS:
//   The Yoshimura pattern tiles a cylinder with diamond (rhombus) cells.
//   On a cylinder of radius R, the cell has:
//     - Axial half-length: h = π·R / N  (N diamonds around circumference)
//     - Diagonal aspect ratio: governed by buckling wave number
//
//   Unrolled flat, the pattern is a parallelogram grid with:
//     - Long diagonal (mountain) along cylinder axis
//     - Short diagonal (valley) perpendicular to axis
//     - Sector angle β at the acute corners satisfies:
//         cos(β) = (1 − cos²(α)) / (1 + cos²(α))
//       where α is the half-angle of the diamond at the axial poles.
//
//   The Yoshimura cylinder has multiple DOF — unlike Miura-ori's single DOF.
//   It can compress axially, rotate, and deform locally.
//
// VISUAL MODES:
//   mode 0 — flat crease pattern (unrolled cylinder)
//   mode 1 — cylindrical 3D projection (wrapped/shaded)
//   mode 2 — axial compression animation (buckling in progress)
//
// PARAMETERS:
//   foldAngle     – axial compression [0=uncompressed, 180=fully buckled]
//   creaseDensity – number of diamond columns N
//   origamiStyle  – 0=flat 1=cylindrical 2=compression
//   shadowDepth   – inter-panel shadow depth

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_foldAngle;
uniform float u_creaseDensity;
uniform float u_origamiStyle;  // 0=flat, 1=cylinder, 2=compress
uniform float u_shadowDepth;

const float PI     = 3.14159265358979;
const float TWO_PI = 6.28318530717959;

// ── Utility ─────────────────────────────────────────────────────────────────
float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }

float sdSegment(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    return length(pa - ba * clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0));
}

// ── Yoshimura diamond grid ───────────────────────────────────────────────────
// Returns distance to nearest diamond crease and mountain flag.
// The diamond grid: staggered rows of vertical and diagonal creases.
vec2 yoshimuraCrease(vec2 uv, float N, float compression) {
    // Diamond cell size: N columns, M rows
    float cellW = 1.0 / N;
    float cellH = cellW * 1.2; // aspect ratio of diamond

    // Apply axial compression along Y
    float compress = 1.0 - 0.6 * compression;
    vec2  suv = vec2(uv.x, uv.y * compress + (1.0 - compress) * 0.5);

    vec2 cell = floor(suv / vec2(cellW, cellH));
    vec2 f    = fract(suv / vec2(cellW, cellH));

    // Diamond diagonals within cell
    // Long diagonal (mountain, red): top-left to bottom-right
    // Short diagonal (valley, blue): top-right to bottom-left
    float diagLong  = abs(f.y - f.x);       // long diagonal: y=x line
    float diagShort = abs(f.y - (1.0 - f.x)); // short diagonal: y=1-x

    // Offset every other row
    float rowOffset = mod(cell.y, 2.0) * 0.5;
    float fxShifted = fract(f.x + rowOffset);
    float diagLong2  = abs(f.y - fxShifted);
    float diagShort2 = abs(f.y - (1.0 - fxShifted));

    float minDist = min(min(diagLong, diagShort), min(diagLong2, diagShort2));
    // Normalise to world space
    minDist *= min(cellW, cellH);

    // Mountain if on long diagonal, valley if short
    float isMtn = float(min(diagLong, diagLong2) < min(diagShort, diagShort2));
    return vec2(minDist, isMtn);
}

// ── Cylindrical projection shading ──────────────────────────────────────────
// Simulate a cylinder viewed from a slight angle, with N diamonds around it.
float cylinderShade(vec2 uv, float N, float t) {
    // Map uv.x to cylinder angle
    float angle = (uv.x - 0.5) * PI;  // ±π/2 visible range
    float cosA  = cos(angle);

    // Lighting: simple diffuse from left-front
    vec3 normal   = vec3(cosA, 0.0, sin(angle));
    vec3 light    = normalize(vec3(0.6, 0.4, 0.8));
    float diffuse = dot(normal, light) * 0.5 + 0.5;

    // Diamond row ripples from compression
    float ripple  = sin(uv.y * N * PI + u_time * 0.4) * 0.08 * t;

    return clamp(diffuse + ripple, 0.0, 1.0);
}

// ── Buckling wave animation ──────────────────────────────────────────────────
// Radially expanding buckling front
float bucklingFront(vec2 uv, float t) {
    vec2  c = uv - 0.5;
    float r = length(c);
    float front = mod(u_time * 0.3, 1.0);
    float wave = smoothstep(0.015, 0.0, abs(r - front));
    return wave * t * (1.0 - front);
}

// ── Main ────────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float aspect = u_resolution.x / u_resolution.y;
    uv.x *= aspect;

    float t = u_foldAngle / 180.0;
    float N = max(3.0, u_creaseDensity * 0.2);
    int   mode = int(u_origamiStyle);

    // Paper base: slightly warm
    vec3 paper = vec3(0.96, 0.93, 0.87);
    vec3 col   = paper;

    if (mode == 0) {
        // ── Flat crease pattern ────────────────────────────────────────────
        vec2 cr   = yoshimuraCrease(vec2(uv.x / aspect, uv.y), N, t);
        float dist = cr.x;
        float mtn  = cr.y;

        float lineW = 0.0014;
        float line  = smoothstep(lineW, lineW * 0.2, dist);
        vec3  cCol  = mtn > 0.5 ? vec3(0.78, 0.16, 0.10) : vec3(0.14, 0.30, 0.80);
        col = mix(col, cCol, line * 0.88);

        // Panel shade: alternating diamonds
        vec2 cell = floor(vec2(uv.x / aspect, uv.y) * N * 1.2);
        float shd = 0.5 + 0.15 * sin(cell.x * PI + cell.y * PI) * t;
        col *= shd + 0.5;

    } else if (mode == 1) {
        // ── Cylindrical projection ─────────────────────────────────────────
        float shade = cylinderShade(vec2(uv.x / aspect, uv.y), N, t);
        col *= shade;

        // Diamond crease on cylinder surface
        // Map x to angular coordinate, y stays as height
        float cylX = (uv.x / aspect - 0.5) * PI; // angle ∈ [-π/2, π/2]
        float cylUVx = (sin(cylX) * 0.5 + 0.5);  // back to [0,1]
        vec2 cr   = yoshimuraCrease(vec2(cylUVx, uv.y), N, t);
        float dist = cr.x;
        float mtn  = cr.y;

        float lineW = 0.0012;
        float line  = smoothstep(lineW, lineW * 0.15, dist);
        vec3  cCol  = mtn > 0.5 ? vec3(0.80, 0.18, 0.12) : vec3(0.15, 0.32, 0.78);
        col = mix(col, cCol, line * 0.75 * cos(cylX)); // fade at cylinder edge

        // Shadow depth
        float edgeD = 0.5 - abs(uv.x / aspect - 0.5);
        col *= 1.0 - u_shadowDepth * 0.4 * smoothstep(0.5, 0.1, edgeD);

    } else {
        // ── Axial compression / buckling ──────────────────────────────────
        // Animate compression progressing from t=0 to t=1
        float animT = t + 0.3 * sin(u_time * 0.4);
        animT = clamp(animT, 0.0, 1.0);

        vec2 cr   = yoshimuraCrease(vec2(uv.x / aspect, uv.y), N, animT);
        float dist = cr.x;
        float mtn  = cr.y;
        float lineW = 0.0015;
        float line  = smoothstep(lineW, lineW * 0.2, dist);
        vec3  cCol  = mtn > 0.5 ? vec3(0.78, 0.16, 0.10) : vec3(0.14, 0.30, 0.80);
        col = mix(col, cCol, line * 0.85);

        // Buckling front wave
        float bf = bucklingFront(vec2(uv.x / aspect, uv.y), animT);
        col = mix(col, vec3(1.0, 0.85, 0.3), bf * 0.6);

        // Energy concentration at ridge intersections
        float ridge = smoothstep(0.003, 0.0, dist) * animT;
        col = mix(col, vec3(1.0, 0.95, 0.7), ridge * 0.3);

        // Shadow deepens with compression
        col *= 1.0 - animT * u_shadowDepth * 0.4;
    }

    // Vignette
    vec2 cv = uv - vec2(aspect * 0.5, 0.5);
    col *= 1.0 - 0.28 * dot(cv, cv) * 2.5;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
