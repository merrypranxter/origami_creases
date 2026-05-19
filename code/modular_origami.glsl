// modular_origami.glsl
// Modular origami: multiple identical units interlocked without glue.
// The individual unit (Sonobe, waterbomb, pinwheel) is folded in bulk;
// the assembled whole reveals Platonic solids, stars, and polyhedra.
//
// MODULAR SYSTEMS:
//   Sonobe unit   — parallelogram module with pocket+tab. 3 units = cube corner,
//                   30 units = icosahedron, 90 units = stellated icosahedron.
//   Waterbomb     — square module that locks into octahedra and cubes.
//   Pinwheel      — square module creating rotating central squares; can tile the plane.
//   Kusudama      — flower-petal unit. 12 units → dodecahedral flower ball.
//   PHiZZ         — planar hexagon-based unit. Assembles into any planar graph.
//
// MATHEMATICS:
//   Each modular assembly corresponds to a polyhedron P with:
//     - V vertices, E edges, F faces (Euler: V - E + F = 2)
//     - One module per EDGE (Sonobe-style) or per FACE (flower-ball style)
//   For Sonobe: E modules → P polyhedron. Triangle faces:
//     3 units meet at each vertex → V·3 = 2E → E = 3V/2.
//
//   The Sonobe icosahedron (30 units) verifies:
//     30 edges, 12 vertices, 20 faces — icosahedron ✓
//   The stellated icosahedron (90 units = Sonobe spikes on each of 20 faces):
//     Adds 20 pyramidal spikes. 30 + 20·3 = 90 units ✓
//
// VISUAL MODES:
//   mode 0 — Sonobe unit cell flat diagram
//   mode 1 — Icosahedron assembly (30 Sonobe units, 3D projection)
//   mode 2 — Kusudama flower ball (dodecahedral petal assembly)
//   mode 3 — PHiZZ truncated icosahedron (soccer-ball polyhedron, 90 units)
//
// PARAMETERS:
//   foldAngle     – assembly progress [0=flat units, 180=fully assembled]
//   creaseDensity – detail level of individual unit
//   origamiStyle  – visual mode 0-3
//   mountainRatio – colour balance between unit types

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_foldAngle;
uniform float u_creaseDensity;
uniform float u_origamiStyle;
uniform float u_mountainRatio;

const float PI     = 3.14159265358979;
const float TWO_PI = 6.28318530717959;
const float PHI    = 1.61803398875;  // golden ratio

// ── Utilities ───────────────────────────────────────────────────────────────
float hash(float n)  { return fract(sin(n) * 43758.5453); }
float hash2f(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }

float sdLine(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}
float sdCircle(vec2 p, vec2 c, float r) { return length(p - c) - r; }

// ── Sonobe unit flat diagram ─────────────────────────────────────────────────
// The Sonobe unit is a 1×2 rectangle divided by diagonal creases into a
// central parallelogram with two triangular tab/pocket regions.
float sonobeUnit(vec2 uv, float scale) {
    vec2 p = (uv - 0.5) / scale;
    // Unit is 2 wide × 1 tall, centred at origin
    float inBounds = step(abs(p.x), 1.0) * step(abs(p.y), 0.5);

    // Main diagonal crease (mountain): top-left to bottom-right of left half
    float d1 = sdLine(p, vec2(-1.0, 0.5), vec2(0.0, -0.5));
    // Complementary diagonal crease (valley): right half
    float d2 = sdLine(p, vec2(0.0, 0.5), vec2(1.0, -0.5));
    // Horizontal centre crease (mountain)
    float d3 = abs(p.y);
    // Vertical fold line (valley)
    float d4 = abs(p.x);

    float lineW = 0.03;
    float mtn = smoothstep(lineW, lineW * 0.2, min(d1, d3));
    float val = smoothstep(lineW, lineW * 0.2, min(d2, d4));

    return (mtn * 0.8 + val * 0.5) * inBounds;
}

