// emotional_fold.glsl
// Origami as emotional landscape. The fold-state encodes feeling.
//
//   OPEN         → foldAngle ≈ 0    — vulnerable, all angles exposed, warm light
//   PARTIAL      → foldAngle ≈ 60°  — ambiguous, some hidden, amber shadow
//   CLOSED       → foldAngle ≈ 180° — compressed, protected, cool blue density
//   UNFOLDING    → foldAngle decreasing over time — revealing, remembering
//   CREASE SCAR  → visible ghost creases even when open — memory, history
//
// PARAMETERS:
//   foldAngle     – emotional state encoded as dihedral [0, 180]
//   creaseDensity – complexity of inner emotional topology
//   shadowDepth   – weight of hidden layers

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_foldAngle;    // [0, 180]
uniform float u_creaseDensity;
uniform float u_shadowDepth;

const float PI = 3.14159265358979;

// ── Noise ─────────────────────────────────────────────────────────────────
vec2 hash2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453);
}
float noise(vec2 p) {
    vec2 i = floor(p), f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(hash2(i + vec2(0,0)), f - vec2(0,0)),
                   dot(hash2(i + vec2(1,0)), f - vec2(1,0)), u.x),
               mix(dot(hash2(i + vec2(0,1)), f - vec2(0,1)),
                   dot(hash2(i + vec2(1,1)), f - vec2(1,1)), u.x), u.y);
}

// ── Emotional colour mapping ───────────────────────────────────────────────
// 0=open(warm white) → 0.33=partial(amber) → 0.66=defensive(grey) → 1=closed(blue-black)
vec3 emotionColour(float t) {
    vec3 open     = vec3(0.98, 0.95, 0.85); // warm open paper
    vec3 partial  = vec3(0.90, 0.72, 0.40); // amber, transitional
    vec3 defensive= vec3(0.60, 0.60, 0.65); // cool grey, guarded
    vec3 closed   = vec3(0.12, 0.15, 0.28); // deep blue, collapsed

    if (t < 0.33) return mix(open, partial, t / 0.33);
    if (t < 0.66) return mix(partial, defensive, (t - 0.33) / 0.33);
    return mix(defensive, closed, (t - 0.66) / 0.34);
}

// ── Ghost crease (scar) ───────────────────────────────────────────────────
// Old creases remain visible as scars even when the fold is open.
float ghostCrease(vec2 uv, float density, float scarAge) {
    float minD = 1e9;
    for (float k = 0.0; k < 12.0; k++) {
        if (k >= density) break;
        float y = (k + 0.5) / density;
        // Slight wobble from paper memory
        float wobble = noise(vec2(uv.x * 6.0, k * 3.7)) * 0.012 * scarAge;
        float d = abs(uv.y - y + wobble);
        minD = min(minD, d);
    }
    return minD;
}

// ── Fold compression ──────────────────────────────────────────────────────
// Compresses vertical UV to simulate panels stacking as fold closes
vec2 foldedUV(vec2 uv, float phi) {
    float compress = 1.0 - 0.65 * (phi / PI);
    return vec2(uv.x, (uv.y - 0.5) * compress + 0.5);
}

// ── Inner geometry (emotional topology) ───────────────────────────────────
float innerGeometry(vec2 uv, float phi, float density) {
    float t = phi / PI;
    // Layered fold lines — concentric rectangles collapsing inward
    float layer = 0.0;
    for (float k = 1.0; k < 8.0; k++) {
        if (k > density * 0.5) break;
        float margin = k * 0.07 * (1.0 - t * 0.6);
        float rect = max(abs(uv.x - 0.5) - (0.5 - margin),
                         abs(uv.y - 0.5) - (0.5 - margin * 0.6));
        layer += smoothstep(0.005, 0.0, abs(rect)) * (1.0 / k);
    }
    return layer;
}

// ── Main ──────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;

    float phi = u_foldAngle * PI / 180.0;
    float t   = phi / PI; // emotional state ∈ [0,1]

    // Apply folded UV for panel compression
    vec2 fuv = foldedUV(uv, phi);

    // Base emotional colour
    vec3 col = emotionColour(t);

    // Breathing: open states pulsate gently
    float breath = (1.0 - t) * 0.04 * sin(u_time * 1.2);
    col += breath;

    // Ghost creases (scar memory)
    float scarAge = 1.0 - t * 0.5; // scars remain visible even when open
    float ghostD = ghostCrease(fuv, u_creaseDensity * 0.5, scarAge);
    float scar = smoothstep(0.006, 0.001, ghostD);
    vec3 scarCol = mix(col * 0.7, vec3(0.55, 0.45, 0.35), 0.5); // old scar tone
    col = mix(col, scarCol, scar * 0.4 * scarAge);

    // Active fold creases (sharp, emotional intensity)
    float creaseD = ghostCrease(fuv, u_creaseDensity, 1.0);
    float crease = smoothstep(0.004, 0.001, creaseD);
    vec3 creaseCol = mix(vec3(0.80, 0.18, 0.12), vec3(0.15, 0.32, 0.78), t);
    col = mix(col, creaseCol, crease * 0.7);

    // Inner geometry (soul topology)
    float inner = innerGeometry(uv, phi, u_creaseDensity);
    col = mix(col, col * 0.6 + vec3(0.1, 0.05, 0.2) * t, inner * u_shadowDepth);

    // Shadow deepens as closed
    float shadow = t * t * u_shadowDepth * 0.6;
    col *= (1.0 - shadow);

    // Soft vignette
    vec2 cv = uv - 0.5;
    col *= 1.0 - 0.35 * dot(cv, cv) * 4.0;

    // Slight noise / paper grain
    float grain = noise(uv * 400.0 + u_time * 0.01) * 0.025;
    col += grain * (1.0 - t * 0.5);

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
