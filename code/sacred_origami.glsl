// sacred_origami.glsl
// The fold as ritual. Origami as sacred geometry.
// Senbazuru (1000 cranes), tessellation mandalas, modular sacred polyhedra,
// and the creation myth: "In the beginning, the universe was flat. Then it folded."
//
// SACRED ORIGAMI CONCEPTS:
//   Senbazuru  — 1000 paper cranes. Each fold is a prayer. The sum is a blessing.
//   Sri Yantra — concentric triangles as crease pattern (9 interlocking triangles)
//   Stella Octangula — 8-pointed star, modular origami, stellated octahedron
//   Flower of Life — hex tessellation with circular folds
//   Kusudama — modular origami flower sphere (not single-sheet, but sacred form)
//
// PARAMETERS:
//   foldAngle     – ritual completion [0=empty, 180=fully consecrated]
//   creaseDensity – mandala complexity / concentric layers
//   mountainRatio – balance of expansion (mountain) vs contraction (valley)
//   origamiStyle  – 0=senbazuru, 1=sri yantra, 2=flower of life, 3=kusudama

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_foldAngle;
uniform float u_creaseDensity;
uniform float u_mountainRatio;
uniform float u_origamiStyle;

const float PI     = 3.14159265358979;
const float TWO_PI = 6.28318530717959;
const float PHI    = 1.61803398875; // golden ratio

// ── Utility ───────────────────────────────────────────────────────────────
float sdLine(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}
float sdCircle(vec2 p, vec2 c, float r) { return length(p - c) - r; }
float hash(float n) { return fract(sin(n) * 43758.5453); }

// ── Senbazuru — 1000 cranes in formation ─────────────────────────────────
vec3 senbazuru(vec2 uv, float consecrate) {
    float t = u_time * 0.3;
    vec2 c = uv - 0.5;
    float r = length(c);
    float a = atan(c.y, c.x);

    // Cranes arranged in concentric rings — each a prayer
    float N = floor(u_creaseDensity * 0.5 + 3.0);
    float glow = 0.0;
    for (float ring = 1.0; ring < 8.0; ring++) {
        if (ring > N * 0.5) break;
        float rRing = ring * 0.06;
        float numCranes = ring * 6.0;
        float craneAngle = TWO_PI / numCranes;
        // Each crane: a small triangular fold (wing shape)
        float craneA = mod(a + t * 0.1 * (1.0 / ring), craneAngle) - craneAngle * 0.5;
        float craneDist = abs(r - rRing) + abs(craneA) * rRing;
        float craneProb = consecrate * smoothstep(1.0, 0.0, ring / N);
        glow += smoothstep(0.012, 0.0, craneDist) * craneProb;
    }

    // Central crane — the 1000th
    float centralWing = abs(abs(c.x) - abs(c.y)) - 0.01;
    float centralBody = length(c) - 0.02;
    float centralCrane = smoothstep(0.008, 0.0, min(abs(centralWing), abs(centralBody))) * consecrate;

    vec3 col = vec3(0.05, 0.04, 0.06); // void
    col = mix(col, vec3(0.95, 0.90, 0.85), glow * 0.8);           // crane white
    col = mix(col, vec3(1.00, 0.85, 0.70), centralCrane);          // gold centre
    // Prayer glow
    float prayer = exp(-r * 4.0) * consecrate * 0.3;
    col += vec3(1.0, 0.9, 0.7) * prayer;

    return col;
}

// ── Sri Yantra — 9 interlocking triangles ─────────────────────────────────
vec3 sriYantra(vec2 uv, float consecrate) {
    vec2 c = uv - 0.5;
    float lineW = 0.003;
    float col1 = 0.0;

    // 4 upward triangles (Shiva — expansion, mountain fold)
    // 5 downward triangles (Shakti — contraction, valley fold)
    for (float k = 0.0; k < 9.0; k++) {
        float size = 0.45 - k * 0.04;
        bool upward = mod(k, 2.0) < 1.0;
        float dir = upward ? 1.0 : -1.0;

        // Triangle edges
        vec2 p1 = size * vec2(0.0, dir);
        vec2 p2 = size * vec2(-0.866, -dir * 0.5);
        vec2 p3 = size * vec2( 0.866, -dir * 0.5);

        float e1 = sdLine(c, p1, p2);
        float e2 = sdLine(c, p2, p3);
        float e3 = sdLine(c, p3, p1);
        float tri = min(min(e1, e2), e3);

        float progress = smoothstep(1.0 - (k + 1.0) / 9.0, 1.0 - k / 9.0, consecrate);
        col1 += smoothstep(lineW, 0.0, tri) * progress;
    }

    // Central bindu point
    float bindu = smoothstep(0.012, 0.0, length(c) - 0.008) * consecrate;

    // Concentric lotuses (outer)
    float N = u_creaseDensity * 0.2 + 4.0;
    float petalGlow = 0.0;
    for (float p = 0.0; p < 16.0; p++) {
        if (p >= N) break;
        float a = p * TWO_PI / N + u_time * 0.05;
        vec2 petal = 0.47 * vec2(cos(a), sin(a));
        petalGlow += smoothstep(0.04, 0.0, length(c - petal)) * consecrate;
    }

    vec3 col = vec3(0.08, 0.04, 0.02);
    col = mix(col, vec3(0.95, 0.85, 0.55), col1 * 0.9);
    col = mix(col, vec3(1.00, 0.95, 0.85), bindu);
    col += vec3(1.0, 0.7, 0.3) * petalGlow * 0.5;
    return col;
}

