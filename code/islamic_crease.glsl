// islamic_crease.glsl
// Islamic geometric patterns as origami crease systems.
// Girih tiles, star polygons, and arabesques fold into 3D muqarnas vaulting.
// The crease is hidden in the flat decoration; the fold reveals the architecture.
//
// CONCEPT (README blend: origami_creases + islamic_tiling):
//   Islamic girih tiles are a set of 5 equilateral polygons that tile the plane
//   and generate star-and-rosette patterns. When treated as crease patterns:
//   - Star polygon POINTS → valley folds (they sink inward toward the viewer)
//   - Connecting BANDS → mountain folds (they rise toward the viewer)
//   - The folded 3D form approximates muqarnas (Islamic stalactite vaulting)
//
//   The Girih tiles: regular decagon (10), elongated hexagon (6), bowtie (6),
//   rhombus (6), pentagon (5). All angles are multiples of 36° (π/5).
//
//   Star polygon n/k (n-pointed, connecting every k-th vertex):
//     Interior angle of star point = (n - 2k) · 180° / n
//   For n=10, k=3: star point angle = (10-6)·18° = 72°.
//   For n=8, k=3:  star point angle = (8-6)·22.5° = 45°.
//
// VISUAL MODES:
//   mode 0 — Flat girih crease pattern (mountain/valley coloured)
//   mode 1 — Folding animation (flat → muqarnas relief)
//   mode 2 — 10-pointed star tessellation (Alhambra-style)
//   mode 3 — Animated arabesques + fold shadows
//
// PARAMETERS:
//   foldAngle     – fold depth [0=flat, 180=fully folded muqarnas]
//   creaseDensity – pattern scale / complexity
//   mountainRatio – mountain/valley balance (symmetry control)
//   origamiStyle  – mode 0-3

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
const float PHI    = 1.61803398875;

// ── Utility ─────────────────────────────────────────────────────────────────
float sdLine(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}
float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }

// ── n/k star polygon SDF ─────────────────────────────────────────────────────
// Distance to the boundary of an n-pointed star connecting every k-th vertex.
float starPolygon(vec2 p, float n, float k, float r) {
    float a = atan(p.y, p.x) + PI / n;
    float sector = TWO_PI / n;
    float sectorA = mod(a, sector) - sector * 0.5;

    // Outer radius (star tip) and inner radius (star notch)
    float outerR = r;
    float innerA = PI * k / n;
    float innerR = r * sin(PI * (0.5 - 1.0 / n)) / sin(PI * (0.5 - 1.0 / n) + innerA);
    innerR = clamp(innerR, r * 0.2, r * 0.8);

    // Interpolate radius between tip and notch
    float t = abs(sectorA) / (sector * 0.5);
    float polyR = mix(outerR, innerR, t);

    return length(p) - polyR;
}

// ── Girih tile crease pattern ────────────────────────────────────────────────
// Returns (distToCrease, isMountain) for a girih-tiled crease pattern.
vec2 girihCrease(vec2 uv, float scale) {
    vec2 p = uv / scale;
    float minD = 1e9;
    float isMtn = 0.0;

    // Tile the 10-fold star pattern on a regular grid
    // Using a dodecagonal (12-fold) base that approximates 10-fold locally
    float cellSize = 1.0;
    for (float ix = -2.0; ix <= 2.0; ix++) {
        for (float iy = -2.0; iy <= 2.0; iy++) {
            vec2 cell   = vec2(ix, iy) * cellSize;
            vec2 offset = p - cell;
            float r     = length(offset);

            // 10-pointed star at each lattice point
            float sd = starPolygon(offset, 10.0, 3.0, 0.45 * cellSize);
            float d  = abs(sd) * scale;

            if (d < minD) {
                minD   = d;
                // Valley at star tips (inward folding), mountain at connectors
                float onTip = step(0.0, sd) * step(sd, 0.05 * cellSize);
                isMtn = 1.0 - onTip;
            }

            // Interstitial 6-pointed star (geometric fill)
            if (r < cellSize * 0.6) {
                float sd6 = abs(starPolygon(offset * 0.7, 6.0, 2.0, 0.25 * cellSize));
                float d6  = sd6 * scale;
                if (d6 < minD) {
                    minD   = d6;
                    isMtn  = hash(cell + vec2(0.3, 0.7));
                }
            }
        }
    }
    return vec2(minD, isMtn);
}

// ── Muqarnas depth function ───────────────────────────────────────────────────
// Simulate the 3D relief depth of folded muqarnas using star geometry.
float muqarnasDepth(vec2 uv, float scale, float phi) {
    vec2 p   = uv / scale;
    float sd = starPolygon(fract(p) - 0.5, 10.0, 3.0, 0.45);
    // Inside star = elevated (mountain), outside = recessed (valley)
    float depth = (sd < 0.0 ? -sd : 0.0) * sin(phi * 0.5) * 0.8;
    return depth;
}

// ── Arabesque scroll ─────────────────────────────────────────────────────────
// Animated flowing arabesque vine pattern overlaid on geometric base.
float arabesque(vec2 uv, float t) {
    float scroll = u_time * 0.15;
    // Scroll curls: interlocked spirals based on golden ratio
    float spiral1 = length(fract(uv * 2.0 + scroll) - 0.5) - 0.2;
    float spiral2 = length(fract(uv * 2.0 - scroll + vec2(0.5)) - 0.5) - 0.2;
    float vine = smoothstep(0.025, 0.005, abs(spiral1)) +
                 smoothstep(0.025, 0.005, abs(spiral2));
    return vine * (1.0 - t * 0.5);
}

