// origami_architecture.glsl
// Architecture that folds: deployable shelters, kinetic building facades,
// transforming interiors, and origami-inspired structural skins.
// From Zaha Hadid's continuous surfaces to adaptive building envelopes.
//
// ARCHITECTURAL ORIGAMI SYSTEMS:
//
//   Kinetic facade — panels that fold open/close to modulate light and privacy.
//     Each panel obeys a constrained mechanism (1 DOF per row or per column).
//     Actuated by a single motor or user hand: "one pull, whole facade moves."
//
//   Folded plate structure — flat panels assembled at angles to create structural
//     depth without material volume. Folds ARE the structure.
//     Key principle: a flat sheet has zero bending stiffness in one direction;
//     a folded zigzag has stiffness ∝ d² (depth squared) in that direction.
//
//   Deployable shelter — flat-packed emergency housing. Each module:
//     Packs at 1/8 original volume (Miura-ori: packs to 1/(M·N·cos(α)))
//     Deploys in <5 minutes with 1 person, no tools.
//
//   Transforming interior — furniture and partition walls that fold into floors
//     or ceilings when not in use. Tokyo micro-apartment maximalism.
//
// VISUAL MODES:
//   mode 0 — Kinetic facade elevation (building skin with opening panels)
//   mode 1 — Folded plate structure (zigzag structural section)
//   mode 2 — Deployable shelter deployment sequence
//   mode 3 — Continuous Zaha Hadid-style folded surface
//
// PARAMETERS:
//   foldAngle     – facade opening angle / deployment progress [0, 180]
//   creaseDensity – number of facade panels or structure bays
//   shadowDepth   – structural shadow depth / wall thickness effect
//   origamiStyle  – mode 0-3

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

// ── Utilities ────────────────────────────────────────────────────────────────
float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
vec2 hash2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453);
}
float noise(vec2 p) {
    vec2 i = floor(p), f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(hash2(i),             f),
                   dot(hash2(i + vec2(1,0)), f - vec2(1,0)), u.x),
               mix(dot(hash2(i + vec2(0,1)), f - vec2(0,1)),
                   dot(hash2(i + vec2(1,1)), f - vec2(1,1)), u.x), u.y);
}

// ── Kinetic facade ───────────────────────────────────────────────────────────
// A grid of panels that rotate/fold to open, revealing interior light.
vec3 kineticFacade(vec2 uv, float phi) {
    float N = max(3.0, u_creaseDensity * 0.15);
    float M = N * 0.6; // rows vs columns
    float cellW = 1.0 / N;
    float cellH = 1.0 / M;

    vec2 cell = floor(uv / vec2(cellW, cellH));
    vec2 f    = fract(uv / vec2(cellW, cellH));

    // Each panel row opens at slightly different time (wave propagation)
    float rowDelay = cell.y / M * 0.4;
    float panelPhi = clamp(phi - rowDelay, 0.0, PI);

    // Panel open fraction: 0=closed, 1=fully open
    float openFrac  = sin(panelPhi * 0.5);

    // Panel geometry: a rectangle that rotates about its top edge
    float panelTop  = 1.0 - f.y;  // 0 at top edge (hinge), 1 at bottom
    float panelVis  = 1.0 - openFrac * panelTop;  // bottom drops away as it opens

    // Panel visible area (above the fold line)
    float panelShad = openFrac * panelTop * u_shadowDepth;

    // Interior light (visible through open panels)
    float interiorGlow = openFrac * smoothstep(0.15, 0.7, openFrac) * 0.6;

    // Panel colour: concrete grey / glass combination
    float parity = mod(cell.x + cell.y, 2.0);
    vec3 panelCol  = mix(vec3(0.72, 0.70, 0.68), vec3(0.55, 0.60, 0.65), parity);
    vec3 glassCol  = mix(vec3(0.65, 0.75, 0.85), vec3(0.85, 0.92, 0.98), noise(uv * 12.0));
    vec3 interior  = vec3(0.98, 0.88, 0.72); // warm interior light

    vec3 col = mix(panelCol, glassCol, parity * 0.4);
    col *= (1.0 - panelShad * 0.5);
    col = mix(col, interior, interiorGlow * panelVis);

    // Panel frame lines
    float frameD = min(min(f.x, 1.0-f.x), min(f.y, 1.0-f.y));
    col = mix(col, vec3(0.25, 0.25, 0.28), smoothstep(0.04, 0.0, frameD) * 0.7);

    // Hinge shadow at top of panel
    float hingeShad = smoothstep(0.08, 0.0, f.y) * openFrac * 0.4;
    col = mix(col, vec3(0.1, 0.1, 0.12), hingeShad);

    return col;
}

