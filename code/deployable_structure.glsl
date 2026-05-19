// deployable_structure.glsl
// Deployable origami structures: from flat-packed to fully deployed.
// Engineering applications: satellite solar panels, medical stents, emergency shelters,
// folded architectural facades, crash-absorbing automotive panels.
//
// ENGINEERING CONTEXT:
//   The core challenge: package a large area into a small volume, then deploy it
//   without motors, maintenance, or complex mechanisms. Origami solves this.
//
//   Key metrics for deployable origami:
//     Compaction ratio C = Area_flat / Area_deployed  (Miura-ori achieves C > 100)
//     DOF requirement: single-DOF = single actuator = simplest deployment
//     Deployment force: Miura-ori requires constant force (elastic springs loaded at flat)
//
//   Case studies:
//     IKAROS solar sail (JAXA, 2010): Miura-ori. 200m² panel, 14m² stowed.
//     Eyeglass telescope lens (JPL): 25m diameter, 20× compaction.
//     Medical stents: Kresling tubes. Delivered collapsed, deployed by blood pressure.
//     Sheltersuit/disaster relief: Waterbomb-based flat-pack emergency housing.
//
// VISUAL MODES:
//   mode 0 — Solar panel deployment sequence (Miura variant)
//   mode 1 — Medical stent (Kresling tube cross-section)
//   mode 2 — Emergency shelter floor plan (architectural module)
//   mode 3 — Crash absorber column (Yoshimura progressive buckling)
//
// PARAMETERS:
//   foldAngle     – deployment progress [0=stowed, 180=fully deployed]
//   creaseDensity – panel resolution / detail
//   shadowDepth   – structural depth / shadow
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
float sdLine(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    return length(pa - ba * clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0));
}

// ── Solar panel deployment ───────────────────────────────────────────────────
// Miura-ori panel array deploying from a central hub.
vec3 solarPanel(vec2 uv, float t) {
    vec2 c = uv - 0.5;
    float N = max(3.0, u_creaseDensity * 0.15);
    float alpha = PI * 0.25; // Miura sector angle

    // 4-panel Miura array around central hub
    float glow = 0.0;
    for (float arm = 0.0; arm < 4.0; arm++) {
        float armA = arm * PI * 0.5 + u_time * 0.05 * (1.0 - t);
        vec2 armDir = vec2(cos(armA), sin(armA));

        for (float panel = 0.0; panel < 6.0; panel++) {
            if (panel >= N) break;
            // Panel position along arm
            float dist = (panel + 1.0) / N * 0.45 * t;
            float panelW = 0.06 * t;
            float panelH = panelW * (1.0 + sin(alpha)) * 0.8;

            vec2  panelCtr = armDir * dist;
            float pd = length(c - panelCtr);

            // Panel shading: alternating for fold
            float shade = 0.3 + 0.5 * cos(panel * PI + arm * PI * 0.5);
            glow += smoothstep(panelW, 0.0, pd) * (0.5 + 0.5 * shade);

            // Crease line between panels
            float cd = abs(dot(c - panelCtr, armDir) - panelW * 0.5);
            float creaseD = sdLine(c, panelCtr - armDir * panelW * 0.5,
                                      panelCtr + armDir * panelW * 0.5);
            glow += smoothstep(0.003, 0.0, creaseD) * 0.3;
        }
    }

    // Central hub
    float hubD = length(c) - 0.04 * (0.5 + t * 0.5);
    float hub  = smoothstep(0.006, 0.0, abs(hubD));

    // Background: space (deep blue-black)
    vec3 col = mix(vec3(0.02, 0.02, 0.06), vec3(0.04, 0.05, 0.08), length(c) * 2.0);
    // Solar cell blue (photovoltaic)
    col = mix(col, vec3(0.10, 0.25, 0.60), glow * 0.85);
    // Panel edges (light accent)
    col = mix(col, vec3(0.7, 0.8, 1.0), hub * 0.7);
    // Deployment progress glow
    col += vec3(0.2, 0.4, 0.8) * exp(-length(c) * 3.0) * t * 0.3;

    return col;
}

// ── Medical stent (Kresling cross-section) ────────────────────────────────────
vec3 medicalStent(vec2 uv, float t) {
    vec2 c = uv - 0.5;
    float r = length(c);
    float a = atan(c.y, c.x) + u_time * 0.1;

    float N = max(4.0, floor(u_creaseDensity * 0.1 + 4.0));

    // Outer stent ring (deployed radius grows with t)
    float stentR   = 0.15 + t * 0.25;
    float wallThick = 0.012;
    float outerRing = smoothstep(wallThick, 0.0, abs(r - stentR));

    // Inner ring (collapsed state)
    float innerR  = 0.10 * (1.0 - t * 0.5);
    float innerRing = smoothstep(wallThick * 0.5, 0.0, abs(r - innerR));

    // Kresling ribs: N helical struts
    float ribGlow = 0.0;
    for (float k = 0.0; k < 12.0; k++) {
        if (k >= N) break;
        float ribA = k * TWO_PI / N + a * 0.3;  // slight rotation
        vec2  ribDir = vec2(cos(ribA), sin(ribA));
        // Rib: line from inner ring to outer ring
        float ribD = sdLine(c, innerR * ribDir, stentR * ribDir);
        ribGlow += smoothstep(0.005, 0.0, ribD);
    }

    // Vessel wall (organic tube around stent)
    float vesselR = stentR * 1.35;
    float vesselD = abs(r - vesselR);
    float vessel  = smoothstep(0.03, 0.0, vesselD);

    // Blood flow gradient
    float flow = smoothstep(stentR, 0.0, r) * t * 0.4;

    vec3 col = vec3(0.15, 0.08, 0.08);  // dark tissue background
    col = mix(col, vec3(0.85, 0.20, 0.15), vessel * 0.6);     // vessel wall (red)
    col = mix(col, vec3(0.75, 0.80, 0.85), outerRing * 0.9);  // stent metal
    col = mix(col, vec3(0.60, 0.65, 0.75), innerRing * 0.7);
    col = mix(col, vec3(0.85, 0.88, 0.92), ribGlow * 0.7);    // Kresling struts
    col += vec3(0.8, 0.1, 0.1) * flow;                         // blood flow

    return col;
}

