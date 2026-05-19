// waterbomb_tessellation.glsl
// The waterbomb tessellation — a rigid-foldable checkerboard of X-crease squares.
// Named after the traditional waterbomb base (degree-4 vertex, 2M+2V in a cross).
// The tessellation tiles this base across the plane with alternating mountain/valley.
//
// MATHEMATICS:
//   The waterbomb base at each vertex has sector angles of 90° each (4 creases).
//   Kawasaki: 90 - 90 + 90 - 90 = 0 ✓
//   Maekawa: 2M - 2V = 0 ... wait — at a standard waterbomb vertex M=2, V=2, so M-V=0.
//   This violates Maekawa's theorem! Implication: the waterbomb tessellation is NOT
//   globally flat-foldable in the strict sense, but it CAN be rigidly deployed into
//   a 3D curved (doubly-corrugated) surface. It has 1 DOF as a rigid mechanism.
//
//   The key kinematic relationship for the waterbomb vertex (sector angle α = 90°):
//     tan(θ/2) · tan(φ/2) = 1
//   where θ and φ are the two independent dihedral angles. This means:
//     φ = 2·arctan(1 / tan(θ/2))   — fully determined: 1 DOF.
//
//   When deployed, the pattern exhibits a NEGATIVE Poisson ratio (auxetic):
//     ν = −1 (isotropic auxetic in the equilateral case)
//
// PARAMETERS:
//   foldAngle     – deployment angle [0=flat, 180=fully folded]
//   creaseDensity – number of unit cells across
//   shadowDepth   – inter-panel shadow intensity
//   paperColor    – 0=white 1=kraft 2=washi 3=metallic
//   showMath      – overlay vertex-type indicator

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_foldAngle;      // [0, 180]
uniform float u_creaseDensity;  // [1, 100]
uniform float u_shadowDepth;    // [0, 1]
uniform float u_paperColor;     // 0-3
uniform bool  u_showMath;

const float PI     = 3.14159265358979;
const float TWO_PI = 6.28318530717959;

// ── Paper palettes ──────────────────────────────────────────────────────────
vec3 paperPalette(float id) {
    if (id < 0.5) return vec3(0.97, 0.95, 0.90);   // white
    if (id < 1.5) return vec3(0.82, 0.68, 0.48);   // kraft
    if (id < 2.5) return vec3(0.90, 0.88, 0.84);   // washi
    return vec3(0.75, 0.76, 0.82);                  // metallic
}

// ── Waterbomb kinematics ─────────────────────────────────────────────────────
// For α=90° waterbomb vertex: tan(θ/2)·tan(φ/2)=1 → the two dihedral angles
// are complementary in a tan-half sense. Given deployment θ, return φ.
float waterbombPhi(float theta) {
    float th = clamp(theta, 0.001, PI - 0.001);
    return 2.0 * atan(1.0 / tan(th * 0.5));
}

// ── Cell shading ─────────────────────────────────────────────────────────────
// Returns a panel shade value ∈ [0,1] for the waterbomb grid.
// Even and odd checkerboard cells tilt in opposite directions.
float waterbombShade(vec2 uv, float N, float theta) {
    vec2 cell = floor(uv * N);
    vec2 f    = fract(uv * N);

    // Checkerboard parity
    float parity = mod(cell.x + cell.y, 2.0); // 0 or 1

    // The X-crease within each cell splits it into 4 triangular panels.
    // Identify which of the 4 triangles the current pixel falls in.
    // The diagonals are y=x and y=1-x.
    float d1 = f.y - f.x;          // + = upper-left triangle
    float d2 = f.y - (1.0 - f.x);  // + = upper-right triangle

    float triID;
    if      (d1 > 0.0 && d2 > 0.0)  triID = 0.0; // top
    else if (d1 < 0.0 && d2 < 0.0)  triID = 2.0; // bottom
    else if (d1 > 0.0 && d2 < 0.0)  triID = 3.0; // left
    else                              triID = 1.0; // right

    // Tilt angle for each triangle = ±θ/2 or ±φ/2
    float phi = waterbombPhi(theta);
    float t1 = theta * 0.5;
    float t2 = phi   * 0.5;

    // Shading = dot of panel normal with light direction (top-left)
    float tilt;
    if (triID < 0.5)       tilt =  t1;   // top
    else if (triID < 1.5)  tilt = -t2;   // right
    else if (triID < 2.5)  tilt = -t1;   // bottom
    else                   tilt =  t2;   // left

    // Alternate cell orientation for the checkerboard
    tilt *= (parity < 0.5 ? 1.0 : -1.0);

    return 0.5 + 0.48 * sin(tilt);
}

