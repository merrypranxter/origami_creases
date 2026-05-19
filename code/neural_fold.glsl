// neural_fold.glsl
// Brain gyrification as origami — the cerebral cortex folds itself to pack
// maximum surface area into minimal skull volume.
// The cortical fold is a deployable structure optimised by evolution.
//
// NEUROSCIENCE + ORIGAMI:
//   The human cortex is a ~2400 cm² sheet folded to fit inside a ~600 cm³ skull.
//   Compaction ratio: ~4× by volume, but the surface complexity is far greater.
//
//   Gyrification index (GI) = total cortical surface area / exposed surface area
//   Human GI ≈ 2.57 (cortex has 2.57× more surface than a smooth brain would)
//   Dolphins: GI ≈ 5.0 (more folded than humans)
//   Rats: GI ≈ 1.0 (lissencephalic — smooth brain)
//
//   The TENSION-COMPRESSION theory of gyrification (van Essen, 1997):
//   - Axons pull connected regions together (tension)
//   - Compression from skull pushes back
//   - Balance determines fold wavelength:
//       λ = 2π · (E_cortex / (3 · E_subcortex))^(1/3) · t_cortex
//   where E = elastic modulus, t = cortical thickness.
//
//   This is origami: the crease pattern is determined by mechanical buckling,
//   not by explicit design. Nature solves a circle-packing problem.
//
//   Gyrus (plural: gyri)  = raised ridge = mountain fold
//   Sulcus (plural: sulci) = groove     = valley fold
//
// VISUAL MODES:
//   mode 0 — Cortical surface (top view): gyrification pattern
//   mode 1 — Cross-section: sulci and gyri in sagittal slice
//   mode 2 — Unfolded cortex (flat sheet, crease pattern visible)
//   mode 3 — Development sequence (smooth → folded, embryological)
//
// PARAMETERS:
//   foldAngle     – gyrification stage [0=smooth lissencephalic, 180=fully gyrified]
//   creaseDensity – number of folds / complexity
//   curvature     – fold curvature [0=sharp sulci, 1=rounded sulci]
//   origamiStyle  – mode 0-3

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_foldAngle;
uniform float u_creaseDensity;
uniform float u_curvature;
uniform float u_origamiStyle;

const float PI     = 3.14159265358979;
const float TWO_PI = 6.28318530717959;

// ── Noise / hash ─────────────────────────────────────────────────────────────
vec2 hash2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}
float noise(vec2 p) {
    vec2 i = floor(p), f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(hash2(i),             f),
                   dot(hash2(i + vec2(1,0)), f - vec2(1,0)), u.x),
               mix(dot(hash2(i + vec2(0,1)), f - vec2(0,1)),
                   dot(hash2(i + vec2(1,1)), f - vec2(1,1)), u.x), u.y);
}
float fbm(vec2 p, int oct) {
    float v = 0.0, a = 0.5;
    for (int o = 0; o < 6; o++) {
        if (o >= oct) break;
        v += a * noise(p); p *= 2.03; a *= 0.5;
    }
    return v;
}

// ── Gyrification field ───────────────────────────────────────────────────────
// Returns a value where ridges (gyri) are high and grooves (sulci) are low.
// Uses fBm with a buckling-wave component to mimic van Essen tension-based folding.
float gyrificationField(vec2 uv, float t) {
    float scale = u_creaseDensity * 0.08 + 2.0;
    float gyri = fbm(uv * scale, 4);

    // Buckling wavelength modulated by gyrification stage
    float λ = 0.3 * (1.0 - t * 0.5);  // shorter wavelength as GI increases
    float buckle = sin(uv.x * PI / λ + noise(uv * 3.0) * 2.0)
                 * sin(uv.y * PI / λ + noise(uv * 3.0 + 1.7) * 2.0);
    buckle = buckle * 0.5 + 0.5;

    // Blend fBm organic complexity with mechanical buckle pattern
    return mix(gyri * 0.5 + 0.5, buckle, t * 0.6) * t + 0.1 * (1.0 - t);
}

