// resch_pattern.glsl
// Ron Resch triangular rigid-foldable tessellation.
// Invented by sculptor and computer scientist Ron Resch (1960s–70s).
// One of the few rigid-foldable patterns capable of approximating
// doubly-curved (synclastic) surfaces.
//
// MATHEMATICS:
//   The Resch unit cell is an equilateral triangle with three valley crease
//   lines from each edge midpoint to the centre. Adjacent triangles are
//   connected by mountain creases at shared edges.
//
//   The folded Resch pattern produces a dimpled triangular array where
//   each triangle sinks into a three-sided pyramid. The fold angle satisfies:
//
//     For an equilateral triangle with side a:
//       height of dimple h = a · tan(φ/2) / (2√3)
//     where φ is the valley fold angle (from flat).
//
//   Unlike Miura-ori, the Resch pattern is NOT strictly single-DOF globally,
//   but in practice the over-constrained regions allow approximate rigid folding.
//   Computational rigid origami simulation (Tachi) shows it can deploy smoothly
//   for finite panels.
//
//   The folded form has triangular facets arranged in a hexagonal super-cell.
//   Each hexagonal cell of 6 triangles forms one "flower" of inward dimples.
//
// PARAMETERS:
//   foldAngle     – dimple depth / deployment [0=flat, 180=fully dimpled]
//   creaseDensity – number of triangle units across
//   shadowDepth   – shadow between facets [0, 1]
//   showMath      – overlay the valley/mountain crease classification

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_foldAngle;
uniform float u_creaseDensity;
uniform float u_shadowDepth;
uniform bool  u_showMath;

const float PI      = 3.14159265358979;
const float SQRT3   = 1.73205080757;
const float INV_SQRT3 = 0.57735026919;

// ── Hexagonal grid utilities ────────────────────────────────────────────────
// Convert uv to hex axial coordinates (pointy-top hexagons).
vec2 uvToHex(vec2 p, float size) {
    float q =  p.x * (2.0 / 3.0) / size;
    float r = (-p.x / 3.0 + SQRT3 / 3.0 * p.y) / size;
    return vec2(q, r);
}

// Round hex coordinates to nearest hex cell.
vec2 hexRound(vec2 h) {
    float x = h.x, y = h.y, z = -h.x - h.y;
    float rx = round(x), ry = round(y), rz = round(z);
    float dx = abs(rx - x), dy = abs(ry - y), dz = abs(rz - z);
    if (dx > dy && dx > dz) rx = -ry - rz;
    else if (dy > dz)        ry = -rx - rz;
    return vec2(rx, ry);
}

// Hex cell centre to uv.
vec2 hexToUV(vec2 h, float size) {
    float x = size * (3.0 / 2.0 * h.x);
    float y = size * (SQRT3 * 0.5 * h.x + SQRT3 * h.y);
    return vec2(x, y);
}

// ── Triangular subdivisions of a hex cell ──────────────────────────────────
// Each hex cell contains 6 equilateral triangles.
// Returns: (distToNearestValleyCrease, distToNearestMountainCrease, facetID)
vec3 rechsCrease(vec2 uv, float hexSize, float phi) {
    // Find hex cell
    vec2 hc  = uvToHex(uv, hexSize);
    vec2 hcR = hexRound(hc);
    vec2 hexCentre = hexToUV(hcR, hexSize);

    // Local coords within hex (normalised by hex size)
    vec2 local = (uv - hexCentre) / hexSize;
    float r = length(local);
    float angle = atan(local.y, local.x);

    // Which of the 6 triangular sectors?
    float sectorAngle = PI / 3.0;
    float sector = floor((angle + PI) / sectorAngle);
    float sectorMid = (sector + 0.5) * sectorAngle - PI;

    // Edge midpoints of the sector triangle (at 60° intervals)
    vec2 v0 = vec2(0.0, 0.0); // hex centre
    vec2 v1 = 0.577 * vec2(cos(sector * sectorAngle - PI), sin(sector * sectorAngle - PI));
    vec2 v2 = 0.577 * vec2(cos((sector + 1.0) * sectorAngle - PI), sin((sector + 1.0) * sectorAngle - PI));

    // Edge midpoint to centre = valley crease
    vec2 mid12 = (v1 + v2) * 0.5;
    float valleyD = length(local - mid12 * 0.5) * hexSize;

    // Line from hex centre to triangle vertex = mountain crease (shared edge)
    float mountainD = length(local - v1 * 0.5) * hexSize;
    mountainD = min(mountainD, length(local - v2 * 0.5) * hexSize);

    // Depth modulation by fold angle
    float depth = r * sin(phi * 0.5) * u_shadowDepth;

    return vec3(valleyD, mountainD, depth);
}

