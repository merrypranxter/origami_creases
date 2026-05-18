# Paper Physics
## Why Paper Folds, Crumples, and Remembers

---

> *"Paper is made of fibres. Fibres are made of cellulose. Cellulose is a polymer. A polymer is a geometry. Everything folds."*

---

## 1. What Paper Is

Paper is a **fibrous composite**: a mat of cellulose fibres derived from wood pulp (or cotton, hemp, linen, etc.), dried under tension into a thin flat sheet.

### Composition
- **Cellulose**: Long-chain polymer (C₆H₁₀O₅)ₙ, the structural component of plant cell walls
- **Hemicellulose**: Shorter branching polysaccharides; acts as adhesive between fibres
- **Lignin**: Removed in chemical pulping; its presence makes paper yellower and more brittle over time
- **Sizing agents**: Starch or alum added to control absorbency (affects folding quality)
- **Water**: Paper typically contains 5–8% moisture by mass; this dramatically affects mechanical properties

### Structure
Fibres are randomly oriented but show a weak preference for the **machine direction** (MD) — the direction the paper travelled on the wire during manufacture. This creates mild anisotropy:
- Paper tears more easily parallel to MD
- Paper folds more sharply perpendicular to MD

---

## 2. The Mechanics of a Fold

When paper is folded, several physical processes occur simultaneously:

### 2.1 Elastic Bending

A thin elastic plate bends with a curvature κ. For small deformations:

```
M = EI · κ
```

Where:
- **M** = bending moment
- **E** = Young's modulus of paper (~3–10 GPa, depending on paper type)
- **I** = second moment of area = (t³/12) where t is paper thickness
- **κ** = curvature = 1/R

Paper is thin, so it can accommodate large curvatures without breaking — but there's a yield point.

### 2.2 Plastic Deformation at the Crease

When the fold is sharp (small bending radius), stresses exceed the **yield stress** of the paper. The fibres are permanently deformed:

1. **Fibre buckling**: Fibres on the compressed (inner) side of the fold buckle
2. **Fibre stretching**: Fibres on the tension (outer) side elongate
3. **Hydrogen bond breaking**: Cellulose fibres are held together by hydrogen bonds; these break irreversibly under sufficient stress
4. **Fibre kinking**: Fibres develop kink bands (microscale origami within the paper itself)

This irreversible deformation is the **crease**. The crease remains even when the paper is unfolded — the paper "remembers."

### 2.3 The Crease as a Scar

The crease is a zone of permanent compressive and tensile damage. Its mechanical properties:
- **Lower bending stiffness**: The crease zone is weaker than uncreased paper
- **Preferential fold site**: Paper will re-fold at existing creases more easily than at new sites
- **Visible even unfolded**: The fibre damage is visible as a white or darker line depending on paper type

This is why "the paper remembers" — it does not return to its original structure. Every fold leaves a physical trace.

---

## 3. Crease Geometry and Paper Thickness

In theoretical origami, paper has zero thickness. In practice, thickness matters:

### 3.1 The Bending Radius Problem

A fold requires the paper to bend around the crease. For a sheet of thickness **t** folded to a fold angle of 180°:
- The **outer surface** travels a distance π·t/2 further than the **inner surface**
- This creates an unavoidable geometric incompatibility
- For thin paper (t < 0.1 mm, like typical origami paper), this is negligible
- For thick materials (cardboard, metal foil), it causes panel interference

### 3.2 Thick Origami Solutions

