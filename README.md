# ORIGAMI CREASES
## Paper as Mathematics. Fold as Algorithm. Crane as Equation.

> *"A crease is a decision. Once folded, the paper remembers. It cannot unfold without scarring. Every origami model is a timeline of choices — mountain folds, valley folds, the geometry of intention made physical. The crane is not a bird. It is a proof."*

---

## WHAT THIS IS

This repo is a visual knowledge pack for **origami-inspired visual systems** — the mathematics of paper folding as generative art, the crease pattern as blueprint, the folded form as emergent sculpture.

You have NOTHING about origami. Nothing about paper. Nothing about the sacred geometry of the fold. You have `sacred_geometry` and `crystalline` and `tesselations` but nothing that captures the specific poetry of a sheet becoming a form through a sequence of decisions.

When RepoScripter ingests this alongside `sacred_geometry`, `islamic_tiling`, `crystalline`, or `neural_architecture`, expect the AI to create visual systems that "fold" — patterns that crease, collapse, unfold, and reveal hidden structure. Tessellations that behave like origami. Architecture that folds flat.

---

## CORE CONCEPTS

### 1. The Crease Pattern (CP)
Every origami model begins as a flat diagram of lines:
- **Mountain fold** (dash-dot line): Paper folds away from you
- **Valley fold** (dashed line): Paper folds toward you
- **Crease assignment**: A valid CP must obey Kawasaki-Justin and Maekawa theorems at every vertex
- **Flat-foldability**: A CP can fold flat iff all vertices satisfy: alternation of mountain/valley AND (M - V) = ±2

### 2. Rigid Origami
Folds act as hinges. Paper between creases stays flat:
- **Dihedral angles**: The angle between adjacent flat panels
- **Fold angle**: 0° = flat, 180° = fully folded
- **Single vertex**: Folds radiate from a point. The sum of alternating angles = 180°

### 3. Tessellation Origami
Repeating fold patterns tile the plane:
- **Miura-ori**: Famous space-folding pattern. Used for satellite solar panels.
- **Waterbomb tessellation**: Hexagonal pattern, rigid-foldable
- **Ron Resch pattern**: Triangular rigid-foldable tessellation
- **Yoshimura pattern**: Diamond-array cylindrical folding

### 4. Curved Folding
Not all folds are straight:
- **David Huffman**: Pioneered curved-crease origami
- **Developable surfaces**: Curved folds on developable surfaces (zero Gaussian curvature)
- **Parabolic rulings**: Curved folds create parabolic rulings in the unfolded state

### 5. Computational Origami
Algorithmic design:
- **TreeMaker**: Robert Lang's software — design a stick figure, get a crease pattern
- **Disk packing**: Circles on paper represent flaps. Packing determines crease pattern.
- **Origami solveability**: NP-hard in general. But many practical cases have elegant solutions.

---

## MATHEMATICAL FOUNDATION

### Maekawa's Theorem
At any flat-foldable vertex:
```
M - V = ±2
```
Where M = number of mountain folds, V = number of valley folds.

### Kawasaki's Theorem
At any flat-foldable vertex with angles a₁, a₂, ..., a₂n:
```
a₁ - a₂ + a₃ - a₄ + ... + a₂n₋₁ - a₂n = 0
```
Alternating sum of angles must equal zero.

### Rigid Origami Constraint
For a quadrilateral panel with fold angles θ₁, θ₂, θ₃, θ₄:
```
tan(θ₁/2) * tan(θ₃/2) = tan(θ₂/2) * tan(θ₄/2)
```
This is the spherical law of cosines applied to origami.

### Miura-Ori Angle
For a Miura-ori with sector angles α and β:
```
Fold angle φ satisfies: cos(φ) = (cos(α) + cos(β)) / (1 + cos(α+β))
```

---

## INSIDE THE BOX (Fundamentals)

### Basic Crease Pattern Visualization
See `code/basic_crease.glsl` — render a crease pattern with mountain/valley coloring, verify Maekawa/Kawasaki, show fold animation.

### Miura-Ori Tessellation
See `code/miura_ori.glsl` — the classic space-folding pattern. Animated folding from flat to collapsed. Used for deployable structures.

