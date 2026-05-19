// thick_origami.glsl
// Thick-panel origami — engineering origami for materials with non-zero thickness.
// Pure mathematical origami assumes zero thickness. Real materials (metal sheets,
// composite panels, cardboard) require geometric compensation.
//
// THE THICKNESS PROBLEM:
//   When two panels of thickness t fold to angle φ, the outer surface travels
//   a distance greater than the inner surface by exactly π·t/2 (for 180° fold).
//   This creates a geometric incompatibility: panels interfere at the hinge zone.
//
// ENGINEERING SOLUTIONS (Tachi, Hoberman, Zirbel et al.):
//
//   1. PANEL OFFSET (truncation) — panels are shortened inward from each crease.
//      Each panel is cut shorter by t·tan(φ/4) on each folding edge.
//      Clean geometry, but requires precision manufacturing.
//
//   2. HINGE GAP — a physical gap is left at each crease equal to t·(π - φ)/(2·tan(φ/2)).
//      Simple to manufacture but changes the flat state geometry.
//
//   3. TAPERED PANELS (Tachi's method) — panel edges are chamfered at an angle
//      equal to half the fold angle. Allows panels to nest during folding.
//
//   4. KIRIGAMI SLOT — a slot of width t is cut along each fold line.
//      The material hinges in the gap. Used in cardboard and corrugated designs.
//
//   5. MEMBRANE HINGE — the panel is locally thinned at the crease to near-zero
//      thickness (laser thinning, or a flexible membrane bridge). The zero-thickness
//      condition is satisfied locally at the hinge.
//
// APPLICATIONS:
//   Sheet metal forming (automotive body panels)
//   Aerospace deployable panels (solar arrays, antenna reflectors)
//   Thick composite foldable structures (sandwich panels, carbon fibre)
//   Cardboard packaging design
//   Robotic origami with rigid link-hinge approximation
//
// PARAMETERS:
//   foldAngle     – current fold angle [0=flat, 180=fully folded]
//   creaseDensity – number of panels
//   shadowDepth   – thickness depth visual (shows material thickness)
//   origamiStyle  – compensation method 0=offset 1=gap 2=taper 3=membrane

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

// ── Utility ─────────────────────────────────────────────────────────────────
float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
float sdLine(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    return length(pa - ba * clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0));
}
float sdRect(vec2 p, vec2 b) { vec2 d = abs(p) - b; return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0); }

// ── Thickness parameter ──────────────────────────────────────────────────────
// Typical thick origami: t/L ratio ~0.01 to 0.1 (t = panel thickness, L = panel length)
const float THICKNESS_RATIO = 0.04;  // 4% of panel length

// ── Method 0: Panel offset ───────────────────────────────────────────────────
vec3 panelOffset(vec2 uv, float phi) {
    float N = max(2.0, u_creaseDensity * 0.1);
    float panelW = 1.0 / N;
    float t = THICKNESS_RATIO * panelW;

    vec2 cell = floor(uv / vec2(panelW, 1.0));
    vec2 f    = fract(uv / vec2(panelW, 1.0));

    float parity = mod(cell.x, 2.0);

    // Panel tilt angle
    float tilt = (parity < 0.5 ? 1.0 : -1.0) * (phi - PI * 0.5);

    // Truncation amount per crease edge
    float truncation = t * tan(phi * 0.25);

    // Effective panel width after truncation (shorter to avoid interference)
    float effW = 1.0 - 2.0 * truncation / panelW;
    effW = clamp(effW, 0.1, 1.0);

    // Panel visible area (with truncation gaps at edges)
    float inPanel = step(truncation / panelW, f.x) * step(f.x, 1.0 - truncation / panelW);

    // Panel face shade
    float shade = 0.5 + 0.45 * cos(tilt);

    // Material: brushed aluminium
    vec3 metal = mix(vec3(0.75, 0.76, 0.80), vec3(0.88, 0.87, 0.90), hash(cell));
    metal *= shade;

    // Truncation gap (void between panels)
    float gapD = min(f.x, 1.0 - f.x) - truncation / panelW;
    float inGap = step(gapD, 0.0);

    vec3 col = mix(metal, vec3(0.08, 0.07, 0.06), inGap * 0.9);

    // Edge highlight (bevelled edge from truncation)
    float bevel = smoothstep(truncation / panelW + 0.015, truncation / panelW, f.x) * inPanel;
    col += vec3(0.85, 0.85, 0.90) * bevel * 0.3;

    // Thickness cross-section visualised at hinge
    float thickD = abs(f.x - truncation / panelW) * panelW;
    float thickVis = smoothstep(t * 1.5, 0.0, thickD) * inGap * u_shadowDepth;
    col = mix(col, vec3(0.55, 0.56, 0.60), thickVis);

    return col;
}

// ── Method 1: Hinge gap ──────────────────────────────────────────────────────
vec3 hingeGap(vec2 uv, float phi) {
    float N = max(2.0, u_creaseDensity * 0.1);
    float panelW = 1.0 / N;
    float t = THICKNESS_RATIO * panelW;

    vec2 cell = floor(uv / vec2(panelW, 1.0));
    vec2 f    = fract(uv / vec2(panelW, 1.0));
    float parity = mod(cell.x, 2.0);

    // Hinge gap width: t * (pi - phi) / (2 * tan(phi/2))
    float tanhalf = tan(phi * 0.5);
    float gapW = (tanhalf > 0.001) ? t * (PI - phi) / (2.0 * tanhalf) : t;
    gapW = clamp(gapW / panelW, 0.0, 0.3);

    float tilt = (parity < 0.5 ? 1.0 : -1.0) * (phi - PI * 0.5);
    float shade = 0.5 + 0.45 * cos(tilt);

    // Gap at right edge of each panel
    float inGap = step(1.0 - gapW, f.x);
    float inPanel = 1.0 - inGap;

    vec3 metal = mix(vec3(0.72, 0.74, 0.78), vec3(0.85, 0.85, 0.88), hash(cell));
    metal *= shade;

    vec3 col = mix(metal, vec3(0.06, 0.06, 0.08), inGap * 0.95);

    // Gap reveals thickness of adjacent panel
    float thickSlice = smoothstep(t * 2.0, 0.0, abs(f.x - (1.0 - gapW)) * panelW) * inGap;
    col = mix(col, vec3(0.58, 0.58, 0.62) * shade, thickSlice * u_shadowDepth);

    return col;
}