// ── Flower of Life — hexagonal tessellation ────────────────────────────────
vec3 flowerOfLife(vec2 uv, float consecrate) {
    vec2 c = (uv - 0.5) * 4.0;
    float r = 0.5 + u_creaseDensity * 0.02;
    float glow = 0.0;

    // Hexagonal grid of circles
    vec2 hex = vec2(1.0, sqrt(3.0) * 0.5);
    for (float ix = -4.0; ix <= 4.0; ix++) {
        for (float iy = -4.0; iy <= 4.0; iy++) {
            vec2 centre = ix * hex + iy * vec2(0.5, sqrt(3.0) * 0.5);
            float d = abs(sdCircle(c, centre, r));
            float reveal = smoothstep(1.0, 0.0, length(centre) / 3.5) * consecrate;
            glow += smoothstep(0.04, 0.0, d) * reveal;
        }
    }

    float t = u_time * 0.2;
    vec3 col = vec3(0.04, 0.06, 0.10);
    vec3 ringCol = 0.6 + 0.4 * cos(vec3(0.0, 1.0, 2.0) + length(c) * 2.0 - t);
    col = mix(col, ringCol, glow * 0.8);
    return col;
}

// ── Kusudama — modular flower sphere ──────────────────────────────────────
vec3 kusudama(vec2 uv, float consecrate) {
    vec2 c = uv - 0.5;
    float t = u_time * 0.15;
    float r = length(c);
    float a = atan(c.y, c.x);

    // 12 pentagonal faces projected as flower petals
    float N = 12.0;
    float petals = 0.0;
    for (float k = 0.0; k < 12.0; k++) {
        float faceAngle = k * TWO_PI / N + t;
        float faceR = 0.18 + PHI * 0.04;
        vec2 faceCentre = faceR * vec2(cos(faceAngle), sin(faceAngle));
        float petal = exp(-length(c - faceCentre) * 10.0);
        float bloom = consecrate * smoothstep(0.3, 1.0, consecrate);
        petals += petal * bloom;
    }

    // Central fold-star
    float starRays = 5.0;
    float star = abs(sin(a * starRays * 0.5 + t)) * 0.5;
    float starGlow = smoothstep(star + 0.01, star - 0.01, r) * consecrate;

    vec3 col = vec3(0.06, 0.04, 0.08);
    col = mix(col, vec3(0.95, 0.75, 0.85), petals * 0.7);
    col = mix(col, vec3(1.00, 0.95, 0.90), starGlow * 0.6);
    col += vec3(0.8, 0.5, 1.0) * exp(-r * 5.0) * consecrate * 0.3;
    return col;
}

// ── Main ──────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float consecrate = u_foldAngle / 180.0;
    int mode = int(u_origamiStyle);

    vec3 col;
    if (mode == 0)      col = senbazuru(uv, consecrate);
    else if (mode == 1) col = sriYantra(uv, consecrate);
    else if (mode == 2) col = flowerOfLife(uv, consecrate);
    else                col = kusudama(uv, consecrate);

    // Mountain-valley balance tint (sacred equilibrium)
    float mtnV = u_mountainRatio - 0.5; // +ve = more mountain (expansion)
    col = mix(col, col * vec3(1.1, 0.9, 0.8), mtnV * 0.4);

    // Vignette (sacred darkness at edges)
    vec2 cv = uv - 0.5;
    col *= 1.0 - 0.45 * dot(cv, cv) * 4.5;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