// ── Cortical surface (top view) ──────────────────────────────────────────────
vec3 corticalSurface(vec2 uv, float t) {
    float gf = gyrificationField(uv, t);

    // Brain boundary: elliptical
    vec2  c   = uv - 0.5;
    float ellipse = length(c * vec2(1.0, 1.25));
    float inBrain = smoothstep(0.40, 0.38, ellipse);

    // Cortex colour: varies by depth
    // Gyri (raised, gf high): pink-grey (gray matter exposed)
    // Sulci (grooved, gf low): darker (deeper sulcal fundus)
    vec3 gyrusCol  = vec3(0.80, 0.68, 0.62);   // gray matter, pinkish
    vec3 sulcusCol = vec3(0.40, 0.32, 0.30);   // deeper sulcal wall
    vec3 cortexCol = mix(sulcusCol, gyrusCol, gf);

    // Subsurface (white matter) gleam at sulcal depths
    float wm = smoothstep(0.3, 0.0, gf) * t;
    cortexCol = mix(cortexCol, vec3(0.85, 0.82, 0.78), wm * 0.3);

    // Vascular pattern: surface blood vessels
    float vessel = fbm(uv * 18.0 + u_time * 0.05, 2) * 0.5;
    float vesselLine = smoothstep(0.55, 0.5, vessel) * t;
    cortexCol = mix(cortexCol, vec3(0.75, 0.20, 0.18), vesselLine * 0.35);

    // Sulcus lines (crease pattern)
    float sulcus = smoothstep(0.35 + u_curvature * 0.1, 0.25, gf) * t;
    cortexCol = mix(cortexCol, vec3(0.25, 0.20, 0.18), sulcus * 0.5);

    // Fold shadow
    float shadow = (1.0 - gf) * t * 0.5;
    cortexCol *= (1.0 - shadow);

    return mix(vec3(0.12, 0.10, 0.10), cortexCol, inBrain);
}

// ── Cross-section (sagittal slice) ───────────────────────────────────────────
vec3 crossSection(vec2 uv, float t) {
    // Section view: horizontal = anterior-posterior, vertical = depth
    float scale = u_creaseDensity * 0.06 + 1.5;
    float gf = gyrificationField(vec2(uv.x, uv.y * 0.3), t);

    // Cortical ribbon: a thin band at the top surface
    float cortexY  = 0.75 + gf * 0.15 * t;  // surface height modulated by folds
    float cortexD  = abs(uv.y - cortexY);
    float cortexW  = 0.06 + u_curvature * 0.03;
    float inCortex = smoothstep(cortexW, 0.0, cortexD);

    // White matter (below cortex)
    float inWM = step(uv.y, cortexY - cortexW * 0.5) * step(0.2, uv.y);

    // Subcortical grey matter (deep nuclei)
    float subcortical = smoothstep(0.07, 0.0, abs(length(uv - vec2(0.5, 0.38)) - 0.12));

    // Cerebral spinal fluid in sulci (bright)
    float csfD = cortexD - cortexW;
    float csf  = smoothstep(0.0, 0.08, csfD) * step(0.0, csfD) * t;

    vec3 col = vec3(0.08, 0.07, 0.08);  // void background
    col = mix(col, vec3(0.88, 0.82, 0.78), inWM * 0.7);              // white matter
    col = mix(col, vec3(0.65, 0.52, 0.48), inCortex * 0.9);          // cortex
    col = mix(col, vec3(0.50, 0.40, 0.38), subcortical * 0.8);       // deep nuclei
    col = mix(col, vec3(0.75, 0.85, 0.92), csf * 0.6);               // CSF
    // Sulcus lines
    float sulcusLine = smoothstep(0.006, 0.0, cortexD) * (1.0 - inCortex) * t;
    col = mix(col, vec3(0.25, 0.22, 0.20), sulcusLine * 0.5);

    return col;
}