### Curved Crease Simulation
See `code/curved_crease.glsl` — David Huffman-style curved folds. Developable surfaces with parabolic rulings.

### TreeMaker Stick Figure to CP
See `code/treemaker.glsl` — simplified: given a tree (stick figure), generate a crease pattern that produces it. Circle packing visualization.

---

## OUTSIDE THE BOX (Creative Destinations)

### Emotional Origami
The fold state represents feeling:
- **Open**: Vulnerable, exposed, all angles visible
- **Partially folded**: Defensive, ambiguous, some hidden
- **Fully collapsed**: Compressed, protected, dense with potential energy
- **Unfolding**: Revealing, remembering, healing
- **Crease memory**: Old creases are scars — visible even when unfolded

### Origami Architecture
Buildings that fold:
- **Deployable shelters**: Flat-pack emergency housing that unfolds into structure
- **Kinetic facades**: Building skin that folds to control light, air, privacy
- **Transforming interiors**: Walls that fold away, furniture that folds from flat panels
- **Space-saving**: Tokyo-apartment origami — everything folds into walls

### Origami as Time
Each fold is a moment:
- **Timeline**: The sequence of folds is a narrative
- **Flashback**: Unfolding reveals earlier states
- **Foreshadowing**: Creases that will become important later are already there
- **Irreversibility**: Some folds create permanent change (wet-folding, crumpling)

### Crumpled Origami
Not all origami is precise:
- **Crumple patterns**: Random folds create complex, fractal-like patterns
- **Crease density**: Higher density = more complex form potential
- **Statistical origami**: What emerges from random crease assignment?
- **Paper memory**: A heavily crumpled sheet remembers every crease. It is a history.

### Quantum Origami
Superposition of fold states:
- A crease is both mountain AND valley until observed
- Folding one vertex collapses the wavefunction for adjacent vertices
- Entanglement: two distant creases are correlated — fold one, the other responds
- The sheet exists in multiple folded configurations simultaneously

### Biological Origami
Nature folds:
- **Protein folding**: The original origami. Amino acid sequence → 3D structure.
- **DNA packaging**: 2 meters of DNA folds into a 6-micron nucleus. Ultimate space-saving.
- **Leaf unfolding**: Buds as tightly packed origami. Unfurling as deployment.
- **Insect wings**: Folded for crawling, deployed for flight. Living origami.
- **Embryonic folding**: Gastrulation as large-scale origami. The body folds itself.

### Sacred Origami
The fold as ritual:
- **1000 cranes**: Senbazuru. Each fold is a prayer. The collective is a blessing.
- **Tessellation mandalas**: Folded patterns as meditation objects
- **Modular origami**: Many identical units become one sacred geometry form
- **The fold as creation myth**: In the beginning, the universe was flat. Then it folded.

---

## BLENDING WITH OTHER REPOS

**+ `sacred_geometry`** → Crease patterns that ARE sacred geometry. Sri Yantra as fold pattern. Flower of Life tessellation. The fold reveals the sacred.

**+ `islamic_tiling`** → Islamic girih tiles as crease patterns. Stars and rosettes fold into 3D muqarnas vaulting. Flat decoration becomes architectural space.

**+ `crystalline`** → Crystal growth as folding. Lattice planes as creases. Phase transitions as fold operations. The crystal is origami of atoms.

**+ `neural_architecture`** → Brain folding (gyrification) as origami. The cortex folds to fit volume. Neural pathways as crease patterns. Folding increases surface area.

**+ `bioluminescent_systems`** → Folded structures that glow. Origami lamps. Bioluminescent organisms as folded geometries. The fold traps light.

**+ `caustic_networks`** → Light passing through folded transparent panels creates caustic patterns. The fold controls light. Origami optics.

---

## ARTISTIC REFERENCES

