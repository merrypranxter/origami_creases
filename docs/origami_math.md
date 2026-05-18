# Origami Mathematics
## Maekawa, Kawasaki, Rigid Origami Constraints, and Flat-Foldability

---

## 1. Flat-Foldability

A crease pattern (CP) is **flat-foldable** if and only if it can be folded along all creases simultaneously to produce a flat, multi-layered result with no self-intersection.

Two necessary and sufficient local conditions must hold at **every interior vertex**:

### 1.1 Maekawa's Theorem

At any flat-foldable interior vertex:

```
M − V = ±2
```

Where:
- **M** = number of mountain folds at the vertex
- **V** = number of valley folds at the vertex

The difference is always exactly ±2, never 0, never ±4. This means the total number of creases at a flat-foldable vertex must be **even**. Vertices with an odd number of creases cannot be flat-foldable.

**Proof sketch**: Consider walking around the vertex. Mountain and valley folds alternate in a way that the paper can close flat only if they differ by exactly 2.

### 1.2 Kawasaki-Justin Theorem

At any flat-foldable vertex with 2n creases creating sector angles α₁, α₂, α₃, ..., α₂ₙ:

```
α₁ − α₂ + α₃ − α₄ + ... + α₂ₙ₋₁ − α₂ₙ = 0
```

The alternating sum of consecutive angles around the vertex equals zero. Equivalently:

```
α₁ + α₃ + α₅ + ... = α₂ + α₄ + α₆ + ... = π
```

The odd-indexed angles sum to π and the even-indexed angles sum to π.

**Geometric intuition**: The paper on each side of the vertex must "balance" angularly so that the two halves can fold flat against each other.

### 1.3 The Two Conditions Together

Both Maekawa and Kawasaki must hold simultaneously. Neither alone is sufficient for flat-foldability. However, they are local conditions — satisfying them at every vertex is necessary but **not sufficient** globally (global self-intersection may still occur).

---

## 2. Rigid Origami

**Rigid origami** treats each face of the crease pattern as a rigid flat panel and each crease as a frictionless hinge. The paper does not bend between creases; only the hinge angles change.

This is a more restrictive condition than flat-foldability: most flat-foldable crease patterns are **not** rigid-foldable.

### 2.1 Single Rigid Vertex

For a rigid-foldable degree-4 vertex (the minimum for non-trivial rigid folding), with fold angles θ₁, θ₂, θ₃, θ₄ and sector angles α, β, γ, δ where α + β + γ + δ = 2π:

The **compatibility constraint** (spherical law of cosines applied to origami) reads:

```
tan(θ₁/2) · tan(θ₃/2) = tan(θ₂/2) · tan(θ₄/2)
```

This single equation means that a degree-4 flat-foldable vertex has exactly **1 degree of freedom** (DOF) as a rigid mechanism — once one fold angle is specified, all others are determined.

### 2.2 Degree-4 Vertex: Full Solution

For a degree-4 vertex with sector angles α₁, α₂, α₃, α₄ and a driving fold angle θ₁, the other angles satisfy:

```
tan(θ₂/2) = tan(θ₁/2) · sin((α₁+α₂)/2) / sin((α₃+α₄)/2)
tan(θ₃/2) = tan(θ₁/2)
tan(θ₄/2) = tan(θ₁/2) · sin((α₃+α₄)/2) / sin((α₁+α₂)/2)
```

(for the Miura-type symmetric case; general formula more complex)

### 2.3 Extended Rigid Origami: Multiple Vertices

For a crease pattern with multiple rigid vertices, the compatibility conditions must hold simultaneously across all vertices. This creates an **over-constrained system** in general. The pattern is rigid-foldable only if this system has a non-trivial solution space (i.e., at least 1 DOF globally).

Rigid-foldable tessellations (like Miura-ori, Resch, waterbomb) are specially designed to have exactly this property.

---

## 3. Miura-Ori: A Rigid-Foldable Tessellation

The Miura-ori is parameterised by:
- Sector angle **α** ∈ (0°, 90°) — the acute angle of the parallelogram panels
- Panel dimensions **a** × **b**

### 3.1 Fold Angle Relationship

The Miura-ori is a degree-4 vertex system with all vertices identical. Given the deployment angle **φ** (angle between adjacent panels, measured from flat = 0):

```
cos(φ) = (cos²(α) − sin²(α) · cos²(θ)) / (1 − sin²(α) · sin²(θ))
```

where θ ∈ [0°, 90°] is the deployment parameter (θ = 90° is fully flat, θ = 0° is fully folded).

### 3.2 Single DOF

The Miura-ori entire tessellation has **exactly 1 DOF**: folding in one axis simultaneously folds in the perpendicular axis. When the sheet compresses horizontally, it expands vertically, and vice versa — a **negative Poisson ratio** behaviour.

```
Poisson ratio ν = −(dε_y / dε_x) < 0
```

This is why Miura-ori is used for deployable satellite solar panels: a single pull fully deploys the sheet.

---

## 4. Global Flat-Foldability

Beyond local vertex conditions, global flat-foldability requires that the paper does not self-intersect when folded. This is checked via **layer ordering** and **non-crossing conditions**.

### 4.1 Layer Ordering Problem

When a CP is folded flat, panels stack in layers. A valid layer ordering must satisfy:
- If panel A is above panel B at one location, it must be consistently above everywhere they overlap.
- This ordering must be a **total preorder** (no cycles).

Finding a valid layer ordering is **NP-complete** in general (Bern & Hayes, 1996).

### 4.2 Simple Bird Base Test

For the classic bird base (used in the traditional paper crane), the mountain-valley assignment is highly constrained — the crease pattern has only a small number of valid assignments that satisfy both Maekawa and Kawasaki at all 6 interior vertices simultaneously.

---

## 5. Fold Angles and Dihedral Angles

**Fold angle**: Angle between two adjacent panels, measured from the unfolded flat state.
- 0° = flat (paper flat, crease exists but not yet folded)
- 90° = perpendicular panels
- 180° = fully folded (panels face each other)

**Dihedral angle**: The interior angle between two half-planes. Dihedral angle = 180° − fold angle.

For visualisation, fold angle of 0° appears as a crease only (line), while 180° means the paper is doubled over.

---

## 6. References

- **Maekawa, J.** (1989). "Hiroi origami no suri" (On the mathematics of flat origami). In *Origami for the Connoisseur*.
- **Kawasaki, T.** (1989). "On the relation between mountain-creases and valley-creases of a flat origami." *Proceedings of the First International Meeting of Origami Science and Technology*.
- **Justin, J.** (1986). "Résolution par origami de l'équation du troisième degré." *Le Pli*.
- **Belcastro, S. & Hull, T.** (2002). "Modelling the folding of paper into three dimensions using affine transformations." *Linear Algebra and its Applications*.
- **Bern, M. & Hayes, B.** (1996). "The complexity of flat origami." *Proceedings of SODA 1996*.
- **Lang, R.J.** (2011). *Origami Design Secrets: Mathematical Methods for an Ancient Art.* 2nd ed. CRC Press.
- **Demaine, E.D. & O'Rourke, J.** (2007). *Geometric Folding Algorithms: Linkages, Origami, Polyhedra.* Cambridge University Press.