// ── X-crease lines within cell ───────────────────────────────────────────────
// Distance to the nearest of the two diagonals of the current cell.
float xCreaseDist(vec2 uv, float N) {
    vec2 f = fract(uv * N);
    float d1 = abs(f.y - f.x);
    float d2 = abs(f.y - (1.0 - f.x));
    return min(d1, d2) / N; // un-normalise to world space
}

// ── Grid edge lines ──────────────────────────────────────────────────────────
float gridEdgeDist(vec2 uv, float N) {
    vec2 f = fract(uv * N);
    return min(min(f.x, 1.0 - f.x), min(f.y, 1.0 - f.y)) / N;
}

// ── Mountain/valley assignment for X creases ────────────────────────────────
// Mountain = red, Valley = blue. In waterbomb: alternating by cell parity.
vec3 creaseColour(vec2 uv, float N, float theta) {
    vec2 cell  = floor(uv * N);
    vec2 f     = fract(uv * N);
    float par  = mod(cell.x + cell.y, 2.0);

    // Which diagonal is mountain in this cell?
    float d1 = f.y - f.x;
    float d2 = f.y - (1.0 - f.x);
    bool onDiag1 = abs(d1) < abs(d2);

    // Alternate mountain/valley between diagonal type and parity
    bool isMtn = (onDiag1 == (par < 0.5));
    return isMtn ? vec3(0.80, 0.18, 0.12) : vec3(0.15, 0.32, 0.78);
}

// ── Main ────────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float aspect = u_resolution.x / u_resolution.y;
    uv.x *= aspect;

    // Animated fold angle if none provided
    float phi_drive = u_foldAngle > 0.0
        ? u_foldAngle * PI / 180.0
        : (PI * 0.45) * (0.5 + 0.5 * sin(u_time * 0.5));

    float N = max(2.0, u_creaseDensity * 0.35);

    // Shade each panel
    float shade = waterbombShade(uv, N, phi_drive);

    // Paper base
    vec3 paper = paperPalette(u_paperColor);
    vec3 col = paper * shade;

    // Shadow between cells
    float edgeDist = gridEdgeDist(uv, N);
    float edgeShadow = u_shadowDepth * smoothstep(0.008 / N, 0.0, edgeDist);
    col = mix(col, vec3(0.08, 0.06, 0.05), edgeShadow);

    // X-crease lines
    float xDist = xCreaseDist(uv, N);
    float lineW = 0.0018 / N;
    float line  = smoothstep(lineW, lineW * 0.25, xDist);
    vec3 cCol   = creaseColour(uv, N, phi_drive);
    col = mix(col, cCol, line * 0.88);

    // Metallic specular
    if (u_paperColor > 2.5) {
        float spec = pow(max(0.0, shade - 0.55) * 2.2, 3.5);
        col += vec3(0.9, 0.92, 1.0) * spec * 0.5;
    }

    // Math overlay: mark vertices where M-V = 0 (Maekawa violation → not flat-foldable)
    if (u_showMath) {
        vec2 nearVertex = fract(uv * N);
        float vd = min(length(nearVertex), length(nearVertex - 1.0));
        vd = min(vd, min(length(nearVertex - vec2(1,0)), length(nearVertex - vec2(0,1))));
        float vm = smoothstep(0.08, 0.0, vd);
        // Highlight in amber: these vertices have M-V = 0 (Maekawa says ±2 needed for flat-fold)
        col = mix(col, vec3(1.0, 0.75, 0.1), vm * 0.65);
    }

    // Deployment progress bar
    float barY = 0.012;
    if (gl_FragCoord.y / u_resolution.y < barY) {
        float progress = phi_drive / PI;
        col = uv.x / aspect < progress ? vec3(0.25, 0.65, 0.9) : vec3(0.18);
    }

    // Vignette
    vec2 cv = uv - vec2(aspect * 0.5, 0.5);
    col *= 1.0 - 0.22 * dot(cv, cv) * 2.5;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
