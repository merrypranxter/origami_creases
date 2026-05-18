// biological_fold.glsl
// Nature's origami: protein folding, DNA packaging, leaf unfurling,
// insect wing deployment, embryonic gastrulation.
//
// BIOLOGICAL FOLDING HIERARCHY:
//   Protein   — amino acid chain → secondary (helix/sheet) → tertiary (3D form)
//   DNA       — 2 m of double helix → 30 nm fibre → 300 nm loop → 700 nm chromosome
//   Leaf      — pleated/rolled bud → unfurled blade (reversible origami)
//   Wing      — beetle hindwing: 4× area, 2D crease pattern in 3D space
//   Embryo    — gastrulation: epithelial sheet invaginates into cup (irreversible)
//
// PARAMETERS:
//   foldAngle     – deployment state [0=packed, 180=fully deployed]
//   origamiStyle  – 0=protein, 1=DNA, 2=leaf, 3=wing (reuses style enum)
//   creaseDensity – complexity of biological fold
//   curvature     – 0=sharp/protein-like, 1=curved/organic

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_foldAngle;
uniform float u_origamiStyle;  // 0=protein 1=DNA 2=leaf 3=wing
uniform float u_creaseDensity;
uniform float u_curvature;

const float PI = 3.14159265358979;

// ── Noise ─────────────────────────────────────────────────────────────────
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
float fbm(vec2 p, int oct) {
    float v = 0.0, a = 0.5;
    for (int o = 0; o < 6; o++) {
        if (o >= oct) break;
        v += a * noise(p); p *= 2.1; a *= 0.5;
    }
    return v;
}

// ── Protein folding (α-helix crease pattern) ─────────────────────────────
vec3 proteinFold(vec2 uv, float deploy) {
    // Helix as a spiral crease pattern
    float helix = sin(uv.y * 30.0 + uv.x * 8.0 + u_time * 0.5) * 0.5 + 0.5;
    float sheet = step(0.45, fract(uv.y * 8.0)) * step(fract(uv.x * 12.0), 0.9);

    // Deployed = visible structure; packed = dense noise
    float structure = mix(fbm(uv * 5.0, 4), helix * 0.6 + sheet * 0.4, deploy);

    // Colour: amino-acid spectrum (biochemistry false-colour convention)
    vec3 col = mix(vec3(0.15, 0.45, 0.75),  // hydrophilic blue
                   vec3(0.85, 0.40, 0.10),  // hydrophobic orange
                   structure);
    return mix(col, vec3(0.05, 0.08, 0.05), 1.0 - deploy * 0.8);
}

// ── DNA packaging (chromosome coiling) ────────────────────────────────────
vec3 dnaFold(vec2 uv, float deploy) {
    float t = u_time * 0.4;
    // Double helix rails
    float helix1 = abs(sin(uv.y * 40.0 + t) - uv.x * 2.0 + 1.0);
    float helix2 = abs(sin(uv.y * 40.0 + t + PI) - uv.x * 2.0 + 1.0);
    float dna = smoothstep(0.08, 0.0, min(helix1, helix2)) * deploy;

    // Base pairs: rungs
    float rung = smoothstep(0.03, 0.0, abs(fract(uv.y * 40.0 / PI) - 0.5) - 0.3)
                 * step(abs(uv.x - 0.5), 0.2) * deploy;

    // Background: nucleosome packing pattern
    float nucleosome = fbm(uv * 10.0, 3) * (1.0 - deploy * 0.6);

    vec3 col = vec3(0.05, 0.10, 0.08);
    col = mix(col, vec3(0.80, 0.85, 0.20), dna);
    col = mix(col, vec3(0.90, 0.50, 0.20), rung);
    col += vec3(0.15, 0.35, 0.20) * nucleosome * 0.5;
    return col;
}

// ── Leaf unfurling ────────────────────────────────────────────────────────
vec3 leafFold(vec2 uv, float deploy) {
    // Leaf veins as crease pattern (midrib + lateral veins)
    vec2 c = uv - 0.5;
    float midrib = abs(c.x) - 0.003;
    float lateral = abs(abs(c.y) * 0.5 - abs(c.x) * 1.2 + 0.01);

    float vein = smoothstep(0.006, 0.0, min(midrib, lateral));

    // Pleated bud packing: accordion fold
    float pleat = abs(sin(c.y * u_creaseDensity * 0.8));
    float openness = deploy;

    // Leaf green from chlorophyll
    vec3 leafGreen = vec3(0.20, 0.55, 0.18);
    vec3 budGreen  = vec3(0.40, 0.65, 0.15);
    vec3 col = mix(budGreen * (0.6 + pleat * 0.4), leafGreen, openness);
    col = mix(col, vec3(0.05, 0.10, 0.02), vein * 0.6);

    // Subsurface light (translucence)
    float sss = fbm(uv * 8.0, 2) * 0.2 * deploy;
    col += vec3(0.6, 0.9, 0.3) * sss;

    return col;
}

// ── Insect wing deployment ────────────────────────────────────────────────
vec3 wingFold(vec2 uv, float deploy) {
    // Beetle hindwing: 4× area, complex 3D crease
    float t = u_time * 0.3;
    // Wing veins: branching network
    float vein = 0.0;
    for (float k = 1.0; k < 6.0; k++) {
        float angle = k * PI / 5.0;
        vec2 dir = vec2(cos(angle), sin(angle));
        float d = abs(dot(uv - 0.5, vec2(-dir.y, dir.x)));
        vein = max(vein, smoothstep(0.008, 0.001, d) * smoothstep(0.5, 0.0, abs(dot(uv - 0.5, dir))));
    }

    // Iridescence from thin-film interference (structural colour)
    float iri = sin(length(uv - 0.5) * 80.0 - t) * 0.5 + 0.5;
    vec3 iriCol = 0.5 + 0.5 * cos(vec3(0.0, 2.1, 4.2) + iri * PI * 2.0);

    // Membrane transparency
    vec3 col = mix(vec3(0.95, 0.95, 0.98), iriCol * 0.8, deploy * 0.7);
    col = mix(col, vec3(0.1, 0.08, 0.05), vein * 0.8 * deploy);

    // Folded creases (packed = darker, crumpled zones)
    float packed = fbm(uv * 15.0, 3) * (1.0 - deploy) * 0.5;
    col *= (1.0 - packed * 0.6);

    return col;
}

// ── Main ──────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float deploy = u_foldAngle / 180.0;

    vec3 col;
    int mode = int(u_origamiStyle);

    if (mode == 0)      col = proteinFold(uv, deploy);
    else if (mode == 1) col = dnaFold(uv, deploy);
    else if (mode == 2) col = leafFold(uv, deploy);
    else                col = wingFold(uv, deploy);

    // Vignette
    vec2 cv = uv - 0.5;
    col *= 1.0 - 0.3 * dot(cv, cv) * 4.0;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
