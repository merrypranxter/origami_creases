// quantum_fold.glsl
// Superposition of fold states — a crease exists as both mountain AND valley
// until observed. Folding one vertex collapses the wavefunction for neighbours.
//
// QUANTUM ORIGAMI MODEL:
//   Each crease |c⟩ is in superposition: |c⟩ = α|mountain⟩ + β|valley⟩
//   with |α|² + |β|² = 1.
//   Observation (fold_angle > threshold) collapses the state.
//   Entangled pairs: crease i and crease j are correlated —
//     changing fold state of i instantaneously determines j (Bell inequality).
//
//   Visualised via interference fringes (wave function) + collapse zones.
//
// PARAMETERS:
//   foldAngle     – observation strength [0, 180]; higher = more collapse
//   creaseDensity – number of entangled crease pairs
//   mountainRatio – initial wavefunction bias toward mountain
//   showMath      – show probability amplitude overlay |ψ|²

#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2  u_resolution;
uniform float u_foldAngle;
uniform float u_creaseDensity;
uniform float u_mountainRatio;
uniform bool  u_showMath;

const float PI    = 3.14159265358979;
const float TWO_PI = 6.28318530717959;

// ── Complex number helpers ─────────────────────────────────────────────────
vec2 cmul(vec2 a, vec2 b) { return vec2(a.x*b.x - a.y*b.y, a.x*b.y + a.y*b.x); }
vec2 cexp(float theta) { return vec2(cos(theta), sin(theta)); }

// ── Hash ──────────────────────────────────────────────────────────────────
float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
vec2  hash2(float n) { return vec2(fract(sin(n)*43758.5), fract(cos(n)*38741.3)); }

// ── Quantum probability amplitude for a single crease ─────────────────────
// Returns |ψ|² at position uv near crease line.
// Before observation: interference fringes. After: collapsed single value.
float creaseAmplitude(vec2 uv, float creaseY, float observeStrength, float phase) {
    float d = uv.y - creaseY;

    // Wave function: two-slit-like interference along crease direction
    vec2 psi_mtn = cexp(phase +  PI * uv.x * 4.0);
    vec2 psi_val = cexp(phase + -PI * uv.x * 4.0 + PI);
    vec2 psi_total = psi_mtn + psi_val;
    float amplitude = dot(psi_total, psi_total) * 0.25; // |ψ|²

    // Gaussian envelope around crease line
    float envelope = exp(-d * d / 0.003);

    // Collapse: replace interference with a sharp delta
    float collapsed = exp(-d * d / 0.0001);

    return mix(amplitude * envelope, collapsed, observeStrength);
}

// ── Entanglement correlation ───────────────────────────────────────────────
// Two distant creases share a Bell state. Measuring one sets the other.
float entanglementGlow(vec2 uv, vec2 c1, vec2 c2, float observeStrength) {
    // EPR-like correlation channel between two crease endpoints
    float d1 = length(uv - c1);
    float d2 = length(uv - c2);
    float corr = cos((d1 - d2) * 40.0 + u_time * 1.5); // interference
    float both = exp(-min(d1, d2) * 6.0);
    return corr * both * (1.0 - observeStrength);
}

// ── Wavefunction collapse event ───────────────────────────────────────────
float collapseFlash(vec2 uv, float creaseY, float observeStrength, float time) {
    // A collapse ripple propagates outward from the fold event
    float d = abs(uv.y - creaseY);
    float rippleR = mod(time * 0.8, 0.5);
    float ripple = smoothstep(0.01, 0.0, abs(d - rippleR));
    return ripple * observeStrength * smoothstep(0.5, 0.0, rippleR);
}

// ── Main ──────────────────────────────────────────────────────────────────
void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;

    float observe = u_foldAngle / 180.0; // 0=superposition, 1=fully collapsed
    int N = int(clamp(u_creaseDensity * 0.1, 2.0, 12.0));

    // Paper: cool quantum void
    vec3 voidCol  = vec3(0.04, 0.04, 0.08);
    vec3 paperCol = vec3(0.94, 0.92, 0.88);
    vec3 col = mix(paperCol, voidCol, observe * 0.7);

    float mtnBias = u_mountainRatio;

    for (int i = 0; i < 12; i++) {
        if (i >= N) break;
        float fi = float(i);
        float creaseY = (fi + 0.5) / float(N);
        float phase = hash(vec2(fi, 3.7)) * TWO_PI;
        bool isMtn = hash(vec2(fi, 1.3)) < mtnBias;

        // Probability amplitude
        float amp = creaseAmplitude(uv, creaseY, observe, phase);

        // Mountain (red) vs Valley (blue) in superposition → purple; collapsed → pure
        vec3 mtnCol = vec3(0.90, 0.15, 0.10);
        vec3 valCol = vec3(0.10, 0.25, 0.90);
        vec3 superCol = mix(vec3(0.55, 0.10, 0.75), vec3(0.75, 0.30, 0.90), mtnBias); // quantum purple
        vec3 definiteCol = isMtn ? mtnCol : valCol;
        vec3 creaseCol = mix(superCol, definiteCol, observe);

        col = mix(col, creaseCol, amp * 0.8);

        // Entanglement glow between crease i and i+1
        if (i < N - 1) {
            vec2 ep1 = vec2(0.2 + hash(vec2(fi, 5.1)) * 0.6, creaseY);
            vec2 ep2 = vec2(0.2 + hash(vec2(fi+1.0, 5.1)) * 0.6, (fi + 1.5) / float(N));
            float eg = entanglementGlow(uv, ep1, ep2, observe);
            col += vec3(0.4, 0.0, 0.8) * eg * 0.3;
        }

        // Collapse flash (visible during transition)
        float flash = collapseFlash(uv, creaseY, observe, u_time + fi * 0.4);
        col += vec3(1.0, 0.9, 0.5) * flash * 0.8;
    }

    // ── |ψ|² overlay ───────────────────────────────────────────────────────
    if (u_showMath) {
        float wfGrid = sin(uv.x * 60.0) * sin(uv.y * 60.0) * 0.03;
        col += vec3(0.3, 0.9, 0.5) * max(0.0, wfGrid) * (1.0 - observe);
    }

    // Vignette (quantum dark edge)
    vec2 cv = uv - 0.5;
    col *= 1.0 - 0.5 * dot(cv, cv) * 4.0;

    gl_FragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