// ── Icosahedral projection ───────────────────────────────────────────────────
// Approximate icosahedron projection: 20 triangular faces in 5-fold symmetry.
float icoFace(vec2 uv, float t) {
    vec2 c    = uv - 0.5;
    float r   = length(c);
    float a   = atan(c.y, c.x);
    float rot = u_time * 0.2 * (1.0 - t * 0.5);

    float glow = 0.0;
    // 5 visible pentagonal rings (top, 5 upper, 5 lower, bottom)
    for (float ring = 0.0; ring < 4.0; ring++) {
        float ringR = (ring + 1.0) * 0.11;
        float N     = ring < 1.0 ? 1.0 : (ring < 3.0 ? 5.0 : 1.0);
        for (float k = 0.0; k < 5.0; k++) {
            if (k >= N) break;
            float faceA   = k * TWO_PI / N + rot + ring * PI / 5.0;
            vec2  faceCtr = ringR * vec2(cos(faceA), sin(faceA));
            float faceR2  = 0.10 * t;

            // Triangle face SDF (approximate as circle for GPU efficiency)
            float fd = length(c - faceCtr);
            float triA = atan(c.y - faceCtr.y, c.x - faceCtr.x);
            float triSector = PI / 3.0;
            float triEdge = abs(fd * cos(mod(triA, triSector) - triSector * 0.5)
                                - faceR2 * cos(triSector * 0.5));
            glow += smoothstep(0.012, 0.002, triEdge);
        }
    }
    return glow;
}

// ── Kusudama flower petals ────────────────────────────────────────────────────
float kusudamaPetals(vec2 uv, float t) {
    vec2  c = uv - 0.5;
    float r = length(c);
    float a = atan(c.y, c.x);
    float rot = u_time * 0.12;

    float petals = 0.0;
    // 12 pentagonal faces of dodecahedron projected as flower arrangement
    float N = 12.0;
    for (float k = 0.0; k < 12.0; k++) {
        float faceA   = k * TWO_PI / N + rot;
        float faceR   = 0.20 + (k < 1.0 ? 0.0 : 0.18);
        vec2  faceCtr = faceR * vec2(cos(faceA), sin(faceA)) * t;

        // Petal: 5-sided star shape at each face
        float pd = length(c - faceCtr);
        float pa = atan(c.y - faceCtr.y, c.x - faceCtr.x) + faceA;
        float petalShape = 0.06 + 0.03 * cos(pa * 5.0);
        float petal = smoothstep(petalShape, petalShape - 0.015, pd) * t;
        petals += petal;
    }
    return petals;
}

// ── PHiZZ truncated icosahedron (soccer ball) ────────────────────────────────
// Approximated as pentagonal + hexagonal face mosaic.
float phiZZPattern(vec2 uv, float t) {
    vec2 c = (uv - 0.5) * 3.0;
    float r = length(c);
    float a = atan(c.y, c.x);

    // Two-scale hex+pent tiling approximation
    // Hexagonal grid
    float hexA  = floor((a + PI) / (PI / 3.0));
    float hexD  = abs(r - 0.5 - hexA * 0.0);

    // 12 pentagons at phi-spaced angles
    float pentGlow = 0.0;
    for (float k = 0.0; k < 12.0; k++) {
        float pentA = k * TWO_PI / 12.0 + u_time * 0.1;
        float pentR = 0.85;
        vec2  pc    = pentR * vec2(cos(pentA), sin(pentA));
        float pd    = length(c - pc) - 0.28;
        pentGlow += smoothstep(0.02, 0.0, abs(pd));
    }

    // Hexagon faces fill remainder
    float hexGlow = 0.0;
    for (float k = 0.0; k < 20.0; k++) {
        float ha = k * TWO_PI / 20.0 + u_time * 0.07;
        float hr = 0.55 + 0.3 * cos(k * 0.7);
        vec2  hc = hr * vec2(cos(ha), sin(ha));
        float hd = length(c - hc) - 0.22;
        hexGlow += smoothstep(0.02, 0.0, abs(hd));
    }

    return (pentGlow + hexGlow * 0.6) * t;
}

