// kresling_tower.glsl
// Kresling tower — the helical twist-fold mechanism.
// A deployable cylinder where opening and closing involves simultaneous rotation.
// Based on natural helix-buckling patterns studied by Biruta Kresling.
//
// MATHEMATICS:
//   The Kresling pattern wraps right triangles helically around a cylinder.
//   Each unit cell is a parallelogram (when unrolled) with:
//     - Height:    h = 2·R·sin(π/N) · tan(β)
//     - Twist:     Δθ = π/N per half-cell (N = number of panels around circumference)
//     - Fold angle β controls both the height and the rotational deployment.
//
//   The kinematic coupling is:
//     cos(β) = 1 − 2·sin²(π/N)·sin²(θ/2)
//   where θ is the twist angle between top and bottom rings.
//
//   This means the tower CANNOT be deployed without twisting — height and
//   rotation are coupled. This is the defining property of the Kresling mechanism.
//
//   It has exactly 1 DOF (like Miura-ori), making it a clean mechanism.
//   Used in: deployable robotic joints, soft actuators, compact space structures.
//
// PARAMETERS:
//   foldAngle     – twist/deployment [0=fully compressed, 180=fully extended]
//   creaseDensity – number of panel facets N around circumference [3–12]
//   shadowDepth   – facet shadow intensity
//   origamiStyle  – 0=single tower, 1=stacked towers, 2=top-down view, 3=unrolled

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_foldAngle;
uniform float u_creaseDensity;
uniform float u_shadowDepth;
uniform float u_origamiStyle;

const float PI     = 3.14159265358979;
const float TWO_PI = 6.28318530717959;

// ── Kresling kinematics ──────────────────────────────────────────────────────
// Given deployment parameter t ∈ [0,1], return (twist_angle, height_fraction).
vec2 kreslingKinematics(float t, float N) {
    // Half-angle for N-gon panel
    float alpha = PI / N;
    // cos(beta) = 1 - 2*sin²(alpha)*sin²(theta/2)
    // At t=1: theta = pi/2 (quarter twist per cell), at t=0: theta = 0
    float theta  = t * PI * 0.5;
    float cosBeta = 1.0 - 2.0 * sin(alpha) * sin(alpha) * sin(theta * 0.5) * sin(theta * 0.5);
    cosBeta = clamp(cosBeta, -1.0, 1.0);
    float beta   = acos(cosBeta);
    // Height fraction proportional to sin(beta)
    float height = sin(beta);
    return vec2(theta, height);
}

// ── Single tower projection ──────────────────────────────────────────────────
// Returns shading for a Kresling tower viewed from the side.
// Approximates the 3D cylinder as a flat rendering with twist lines.
float towerShade(vec2 uv, float N, float t, float numRings) {
    float theta  = kreslingKinematics(t, N).x;
    float height = kreslingKinematics(t, N).y;

    // Map uv to cylindrical coordinates
    float cylX = (uv.x - 0.5) * PI;  // angle ∈ [-π/2, π/2]
    float cosA  = cos(cylX);

    // Diffuse shading
    float shade = cosA * 0.5 + 0.5;

    // Twist stripe pattern: helix bands
    float helix = sin(uv.y * numRings * PI - cylX * N * 0.5 + theta * float(int(uv.y * numRings)));
    float stripeShade = 0.08 * helix * (1.0 - t * 0.3);

    return clamp(shade + stripeShade, 0.2, 1.0);
}

// ── Kresling crease lines on cylinder ───────────────────────────────────────
// Returns distance to the nearest Kresling crease.
float kreslingCrease(vec2 uv, float N, float t, float numRings) {
    vec2 kin = kreslingKinematics(t, N);
    float theta = kin.x;

    // Map x to angle around cylinder
    float angle = (uv.x - 0.5) * TWO_PI;

    // Per-ring height band
    float ringH = 1.0 / numRings;
    float ringID = floor(uv.y / ringH);
    float ringF  = fract(uv.y / ringH);

    // Kresling crease: diagonal line from bottom-left to top-right (with twist)
    // Each panel spans 2π/N in angle and ringH in height
    float panelAngle = TWO_PI / N;
    float panelID    = floor(angle / panelAngle);
    float panelF_a   = fract(angle / panelAngle);

    // Alternating diagonal: even panels go /, odd panels go \
    float diagDir = mod(panelID + ringID, 2.0) < 1.0 ? 1.0 : -1.0;
    float diag = abs(ringF - (diagDir > 0.0 ? panelF_a : (1.0 - panelF_a)));

    // Include twist displacement
    float twistOffset = theta * 0.3 * ringF;
    float panelF_twist = fract(panelF_a + twistOffset);
    float diag2 = abs(ringF - panelF_twist);

    return min(diag, diag2) * ringH;
}

// ── Top-down view of N-gon cross section ────────────────────────────────────
// Shows the rotating polygon as it deploys.
float topViewPolygon(vec2 uv, float N, float t) {
    vec2 c = uv - 0.5;
    float r = length(c);
    float a = atan(c.y, c.x);

    vec2 kin = kreslingKinematics(t, N);
    float twist = kin.x;

    // N-gon at radius R, rotated by twist
    float polyR = 0.35;
    float sectorA = TWO_PI / N;
    float sectorF = mod(a - twist, sectorA);
    // Distance to nearest polygon edge (simplified: use SDF of regular polygon)
    float polyEdge = abs(r * cos(sectorF - sectorA * 0.5) - polyR * cos(sectorA * 0.5));

    // Inner polygon (compressed state)
    float innerR = polyR * (1.0 - t * 0.4);
    float innerEdge = abs(r - innerR);

    return min(polyEdge, innerEdge);
}