Several engineering solutions exist:
- **Panel offsetting**: Panels are shortened to account for fold radius
- **Hinge gap**: A small gap is left at each crease (reduces interference)
- **Tapered edges**: Panels taper toward creases (Tachi's method)
- **Kirigami cuts**: Small slits along the fold line relieve the incompatibility

---

## 4. Paper Types and Folding Properties

### 4.1 Traditional Origami Paper (Kami)

- **Thickness**: 60–80 gsm (grams per square metre)
- **Surface**: Often coloured on one side, white on other
- **Fold quality**: Crisp, holds shape well
- **Wet-folding**: Not suitable — dissolves
- **Best for**: Geometric models, tessellations, practice

### 4.2 Washi (Japanese Paper)

- **Composition**: Long kozo (mulberry) fibres, less refined
- **Thickness**: 20–40 gsm (very thin but strong due to long fibres)
- **Fold quality**: Excellent — thin, but fibre length prevents tearing
- **Wet-folding**: Excellent — holds curves when dried
- **Best for**: Complex multi-step models, sculpted organic forms

### 4.3 Tissue Foil

- **Structure**: Aluminium foil laminated between two layers of thin tissue paper
- **Fold quality**: Holds position at any angle (no spring-back)
- **Memory**: Extreme — will not return to flat
- **Best for**: Kamiya-style hyper-complex models needing precise small folds

### 4.4 Kraft Paper

- **Composition**: Unbleached wood pulp, long fibres
- **Properties**: Strong, slightly rough texture, brown colour
- **Wet-folding**: Good
- **Best for**: Large-scale sculptures, architectural models

### 4.5 Metallic/Foil Paper

- **Composition**: Aluminium foil, typically 12–25 μm thick
- **Properties**: Iridescent, stiff, holds shape perfectly
- **Limitation**: Does not dry crease well — shows every handling mark
- **Best for**: Decorative geometric models where crispness is paramount

---

## 5. The Physics of Crumpling

Crumpling is origami without intention — random fold assignment at high density.

### 5.1 Energy Scaling

For a crumpled ball of size R made from paper of thickness t and bending stiffness B:

```
E_crumple ~ B · L² / R²
```

Where L is the sheet size. The energy is stored in **ridges** (1D bending concentrations) and **vertices** (d-cones).

### 5.2 D-Cones (Developable Cones)

When a flat sheet is pushed at a point, it forms a **d-cone** — a conical singularity. The cone:
- Has zero Gaussian curvature everywhere except the apex
- Concentrates bending energy at the tip
- Radiates fan-shaped creases outward

The d-cone is the elementary building block of crumpling — just as the vertex is the elementary building block of origami.

### 5.3 Ridge Networks

Under confinement, d-cones connect via **ridges** — narrow zones of high curvature. The ridge network has a fractal-like character:
- Ridges satisfy: bending radius R_ridge ~ t^(1/3) · L^(2/3)
- Energy: E_ridge ~ B^(1/3) · (Et)^(2/3) · L^(5/3)
- Number of creases: N(r) ~ r^(-D) where D ≈ 2 (power law)

### 5.4 Paper Memory After Crumpling

A crumpled sheet that is unfolded retains a complex crease network. This "crumple memory" has been studied as:
- An information storage medium (crumple = encode; flatten = read)
- A random code for authentication (each crumpled ball is unique)
- A physical analogue of frustrated magnetic systems

---

## 6. Wet-Folding: Paper as Plastic

Wet-folding exploits the reversibility of hydrogen bonding:

1. Dampen paper slightly (10–15% water content increase)
2. Fold and sculpt while wet — hydrogen bonds reform wherever the wet fibres are pressed together
3. Allow to dry — bonds lock in the new shape
4. Result: Organic, sculpted forms impossible with dry paper

### Why It Works

Cellulose fibres are held together by hydrogen bonds (O-H···O bonds between hydroxyl groups). Water molecules:
- Compete for hydrogen bond sites, temporarily breaking fibre-fibre bonds
- Act as a plasticiser, allowing fibres to slide past each other
- When water evaporates, fibres form new bonds in their displaced positions

This is effectively **paper-level origami**: the fibres within the sheet are being folded and locked.

---

## 7. Paper Aging and Degradation

### 7.1 Acid Degradation

Acidic paper (pH < 6) undergoes **hydrolysis**: water molecules break the glycosidic bonds in cellulose. The paper becomes brittle and yellows. This is why archive paper is acid-free.

### 7.2 Oxidation

Lignin oxidises in air and UV light, creating chromophores (colour-producing molecules). This is why newspaper yellows rapidly — high lignin content.

### 7.3 Implications for Origami Conservation

- Traditional origami paper (kami) is typically acidic — it will not last centuries
- Washi (especially handmade kozo paper) is often acid-free and can last 1000+ years
- Museum-quality origami (Yoshizawa's work, for example) is stored at controlled humidity and temperature

---

## 8. References

- **Lobkovsky, A. et al.** (1995). "Scaling Properties of Stretching Ridges in a Crumpled Elastic Sheet." *Science*, 270(5241).
- **Witten, T.A.** (2007). "Stress focusing in elastic sheets." *Reviews of Modern Physics*, 79(2).
- **Vliegenthart, G.A. & Gompper, G.** (2006). "Forced crumpling of self-avoiding elastic sheets." *Nature Materials*, 5.
- **Cerda, E. & Mahadevan, L.** (2005). "Confined developable elastic surfaces: cylinders, cones and the 'd-cone'." *Proceedings of the Royal Society A*, 461.
- **Yoshizawa, A.** (1954/2002). *Atarashii Origami Geijutsu*. (New Origami Art.)
- **Jackson, P.** (2011). *Folding Techniques for Designers*. Laurence King.
- **Horrocks, A.R. & Anand, S.C.** (eds.) (2000). *Handbook of Technical Textiles*. Woodhead Publishing. (Fibre mechanics background)