// ── Facet shading ──────────────────────────────────────────────────────────
// Shade each triangular facet by its tilt relative to the view direction.
float facetShade(vec2 uv, float hexSize, float phi) {
    vec2 hc  = uvToHex(uv, hexSize);
    vec2 hcR = hexRound(hc);
    vec2 hexCentre = hexToUV(hcR, hexSize);
    vec2 local = (uv - hexCentre) / hexSize;

    float angle = atan(local.y, local.x);
    float sectorAngle = PI / 3.0;
    float sector = floor((angle + PI) / sectorAngle);

    // Facets alternate between tilting inward (dimple) and outward (flat edge)
    float tilt = (mod(sector + floor(hcR.x + hcR.y * 2.0), 2.0) < 1.0 ? 1.0 : -1.0);
    return 0.5 + 0.45 * tilt * sin(phi * 0.5);
}

// ── Main ───────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float aspect = u_resolution.x / u_resolution.y;
    uv.x *= aspect;
    vec2 p = vec2(uv.x / aspect, uv.y) - 0.5; // centred, square coords
    p *= 1.0 + u_creaseDensity * 0.005; // scale with density

    float phi = u_foldAngle * PI / 180.0;
    float hexSize = 0.12 / max(1.0, u_creaseDensity * 0.08);

    // Paper colour (cream)
    vec3 paper = vec3(0.96, 0.93, 0.87);

    // Facet shading
    float shade = facetShade(p, hexSize, phi);
    vec3  col   = paper * (0.6 + 0.4 * shade);

    // Resch crease lines
    vec3 cr     = rechsCrease(p, hexSize, phi);
    float valD  = cr.x;
    float mtnD  = cr.y;
    float depth = cr.z;

    float lineW = hexSize * 0.04;

    // Valley creases: blue
    float valLine = smoothstep(lineW, lineW * 0.2, valD);
    col = mix(col, vec3(0.15, 0.32, 0.78), valLine * 0.90);

    // Mountain creases: red
    float mtnLine = smoothstep(lineW * 1.3, lineW * 0.3, mtnD);
    col = mix(col, vec3(0.80, 0.18, 0.12), mtnLine * 0.85);

    // Shadow deepens in dimple
    col *= (1.0 - depth * 0.6);

    // ── Dimple highlight glow ────────────────────────────────────────────
    // The deepest part of each dimple catches a specular highlight
    float dimpleGlow = smoothstep(hexSize * 0.3, 0.0, valD) * sin(phi * 0.5) * 0.25;
    col += vec3(0.9, 0.88, 0.84) * dimpleGlow;

    // ── Math overlay ─────────────────────────────────────────────────────
    if (u_showMath) {
        // Show hex cell boundaries in gold
        vec2 hc  = uvToHex(p, hexSize);
        vec2 hcR = hexRound(hc);
        vec2 hexCentre = hexToUV(hcR, hexSize);
        float hexBoundD = length(p - hexCentre) - hexSize * 0.95;
        float hexRing = smoothstep(hexSize * 0.06, 0.0, abs(hexBoundD));
        col = mix(col, vec3(1.0, 0.75, 0.1), hexRing * 0.5);
    }

    // ── Fold animation pulse ──────────────────────────────────────────────
    if (u_foldAngle < 1.0) {
        float pulse = 0.5 + 0.5 * sin(u_time * 1.5);
        col = mix(col, col * 1.1, pulse * 0.15);
    }

    // Vignette
    vec2 cv = uv - vec2(aspect * 0.5, 0.5);
    col *= 1.0 - 0.27 * dot(cv, cv) * 3.0;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