// ── Unrolled crease pattern ──────────────────────────────────────────────────
// When unrolled flat, the Kresling pattern = parallelogram grid of right triangles.
float unrolledPattern(vec2 uv, float N, float t) {
    float numRings = max(2.0, u_creaseDensity * 0.1);
    float cellW = 1.0 / N;
    float cellH = 1.0 / numRings;
    vec2  f     = fract(uv / vec2(cellW, cellH));

    // Main diagonal crease: left-right or right-left depending on cell parity
    vec2 cell = floor(uv / vec2(cellW, cellH));
    float parity = mod(cell.x + cell.y, 2.0);
    float diag = parity < 0.5 ? abs(f.y - f.x) : abs(f.y - (1.0 - f.x));

    return diag * min(cellW, cellH);
}

// ── Main ────────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float aspect = u_resolution.x / u_resolution.y;
    uv.x *= aspect;
    vec2 p = vec2(uv.x / aspect, uv.y); // square coords

    float t    = u_foldAngle / 180.0;
    float N    = clamp(floor(u_creaseDensity * 0.12 + 3.0), 3.0, 12.0);
    int   mode = int(u_origamiStyle);
    float numRings = max(2.0, u_creaseDensity * 0.08 + 2.0);

    vec3 paper = vec3(0.96, 0.93, 0.87);
    vec3 col   = paper;

    if (mode == 0 || mode == 1) {
        // ── Single or stacked tower view ──────────────────────────────────
        // Cylinder bounds
        float cx = abs(p.x - 0.5);
        float cylRadius = 0.38;
        float onCyl = step(cx, cylRadius);

        // Cylinder shading
        float shade = towerShade(p, N, t, numRings * (mode == 1 ? 3.0 : 1.0));
        col *= mix(1.0, shade, onCyl);

        // Kresling crease lines
        float cd   = kreslingCrease(p, N, t, numRings * (mode == 1 ? 3.0 : 1.0));
        float lineW = 0.008;
        float line  = smoothstep(lineW, lineW * 0.1, cd) * onCyl;
        // Creases: mountain (red) on ascending diagonals, valley (blue) on descending
        float cellW = 1.0 / N;
        float angle = (p.x - 0.5) * TWO_PI;
        float panelID = floor(angle / (TWO_PI / N));
        float ringID  = floor(p.y * numRings);
        bool  isMtn   = mod(panelID + ringID, 2.0) < 1.0;
        vec3  cCol    = isMtn ? vec3(0.80, 0.18, 0.12) : vec3(0.15, 0.32, 0.78);
        col = mix(col, cCol, line * 0.85);

        // Cylinder edge highlight
        float edgeD = abs(cx - cylRadius);
        col = mix(col, vec3(0.3, 0.3, 0.35), smoothstep(0.003, 0.0, edgeD) * 0.5);

        // Shadow from u_shadowDepth
        col *= 1.0 - onCyl * (1.0 - shade) * u_shadowDepth * 0.5;

    } else if (mode == 2) {
        // ── Top-down view ─────────────────────────────────────────────────
        float d = topViewPolygon(p, N, t);
        float lineW = 0.006;
        float line  = smoothstep(lineW, lineW * 0.15, d);

        col = mix(col, vec3(0.80, 0.18, 0.12), line * 0.8);

        // Rotation indicator
        float rot = kreslingKinematics(t, N).x;
        float arc = abs(length(p - 0.5) - 0.42);
        float arcLine = smoothstep(0.004, 0.0, arc);
        col = mix(col, vec3(0.3, 0.7, 0.4), arcLine * 0.5);

        // Twist angle label (visual only: sweep arc)
        float a = atan(p.y - 0.5, p.x - 0.5);
        float sweep = step(0.0, a) * step(a, rot);
        col = mix(col, vec3(0.4, 0.8, 0.5), sweep * smoothstep(0.45, 0.4, length(p - 0.5)) * 0.3);

    } else {
        // ── Unrolled crease pattern ───────────────────────────────────────
        float d = unrolledPattern(p, N, t);
        float lineW = 0.004;
        float line  = smoothstep(lineW, lineW * 0.2, d);

        vec2  cell  = floor(p * vec2(N, numRings));
        bool  isMtn = mod(cell.x + cell.y, 2.0) < 1.0;
        vec3  cCol  = isMtn ? vec3(0.80, 0.18, 0.12) : vec3(0.15, 0.32, 0.78);
        col = mix(col, cCol, line * 0.88);

        // Twist indicator: shift the grid slightly
        float twistAmount = kreslingKinematics(t, N).x;
        vec2  shifted = fract(p * vec2(N, numRings) + vec2(twistAmount * 0.3, 0.0));
        float shiftLine = smoothstep(0.04, 0.0, abs(shifted.x - 0.5));
        col = mix(col, vec3(0.4, 0.8, 0.5), shiftLine * 0.2 * t);
    }

    // Vignette
    vec2 cv = uv - vec2(aspect * 0.5, 0.5);
    col *= 1.0 - 0.25 * dot(cv, cv) * 2.8;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