// ── Unfolded cortex (crease pattern) ─────────────────────────────────────────
vec3 unfoldedCortex(vec2 uv, float t) {
    float scale = u_creaseDensity * 0.1 + 3.0;
    float gf    = gyrificationField(uv, 1.0); // full gyrification regardless

    // Sulcus lines = valley folds (blue)
    float sulcus = smoothstep(0.32, 0.28, gf);
    // Gyrus ridges = mountain folds (red)
    float gyrus  = smoothstep(0.68, 0.72, gf);

    // Cortical area map: functional regions have distinct hue
    float area = noise(uv * 4.0 + 1.7) * 0.5 + 0.5;
    vec3 areaCol = 0.7 + 0.3 * cos(vec3(0.0, 2.1, 4.2) + area * PI * 2.0);

    vec3 paper = vec3(0.95, 0.92, 0.86);
    vec3 col   = mix(paper, areaCol * 0.85, 0.3);

    // Mix in fold colours based on deployment state
    col = mix(col, vec3(0.15, 0.32, 0.78), sulcus * t * 0.65);   // valley = blue
    col = mix(col, vec3(0.80, 0.18, 0.12), gyrus  * t * 0.65);   // mountain = red

    // Ghost lines (sulci that close when unfolded)
    float ghost = smoothstep(0.35, 0.28, gf) * (1.0 - t) * 0.4;
    col = mix(col, vec3(0.65, 0.55, 0.50), ghost);

    return col;
}

// ── Development sequence (embryological gyrification) ────────────────────────
vec3 developmentSeq(vec2 uv, float t) {
    // Age-like progression: smooth → primary folds → secondary → tertiary
    float stage = t * 3.0; // 0=lissencephalic, 1=primary, 2=secondary, 3=tertiary

    // Stage 0-1: primary sulci emerge
    float s1 = clamp(stage, 0.0, 1.0);
    float gf1 = fbm(uv * 3.0, 2) * s1;

    // Stage 1-2: secondary sulci
    float s2 = clamp(stage - 1.0, 0.0, 1.0);
    float gf2 = fbm(uv * 6.0 + 3.1, 2) * s2 * 0.7;

    // Stage 2-3: tertiary (fine-grained)
    float s3 = clamp(stage - 2.0, 0.0, 1.0);
    float gf3 = fbm(uv * 12.0 + 5.7, 2) * s3 * 0.5;

    float gf = gf1 + gf2 + gf3;
    gf = clamp(gf, 0.0, 1.0);

    // Smooth brain base: uniform pale pink
    vec3 smoothBrain = vec3(0.88, 0.78, 0.72);
    // Gyrified: textured reddish grey
    vec3 gyrCol = mix(vec3(0.40, 0.32, 0.30), vec3(0.78, 0.68, 0.62), gf);

    vec3 col = mix(smoothBrain, gyrCol, t);

    // Emerging sulcus lines
    float sulcus = smoothstep(0.35, 0.25, gf) * t * 0.7;
    col = mix(col, vec3(0.28, 0.22, 0.20), sulcus);

    // Primary sulcus highlight (central sulcus, lateral fissure)
    float centralSulcus = abs(uv.x - 0.5 - noise(uv * 2.0) * 0.05) - 0.015;
    float sylvian       = abs(uv.y - 0.35 - (uv.x - 0.5) * 0.3 - noise(uv * 3.0) * 0.03);
    float primSulci = min(smoothstep(0.012, 0.0, centralSulcus),
                          smoothstep(0.010, 0.0, sylvian));
    col = mix(col, vec3(0.22, 0.18, 0.17), primSulci * s1 * 0.7);

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
    if      (mode == 0) col = corticalSurface(p, t);
    else if (mode == 1) col = crossSection(p, t);
    else if (mode == 2) col = unfoldedCortex(p, t);
    else                col = developmentSeq(p, t);

    // Vignette
    vec2 cv = uv - vec2(aspect * 0.5, 0.5);
    col *= 1.0 - 0.3 * dot(cv, cv) * 3.0;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