// ── Emergency shelter (architectural grid) ────────────────────────────────────
vec3 emergencyShelter(vec2 uv, float t) {
    float N = max(3.0, u_creaseDensity * 0.12);
    float cellW = 1.0 / N;
    vec2  cell  = floor(uv / cellW);
    vec2  f     = fract(uv / cellW);

    // Modular shelter units: each cell is a deployable folding shelter unit
    float parity = mod(cell.x + cell.y, 2.0);

    // Deployed: flat roof panel. Stowed: folded (shows diagonals)
    float roofLine = min(abs(f.y - 0.5), abs(f.x - 0.5)); // grid lines
    float diagLine = abs(f.y - f.x);                        // diagonal crease
    float deployLine = mix(diagLine, roofLine, t) / cellW;

    float lineW = 0.035;
    float line  = smoothstep(lineW, lineW * 0.2, deployLine);

    // Panel shading: alternate for visual depth
    float shade = parity < 0.5 ? 0.85 : 0.95;
    shade = mix(shade, 0.7 + parity * 0.2, u_shadowDepth * t);

    vec3 paper = vec3(0.72, 0.68, 0.62);  // corrugated steel grey
    vec3 col   = paper * shade;

    // Crease lines
    vec3 lineCol = mix(vec3(0.3, 0.5, 0.7), vec3(0.8, 0.4, 0.15), parity);
    col = mix(col, lineCol, line * 0.7);

    // Entry gaps: some cells have doors
    float isDoor = step(0.9, hash(cell));
    float doorArc = smoothstep(0.35, 0.3, abs(length(f - vec2(0.5)) - 0.3));
    col = mix(col, vec3(0.1, 0.08, 0.05), doorArc * isDoor * t);

    // Snow/rain stress marks
    float grain = hash(uv * 200.0 + cell) * 0.04;
    col += grain * (1.0 - t * 0.3);

    return col;
}

// ── Crash absorber column (progressive Yoshimura buckling) ────────────────────
vec3 crashAbsorber(vec2 uv, float t) {
    // Column: vertical rectangle with progressive Yoshimura buckling from top
    float colX = abs(uv.x - 0.5);
    float inCol = step(colX, 0.15);

    // Progressive compression: top buckles first
    float buckleHeight = t;  // buckle front at height = t from top
    float yFromTop = 1.0 - uv.y;

    // Yoshimura diamond crease
    float N = max(3.0, u_creaseDensity * 0.12);
    float cellH = 0.15;
    float buckled = step(yFromTop, buckleHeight);

    float diamondA = abs(uv.y * N * 2.0 - floor(uv.y * N * 2.0) - 0.5) * 2.0;
    float shear = sin(uv.x * N * PI) * buckled * 0.3 * t;
    float diamond = abs(diamondA + shear - 0.5);

    float lineW = 0.06;
    float dLine = smoothstep(lineW, lineW * 0.15, diamond * cellH);

    // Progressive fold: top is compressed, bottom is intact
    float progress = smoothstep(0.0, 0.15, buckleHeight - yFromTop);
    float colHeight = 1.0 - t * 0.5;  // column shortens

    vec3 col = vec3(0.88, 0.86, 0.82);

    // Metal colour for column body
    col = mix(vec3(0.88, 0.86, 0.82), vec3(0.65, 0.67, 0.72), inCol);

    // Buckled region: darker, showing energy absorption
    col = mix(col, vec3(0.45, 0.44, 0.42), progress * inCol * u_shadowDepth);

    // Crease lines on column
    vec3 creaseCol = mix(vec3(0.80, 0.18, 0.12), vec3(0.15, 0.32, 0.78),
                         float(mod(floor(uv.y * N * 2.0), 2.0) < 1.0));
    col = mix(col, creaseCol, dLine * buckled * inCol * 0.7);

    // Deformation particles (energy release)
    float particle = step(0.97, hash(uv * 50.0 + u_time * 0.5)) * progress * inCol;
    col = mix(col, vec3(1.0, 0.8, 0.3), particle * t);

    // Background: test rig / concrete base
    vec3 bg = vec3(0.55, 0.54, 0.52);
    col = mix(bg, col, inCol);

    return col;
}

// ── Main ────────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float aspect = u_resolution.x / u_resolution.y;
    uv.x *= aspect;
    vec2 p = vec2(uv.x / aspect, uv.y);

    float t    = u_foldAngle / 180.0;
    int   mode = int(u_origamiStyle);

    vec3 col;
    if      (mode == 0) col = solarPanel(p, t);
    else if (mode == 1) col = medicalStent(p, t);
    else if (mode == 2) col = emergencyShelter(p, t);
    else                col = crashAbsorber(p, t);

    // Deployment progress bar (engineering HUD style)
    float barY = 0.018;
    if (gl_FragCoord.y / u_resolution.y < barY) {
        float progress = t;
        vec3  barFill  = mix(vec3(0.8, 0.3, 0.1), vec3(0.2, 0.7, 0.3), progress);
        col = uv.x / aspect < progress ? barFill : vec3(0.15, 0.15, 0.18);
    }

    // Vignette
    vec2 cv = uv - vec2(aspect * 0.5, 0.5);
    col *= 1.0 - 0.25 * dot(cv, cv) * 2.5;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