// ── Folded plate structure ────────────────────────────────────────────────────
// Zigzag cross-section: alternating mountain/valley at angle phi.
vec3 foldedPlate(vec2 uv, float phi) {
    float N = max(2.0, u_creaseDensity * 0.1);
    float cellW = 1.0 / N;
    vec2  cell  = floor(uv / vec2(cellW, 1.0));
    vec2  f     = fract(uv / vec2(cellW, 1.0));
    float parity = mod(cell.x, 2.0);

    // Zigzag angle from fold
    float tilt   = (parity < 0.5 ? 1.0 : -1.0) * phi * 0.5;
    float cosT   = cos(tilt);
    float sinT   = sin(tilt);

    // Apparent panel width (compresses as it tilts away)
    float width  = abs(cosT);
    float inPanel = step(f.x, width);

    // Panel face normal (for shading)
    vec3 normal  = normalize(vec3(sinT, 0.0, cosT));
    vec3 lightDir = normalize(vec3(0.5, 0.8, 1.0));
    float shade  = dot(normal, lightDir) * 0.5 + 0.5;

    // Load path: vertical stress lines
    float stressLine = abs(sin(uv.y * 12.0 * PI)) * 0.06;

    // Section colour: concrete / white steel
    vec3 concrete = vec3(0.78, 0.76, 0.72);
    vec3 steel    = vec3(0.85, 0.85, 0.88);
    vec3 col = mix(concrete, steel, parity);
    col *= shade;
    col *= 1.0 - u_shadowDepth * (1.0 - inPanel) * 0.5;  // gap shadows
    col += stressLine * vec3(0.6, 0.5, 0.9) * 0.15;

    // Crease/hinge lines (structural)
    float edgeD = abs(f.x);
    float hinge = smoothstep(0.015, 0.0, edgeD) * 0.6;
    col = mix(col, parity < 0.5 ? vec3(0.78, 0.18, 0.12) : vec3(0.15, 0.32, 0.78), hinge);

    // Deflection indicator: panels bow slightly under load
    float bowX   = f.x - 0.5;
    float bow    = noise(vec2(uv.x * N + 3.7, u_time * 0.3)) * 0.04 * phi / PI;
    col -= bow * 0.2;

    return col;
}

// ── Deployable shelter ────────────────────────────────────────────────────────
// Sequential deployment of modular shelter units.
vec3 deployableShelter(vec2 uv, float phi) {
    float t = phi / PI;
    float N = max(2.0, u_creaseDensity * 0.10);

    // Module grid
    float cellSize = 1.0 / N;
    vec2  cell = floor(uv / cellSize);
    vec2  f    = fract(uv / cellSize);

    // Deployment sequence: modules deploy from centre outward
    vec2  gridCentre = vec2(N * 0.5);
    float distFromCentre = length(cell - gridCentre) / N;
    float deployTime = clamp(t - distFromCentre * 0.4, 0.0, 1.0);
    float moduleT    = deployTime;

    // Each module has 4 panels that unfold outward
    vec2 mc = f - 0.5;  // local coords within module
    float panelID = floor(atan(mc.y, mc.x) / (PI * 0.5)) + 2.0;
    float panelA  = (panelID / 4.0) * TWO_PI;
    float panelR  = length(mc);
    float panelOpen = moduleT * 0.5;

    // Folded panels: appear as diagonal folds, then flatten
    float diagFold = abs(mc.y - mc.x * (1.0 - moduleT * 2.0));
    float roofFlat = min(abs(mc.x), abs(mc.y));
    float foldLine = mix(diagFold, roofFlat, moduleT);

    float lineW = 0.02;
    float fLine = smoothstep(lineW, lineW * 0.2, foldLine);

    // Roof colour: corrugated metal / canvas
    float h = hash(cell);
    vec3 canvas  = mix(vec3(0.78, 0.72, 0.62), vec3(0.62, 0.68, 0.75), h);
    vec3 undeployed = vec3(0.35, 0.33, 0.30);
    vec3 col = mix(undeployed, canvas, moduleT);

    // Fold lines
    bool isMtn = mod(panelID, 2.0) < 1.0;
    vec3 foldCol = isMtn ? vec3(0.80, 0.18, 0.12) : vec3(0.15, 0.32, 0.78);
    col = mix(col, foldCol, fLine * 0.7);

    // Border/frame of each module
    float borderD = min(min(f.x, 1.0-f.x), min(f.y, 1.0-f.y));
    col = mix(col, vec3(0.22, 0.20, 0.18), smoothstep(0.035, 0.0, borderD) * 0.6);

    // Central connection point (hub)
    float hubD = length(mc) - 0.05;
    col = mix(col, vec3(0.85, 0.82, 0.78), smoothstep(0.01, 0.0, abs(hubD)) * moduleT);

    return col;
}