// ── Method 2: Tapered panels ─────────────────────────────────────────────────
vec3 taperedPanel(vec2 uv, float phi) {
    float N = max(2.0, u_creaseDensity * 0.1);
    float panelW = 1.0 / N;
    float t = THICKNESS_RATIO * panelW;

    vec2 cell = floor(uv / vec2(panelW, 1.0));
    vec2 f    = fract(uv / vec2(panelW, 1.0));
    float parity = mod(cell.x, 2.0);
    float tilt = (parity < 0.5 ? 1.0 : -1.0) * (phi - PI * 0.5);
    float shade = 0.5 + 0.45 * cos(tilt);

    // Taper angle = phi/2. Panel edge is bevelled at this angle.
    // Result: cross-section at hinge is a parallelogram, not a rectangle.
    float taperAngle = phi * 0.5;
    float taperX = f.x * panelW;
    // Taper makes the panel narrower at the crease edge
    float effectiveY = f.y + taperX * tan(taperAngle) / 1.0;
    float inPanel = step(0.0, effectiveY) * step(effectiveY, 1.0);

    // Visible taper bevel
    float bevelLine = abs(f.y - f.x * tan(taperAngle));
    float bevel = smoothstep(t * 0.8, 0.0, bevelLine * panelW) * (1.0 - f.x);

    vec3 metal = mix(vec3(0.70, 0.72, 0.76), vec3(0.85, 0.85, 0.87), hash(cell));
    metal *= shade;

    vec3 col = metal * inPanel;

    // Taper edge highlight
    col += vec3(0.88, 0.88, 0.92) * bevel * 0.4 * inPanel;

    // Shadow under taper
    float shadowD = f.x * tan(taperAngle) * panelW;
    col -= vec3(0.1) * smoothstep(0.0, t * 2.0, shadowD) * u_shadowDepth * inPanel;

    return col;
}

// ── Method 3: Membrane hinge ─────────────────────────────────────────────────
vec3 membraneHinge(vec2 uv, float phi) {
    float N = max(2.0, u_creaseDensity * 0.1);
    float panelW = 1.0 / N;
    float t = THICKNESS_RATIO * panelW;

    vec2 cell = floor(uv / vec2(panelW, 1.0));
    vec2 f    = fract(uv / vec2(panelW, 1.0));
    float parity = mod(cell.x, 2.0);
    float tilt = (parity < 0.5 ? 1.0 : -1.0) * (phi - PI * 0.5);
    float shade = 0.5 + 0.45 * cos(tilt);

    // Membrane zone width: 3-4× the panel thickness (thin flexible region)
    float membraneW = t * 3.5 / panelW;

    float inMembrane = step(1.0 - membraneW, f.x);
    float inPanel    = 1.0 - inMembrane;

    // Panel: rigid thick material (carbon fibre look)
    float cfPattern = abs(sin(uv.y * 40.0 + hash(cell) * PI)) * 0.1;
    vec3 carbonFibre = mix(vec3(0.12, 0.12, 0.14), vec3(0.22, 0.22, 0.25),
                           cfPattern + hash(cell + vec2(0.3)) * 0.1);
    carbonFibre *= shade;

    // Membrane: translucent, flexible (lighter grey-amber)
    float membraneCurve = sin(f.x * PI / membraneW + phi) * 0.3 + 0.7;
    vec3 membrane = vec3(0.78, 0.72, 0.58) * membraneCurve;

    vec3 col = mix(carbonFibre, membrane, inMembrane * 0.9);

    // Membrane curvature highlight (shows the local bending at the hinge)
    float bendHighlight = smoothstep(membraneW, 0.0, abs(f.x - (1.0 - membraneW * 0.5)))
                        * sin(phi) * 0.3;
    col += vec3(0.9, 0.85, 0.7) * bendHighlight;

    // Stress concentration at membrane-panel boundary
    float stressD = abs(f.x - (1.0 - membraneW));
    float stress  = smoothstep(0.01, 0.0, stressD * panelW) * u_shadowDepth;
    col = mix(col, vec3(0.90, 0.40, 0.20), stress * 0.25);

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
    if      (mode == 0) col = panelOffset(p, phi);
    else if (mode == 1) col = hingeGap(p, phi);
    else if (mode == 2) col = taperedPanel(p, phi);
    else                col = membraneHinge(p, phi);

    // Fold angle indicator (engineering annotation)
    float angleY = 0.05;
    if (gl_FragCoord.y / u_resolution.y < angleY) {
        float progress = phi / PI;
        vec3 modeCol = mode == 0 ? vec3(0.3, 0.6, 0.9) :
                       mode == 1 ? vec3(0.3, 0.8, 0.4) :
                       mode == 2 ? vec3(0.9, 0.6, 0.2) :
                                   vec3(0.7, 0.3, 0.9);
        col = uv.x / aspect < progress ? modeCol * 0.8 : vec3(0.12);
    }

    // Vignette
    vec2 cv = uv - vec2(aspect * 0.5, 0.5);
    col *= 1.0 - 0.20 * dot(cv, cv) * 2.5;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