// ── Main ─────────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float aspect = u_resolution.x / u_resolution.y;
    uv.x *= aspect;
    vec2 p = vec2(uv.x / aspect, uv.y) - 0.5;

    float t     = u_foldAngle / 180.0;
    float scale = max(0.05, 0.2 / max(1.0, u_creaseDensity * 0.04));
    int   mode  = int(u_origamiStyle);

    // Tilework base colour (terracotta → tile blue gradient)
    float r = length(p);
    vec3 tileBase = mix(vec3(0.95, 0.92, 0.82),  // ivory
                        vec3(0.22, 0.45, 0.68),   // majolica blue
                        0.5 + 0.5 * cos(r * 8.0 - u_time * 0.1));

    vec3 col;

    if (mode == 0) {
        // ── Flat girih crease pattern ──────────────────────────────────────
        col = tileBase;
        vec2 cr    = girihCrease(p, scale);
        float dist = cr.x;
        float mtn  = cr.y;
        float lineW = scale * 0.04;

        float line = smoothstep(lineW, lineW * 0.15, dist);
        vec3  cCol = mix(vec3(0.15, 0.32, 0.78), vec3(0.80, 0.18, 0.12), mtn);
        col = mix(col, cCol, line * 0.90);

    } else if (mode == 1) {
        // ── Fold animation (flat → muqarnas) ──────────────────────────────
        col = tileBase;
        // Muqarnas depth shading
        float depth = muqarnasDepth(p + 0.5, scale, t * PI);
        col *= 1.0 - depth * u_mountainRatio;
        col += vec3(0.9, 0.85, 0.7) * depth * 0.4;

        // Crease lines
        vec2 cr    = girihCrease(p, scale);
        float lineW = scale * 0.035;
        float line  = smoothstep(lineW, lineW * 0.15, cr.x);
        vec3  cCol  = cr.y > 0.5 ? vec3(0.80, 0.18, 0.12) : vec3(0.15, 0.32, 0.78);
        col = mix(col, cCol, line * mix(0.9, 0.5, t));

        // Shadow under raised muqarnas
        float shadow = muqarnasDepth(p + 0.5 + vec2(0.01, -0.01) * t, scale, t * PI);
        col = mix(col, vec3(0.05, 0.03, 0.02), shadow * t * 0.5);

    } else if (mode == 2) {
        // ── 10-pointed star tessellation (Alhambra-style) ──────────────────
        col = tileBase;
        // High-density star lattice
        float denseScale = scale * 0.5;
        for (float ix = -3.0; ix <= 3.0; ix++) {
            for (float iy = -3.0; iy <= 3.0; iy++) {
                vec2 starCtr = vec2(ix, iy) * denseScale * 1.2;
                float sd = starPolygon(p - starCtr, 10.0, 3.0, denseScale * 0.45);

                // Fill: tile blue inside stars
                float fill = smoothstep(0.002, -0.002, sd);
                vec3 fillCol = 0.55 + 0.45 * cos(vec3(0.0, 2.1, 4.2) + atan(starCtr.y, starCtr.x));
                col = mix(col, fillCol, fill * 0.75 * t + fill * 0.3 * (1.0 - t));

                // Star outline (grouted tile edge)
                float lineW = denseScale * 0.05;
                float line  = smoothstep(lineW, 0.0, abs(sd));
                col = mix(col, vec3(0.15, 0.12, 0.10), line * 0.8);
            }
        }

    } else {
        // ── Arabesque + fold shadow animation ─────────────────────────────
        col = mix(vec3(0.08, 0.06, 0.04), tileBase, 0.7);  // darker ground

        // Geometric star base
        float sd = starPolygon(p * 3.0, 8.0, 3.0, 1.2);
        col = mix(col, vec3(0.92, 0.75, 0.45), smoothstep(0.04, 0.0, abs(sd)) * 0.7);

        // Arabesque scroll overlay
        float vine = arabesque(p * 3.0 + 0.5, t);
        col = mix(col, vec3(0.20, 0.55, 0.30), vine * 0.6 * (1.0 - t * 0.4));

        // Crease pattern emerging
        vec2 cr    = girihCrease(p, scale * 0.8);
        float lineW = scale * 0.03;
        float line  = smoothstep(lineW, lineW * 0.1, cr.x);
        vec3  cCol  = cr.y > 0.5 ? vec3(0.80, 0.18, 0.12) : vec3(0.15, 0.32, 0.78);
        col = mix(col, cCol, line * t * 0.9);
    }

    // Gold accent: gilded crease intersections
    vec2 pHex = fract(p / scale + 0.5) - 0.5;
    float goldDot = smoothstep(0.04, 0.0, length(pHex));
    col = mix(col, vec3(1.0, 0.82, 0.35), goldDot * 0.3 * (0.5 + 0.5 * sin(u_time * 0.5)));

    // Vignette
    vec2 cv = uv - vec2(aspect * 0.5, 0.5);
    col *= 1.0 - 0.35 * dot(cv, cv) * 3.5;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