// ── Module colour by index ───────────────────────────────────────────────────
vec3 moduleColour(float id) {
    float h = hash(id) * 0.7 + 0.15;
    // Sonobe traditional: warm variety — red, orange, gold, green, blue, purple
    return 0.6 + 0.4 * cos(vec3(0.0, 2.1, 4.2) + h * TWO_PI);
}

// ── Main ────────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float aspect = u_resolution.x / u_resolution.y;
    uv.x *= aspect;
    vec2 p = vec2(uv.x / aspect, uv.y);

    float t    = u_foldAngle / 180.0;
    int   mode = int(u_origamiStyle);

    vec3 col = vec3(0.97, 0.95, 0.90); // paper white

    if (mode == 0) {
        // ── Sonobe unit flat diagram ───────────────────────────────────────
        float density = max(1.0, u_creaseDensity * 0.15);
        // Tile multiple Sonobe units in a grid
        for (float iy = 0.0; iy < 5.0; iy++) {
            for (float ix = 0.0; ix < 5.0; ix++) {
                vec2 cell = vec2(ix, iy) / 4.0;
                vec2 luv  = (p - cell) * 4.0 + 0.5;
                float u   = sonobeUnit(luv, 0.4 * density);
                float isMtn = float(mod(ix + iy, 2.0) < 1.0);
                vec3  uc    = mix(vec3(0.15, 0.32, 0.78), vec3(0.80, 0.18, 0.12), isMtn);
                col = mix(col, mix(col, uc, u * 0.85), t);
            }
        }

    } else if (mode == 1) {
        // ── Icosahedron assembly ───────────────────────────────────────────
        float ico = icoFace(p, t);
        float faceID = floor(atan(p.y - 0.5, p.x - 0.5) / (PI / 10.0));
        vec3  fCol   = moduleColour(faceID);
        col = mix(col, vec3(0.05, 0.04, 0.06), t * 0.7);   // darken background
        col = mix(col, fCol, clamp(ico * 0.9, 0.0, 1.0));

        // Golden ratio assembly glow
        float glowR = PHI * 0.1 * t;
        float glowPulse = exp(-length(p - 0.5) / glowR) * t * 0.3;
        col += vec3(1.0, 0.85, 0.5) * glowPulse;

    } else if (mode == 2) {
        // ── Kusudama ─────────────────────────────────────────────────────
        float petals = kusudamaPetals(p, t);
        float a      = atan(p.y - 0.5, p.x - 0.5);
        vec3  pCol   = moduleColour(floor(a / (TWO_PI / 12.0)));
        col = mix(col, vec3(0.06, 0.04, 0.08), t * 0.6);
        col = mix(col, pCol, clamp(petals * 0.8, 0.0, 1.0));
        // Central binding point
        float bc = smoothstep(0.03, 0.0, length(p - 0.5));
        col = mix(col, vec3(1.0, 0.9, 0.7), bc * t * 0.7);

    } else {
        // ── PHiZZ truncated icosahedron ────────────────────────────────────
        float phizz = phiZZPattern(p, t);
        float fID   = hash2f(floor((p - 0.5) * 5.0));
        vec3  fCol  = moduleColour(fID * 30.0);
        col = mix(col, vec3(0.04, 0.04, 0.08), t * 0.65);
        col = mix(col, fCol, clamp(phizz * 0.85, 0.0, 1.0));
        // Pentagon markers (purple)
        float pentA = floor(atan(p.y - 0.5, p.x - 0.5) * 12.0 / TWO_PI);
        col = mix(col, vec3(0.6, 0.3, 0.9), phizz * 0.2 * step(0.7, hash(pentA)));
    }

    // Mountain-ratio tint (warm vs cool balance)
    float mtnV = u_mountainRatio - 0.5;
    col *= vec3(1.0 + mtnV * 0.15, 1.0, 1.0 - mtnV * 0.1);

    // Vignette
    vec2 cv = uv - vec2(aspect * 0.5, 0.5);
    col *= 1.0 - 0.3 * dot(cv, cv) * 3.0;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