// ── Zaha Hadid continuous surface ────────────────────────────────────────────
// Parametric flowing surface: floor becomes wall becomes ceiling.
// Single-surface architecture animated as one continuous fold.
vec3 zahaSurface(vec2 uv, float phi) {
    float t = phi / PI;
    vec2  c = uv - 0.5;

    // Flowing sine-landscape: the surface height function
    float z = sin(c.x * PI * 3.0 + u_time * 0.3) * 0.15
            + sin(c.y * PI * 2.0 + u_time * 0.2) * 0.12;
    z *= t;

    // Surface normal (finite differences)
    float eps = 0.005;
    float zx = sin((c.x + eps) * PI * 3.0 + u_time * 0.3) * 0.15
             + sin(c.y * PI * 2.0 + u_time * 0.2) * 0.12;
    float zy = sin(c.x * PI * 3.0 + u_time * 0.3) * 0.15
             + sin((c.y + eps) * PI * 2.0 + u_time * 0.2) * 0.12;
    zx *= t; zy *= t;
    vec3 nrm = normalize(vec3(-(zx - z) / eps, -(zy - z) / eps, 1.0));

    // Lighting
    vec3 light = normalize(vec3(cos(u_time * 0.2), sin(u_time * 0.2), 1.5));
    float diff = dot(nrm, light) * 0.5 + 0.5;
    float spec = pow(max(0.0, dot(reflect(-light, nrm), vec3(0, 0, 1))), 8.0);

    // Surface colour: Zaha whites, greys, and concrete textures
    float contour = length(c) + z * 0.5;
    vec3 surfCol = mix(vec3(0.92, 0.90, 0.87), vec3(0.65, 0.63, 0.62),
                       noise(uv * 8.0) * 0.4 + 0.3);

    // Contour lines (architectural section lines)
    float contourLine = abs(fract(z * 10.0) - 0.5);
    float cLine = smoothstep(0.06, 0.01, contourLine);

    vec3 col = surfCol * diff;
    col += vec3(0.95, 0.93, 0.90) * spec * 0.5;
    col = mix(col, vec3(0.30, 0.30, 0.35), cLine * 0.4);

    // Floor-to-wall transition highlight
    float transLine = abs(uv.y - (0.5 + z * 2.0));
    col = mix(col, vec3(0.70, 0.75, 0.85), smoothstep(0.008, 0.0, transLine) * t * 0.6);

    return col;
}

// ── Main ────────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float aspect = u_resolution.x / u_resolution.y;
    uv.x *= aspect;
    vec2 p = vec2(uv.x / aspect, uv.y);

    float phi  = u_foldAngle * PI / 180.0;
    int   mode = int(u_origamiStyle);

    vec3 col;
    if      (mode == 0) col = kineticFacade(p, phi);
    else if (mode == 1) col = foldedPlate(p, phi);
    else if (mode == 2) col = deployableShelter(p, phi);
    else                col = zahaSurface(p, phi);

    // Vignette
    vec2 cv = uv - vec2(aspect * 0.5, 0.5);
    col *= 1.0 - 0.22 * dot(cv, cv) * 2.5;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