- **Robert J. Lang** — physicist + origami artist. TreeMaker software. Laser-cut origami.
- **Tomoko Fuse** — modular origami pioneer. Box designs, unit tessellations.
- **Miyuki Kawamura** — animals with personality. Wet-folding for curves.
- **David Huffman** — curved-crease origami. Developable surfaces. Computer science + art.
- **Paul Jackson** — conceptual origami. "Folding Techniques for Designers."
- **Jun Maekawa** — geometric origami. Mathematical purity.
- **Satoshi Kamiya** — hyper-complex models. Phoenix, Ryujin (dragon with 2000+ steps).
- **Eric Joisel** — wet-folded human figures. Expressive, sculptural.
- **Richard Sweeney** — paper sculpture, not traditional origami. Large-scale folded installations.
- **Zaha Hadid's folded architecture** — continuum, fluid, origami-inspired built forms.
- **Buckminster Fuller's Dymaxion map** — foldable cartography.

---

## PARAMETER SPACE

| Parameter | Range | Effect |
|-----------|-------|--------|
| `foldAngle` | 0-180 | Current dihedral angle. 0=flat, 180=fully folded |
| `creaseDensity` | 1-100 | Number of creases per unit area |
| `mountainRatio` | 0.3-0.7 | Proportion of mountain vs valley folds |
| `curvature` | 0-1 | 0=straight creases only, 1=all curved |
| `tessellationType` | miura/resch/waterbomb/yoshimura/custom | Which tessellation pattern |
| `foldSequence` | auto/manual | Automatic animation vs step-by-step |
| `paperColor` | white/kraft/washi/metallic | Material aesthetic |
| `creaseVisibility` | 0-1 | How visible the crease lines are |
| `shadowDepth` | 0-1 | Layered shadow between folded panels |
| `origamiStyle` | geometric/organic/modular/curved | Design tradition |
| `showMath` | 0/1 | Overlay Maekawa/Kawasaki verification |

---

## REPOSCRIPTER INTEGRATION

When this repo is loaded into RepoScripter as context:
- **Crease patterns** are primary visual elements — networks of lines that carry meaning
- **Fold animation** is a powerful transition technique — flat → 3D reveals hidden structure
- **Tessellation origami** offers infinite pattern generation with physical plausibility
- **Curved folding** adds organic, sculptural quality to geometric systems
- The AI should feel free to make anything "fold": maps, faces, time, data, emotions, architecture
- Suggest **rigid origami constraints** when the prompt involves deployable, transformable, or kinetic structures

---

## FILES

```
README.md                    <— You are here
context.manifest.json        <— RepoScripter ingestion manifest
code/
  basic_crease.glsl         <— Fundamental CP visualization
  miura_ori.glsl            <— Space-folding tessellation
  curved_crease.glsl        <— David Huffman-style folds
  treemaker.glsl            <— Stick figure to crease pattern
  emotional_fold.glsl       <— Feeling as fold state
  crumple_pattern.glsl      <— Random/statistical origami
  quantum_fold.glsl         <— Superposition of fold states
  biological_fold.glsl      <— Protein, DNA, leaf, wing folding
  sacred_origami.glsl       <— Ritual, mandala, creation myth
docs/
  origami_math.md           <— Maekawa, Kawasaki, rigid constraints
  tessellations.md          <— Miura, Resch, Waterbomb, Yoshimura
  computational_origami.md  <— TreeMaker, circle packing, NP-hardness
  origami_artists.md        <— Lang, Fuse, Jackson, Kamiya, etc.
  paper_physics.md          <— Why paper folds, crumples, remembers
images/
  [placeholders for reference imagery]
```

---

## MANIFESTO

> *"Paper is the most honest material. It has no opinion. It simply obeys the mathematics of the fold. Mountain or valley — it accepts either. But it remembers. A crease is a scar. A sheet that has been folded a thousand times is a history. It carries the weight of every decision. And when you unfold it, the creases remain, ghost lines of what it once was. This is the truth of origami: it is not about the final form. It is about the sequence of choices that got there. The crane is not the point. The point is the thousand small obediences that made the crane possible. Every fold was a moment when the paper said yes."*

---

*ORIGAMI CREASES v1.0*
*For RepoScripter v7.7.7+*
*Created by Merry Pranxter's chaos consortium*
*"Flat things want to become three-dimensional. Help them."*
