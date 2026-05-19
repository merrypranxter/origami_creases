# Curved Crease Geometry
## The Differential Geometry of Huffman-Style Curved Folds

---

> *"David Huffman spent the last decades of his life finding theorems in paper. The paper was the proof."*

---

## 1. What Is a Curved Crease?

A **curved crease** is a fold line that follows a smooth curve rather than a straight line. David Huffman pioneered this art form in the 1970s–90s, working almost entirely in isolation. When his work was rediscovered after his death in 1999, it transformed the field.

A flat sheet folded along a straight crease produces two flat half-planes. A flat sheet folded along a curved crease produces two **ruled surfaces** — surfaces that are curved in 3D space, yet are locally flat (zero Gaussian curvature). This is the central paradox and beauty of curved-crease origami.

---

## 2. Developable Surfaces: The Foundation

Before understanding curved creases, we need the concept of **developable surfaces**.

### 2.1 Definition

A surface is **developable** if it can be obtained by bending a flat sheet without stretching or tearing. Equivalently:

```
Gaussian curvature K = 0 everywhere on the surface
```

The Gaussian curvature K = κ₁ · κ₂, where κ₁ and κ₂ are the principal curvatures. K = 0 means at least one principal curvature is always zero.

### 2.2 The Three Developable Surfaces

There are exactly three families of developable surfaces:

1. **Cylinders** (κ₁ = 0, κ₂ ≠ 0): Flat in one direction, curved in the other. All straight-crease origami produces cylindrical surfaces.

2. **Cones** (κ₁ = 0, κ₂ ≠ 0, but the zero-curvature direction passes through a single point): Straight rulings converge to a point.

3. **Tangent developable surfaces** (κ₁ = 0): The surface consists of tangent lines to a space curve. These appear in curved-crease origami.

And their combinations.

### 2.3 Rulings

A **ruling** is a straight line that lies entirely within a surface. Developable surfaces are **ruled surfaces**: every point on a developable surface lies on exactly one ruling.

For a cylinder: rulings are parallel lines.
For a cone: rulings pass through the apex.
For a tangent developable: rulings are tangent to the **edge of regression** (a space curve whose tangents form the surface).

---

## 3. The Geometry of a Curved Crease

### 3.1 Setup

Let γ(s) be a curve on a flat sheet (the **crease curve** in the unfolded state), parameterised by arc length s. When the sheet is folded along γ, the crease curve maps to a 3D space curve Γ(s).

The fold produces two surfaces, one on each side of the crease:
- **S₁**: the surface of paper on the "left" side of γ
- **S₂**: the surface of paper on the "right" side of γ

Both S₁ and S₂ must be developable (K = 0 everywhere), since they are bent from flat paper.

### 3.2 The Ruling Angle

At each point of the crease curve, each surface has a ruling direction. Let **ψ₁(s)** be the angle between the ruling of S₁ and the crease tangent, and **ψ₂(s)** the same for S₂.

The key constraint is:

```
ψ₁ ≠ ψ₂ in general (the rulings are NOT symmetric about the crease)
```

But they are related by the **fold angle** α(s) (the dihedral angle between the two surfaces at the crease). Specifically, the fold angle and the ruling angles are linked through the Frenet-Serret frame of the space curve Γ.

### 3.3 Geodesic Curvature Constraint

This is Huffman's key result. For a fold along a curve on a flat sheet, the **geodesic curvature** κ_g of the crease must satisfy:

```
κ_g(S₁) = −κ_g(S₂)
```

The geodesic curvature of the fold curve, measured from each side of the fold, must be equal and opposite. This is the fundamental theorem of curved-crease origami.

**Geometric meaning**: Geodesic curvature measures how much a curve turns "within the surface." A curve with zero geodesic curvature (a **geodesic**) is the straightest possible path on the surface. The equal-and-opposite condition means the crease curve bends the same amount into each panel, balancing the fold.

### 3.4 Ruling Angle Evolution

Given the geodesic curvature constraint, how do the ruling directions change along the crease? The evolution equation is:

```
dψ/ds = κ_g(s)
```

where κ_g(s) is the signed geodesic curvature of the crease curve in the flat sheet, and ψ(s) is the ruling angle at position s.

This is a first-order ODE that can be integrated: if you know ψ at one point and the shape of the crease in the flat sheet, you can compute the ruling directions everywhere.

---

## 4. Special Cases

### 4.1 Straight Crease (κ_g = 0)

When the crease is straight, κ_g = 0, so dψ/ds = 0: the ruling angle is constant. This gives parallel rulings — the result is cylindrical folding, recovering standard straight-crease origami.

### 4.2 Circular Crease

For a circular crease of radius R in the flat sheet, κ_g = 1/R (constant). The ruling angle evolves linearly:

```
ψ(s) = ψ₀ + s/R
```

The rulings spiral outward. The folded surface is a portion of a **cone** (on the inside of the circle) and a **tangent developable** (on the outside). This is the characteristic Huffman "conical fold."

### 4.3 Parabolic Crease

Huffman was particularly fascinated by parabolic creases. A parabolic crease (in the flat sheet) produces a **hyperbolic paraboloid**-like folded surface — a saddle surface that is locally flat but globally doubly curved in appearance.

The parabola y = ax² has curvature κ = 2a / (1 + 4a²x²)^(3/2). Substituting into dψ/ds = κ gives the ruling angle evolution for a parabolic crease.

---

## 5. The Fold Angle and Ruling Angle Relationship

For a given crease point, the fold angle α (dihedral angle between the two panels) and the ruling angles ψ₁, ψ₂ are related by:

```
cos(α) = (cos(ψ₁) · cos(ψ₂) − sin(ψ₁) · sin(ψ₂) · cos(2θ)) / (sin²(θ))
```

where θ is a geometric angle depending on the local curvature of the crease.

In the simpler symmetric case (when the fold is symmetric about the crease normal plane):

```
ψ₁ = ψ₂ = ψ
α = 2 · arctan(sin(ψ) / cos(θ/2))
```

This means: **the fold angle and ruling angle are not independent**. Specifying the crease shape in the flat sheet (which determines ψ via dψ/ds = κ_g) constrains the possible fold angles.

---

## 6. Design Implications

### 6.1 The Design Space

A curved crease design has the following degrees of freedom:
1. **Choice of crease curve** in the flat sheet (determines κ_g(s), hence ψ(s))
2. **Initial ruling angle** ψ₀ (a single free constant per crease)
3. **Fold angle** at one point (partially constrained by ψ via the formula above)

All other properties follow from these choices. This is why curved-crease design is simultaneously constrained (not everything is possible) and rich (the space of possibilities is vast).

### 6.2 Multi-Crease Designs

Huffman's most complex works have multiple curved creases interacting. Each crease constrains the ruling geometry of its panels. The panels between adjacent creases must share a common ruling structure (since each panel is a single developable surface).

This creates a **system of ODE constraints** for a multi-crease pattern — significantly more complex than single-crease analysis.

### 6.3 What Cannot Be Done

Not all curved crease patterns are valid:
- **Non-zero Gaussian curvature** between creases: impossible (would require stretching)
- **Rulings crossing**: two rulings of the same surface cannot cross (would cause self-intersection)
- **Incompatible crease curvatures**: adjacent panels may have conflicting ruling requirements

---

## 7. Huffman's Geometric Language

Huffman worked in the language of projective geometry and differential geometry, deriving everything from first principles. His key insight was:

> *"When you fold paper along a curve, you are making a differential geometry machine. The curve in the flat state is the input; the surface in the folded state is the output; the transformation is governed by the same equations as geodesic flow."*

He described fold patterns in terms of:
- **Osculating planes**: The plane containing the tangent and normal to the crease at each point
- **Binormal vector**: The axis perpendicular to the osculating plane; determines which way the fold "leans"
- **Torsion**: How the osculating plane rotates along the crease; coupled to the ruling angle rotation

---

## 8. Computational Curved-Crease Design

### 8.1 Direct Computation

Given a crease curve γ in the flat sheet:
1. Compute κ_g(s) (geodesic curvature as a function of arc length)
2. Integrate ψ(s) = ψ₀ + ∫₀ˢ κ_g(s') ds'
3. Compute the 3D crease curve Γ(s) by integrating the Frenet-Serret equations with fold-angle constraints
4. Sweep rulings to construct the 3D surface

### 8.2 Optimisation-Based Design

Tachi's **Freeform Origami** software takes a different approach:
1. Discretise the crease as a piecewise-linear polyline
2. Each segment is a straight crease (standard rigid origami)
3. Optimise the polyline shape to approximate desired curved-crease behaviour
4. Use rigid-origami simulation for the resulting discrete crease pattern

This approximation works well for smooth crease curves and is computationally tractable.

### 8.3 Inverse Design

Given a desired 3D surface form, find the flat crease pattern that folds to it:
- This is an **inverse problem** — generally underdetermined (many crease patterns can produce similar 3D forms)
- Current approaches: numerical optimisation, geometry-processing algorithms (Kilian et al., 2008)
- Active research area: closed-form solutions exist only for simple cases (cylinders, cones)

---

## 9. Huffman's Aesthetic Principle

Huffman worked at the intersection of art and mathematics. His pieces are characterised by:

- **Economy**: Minimal creases, maximal 3D complexity. One parabola in the flat sheet becomes a sweeping architectural surface in 3D.
- **Surprise**: The 3D form is not visually predictable from the flat crease pattern — only the mathematics reveals the relationship.
- **Self-reference**: The crease pattern IS the mathematical proof of the surface it creates.

His pieces are in the collection of the Computer History Museum (Palo Alto) and have been exhibited at SIGGRAPH.

---

## 10. References

- **Huffman, D.A.** (1976). "Curvature and Creases: A Primer on Paper." *IEEE Transactions on Computers*, C-25(10).
- **Demaine, E., Demaine, M., Koschitz, D. & Tachi, T.** (2015). "Curved Crease Folding: A Review on Art, Design and Mathematics." *Proceedings IABSE-IASS Symposium*.
- **Kilian, M., Flöry, S., Chen, Z., Mitra, N.J., Sheffer, A. & Pottmann, H.** (2008). "Curved Folding." *ACM SIGGRAPH*, 27(3).
- **Tachi, T.** (2013). "Freeform Origami Tessellations by Generalizing Resch's Patterns." *Journal of Mechanical Design*, 135(11).
- **Kergosien, Y., Gotoda, H. & Kunii, T.** (1994). "Bending and Creasing Virtual Paper." *IEEE Computer Graphics and Applications*, 14(1).
- **Fuchs, D. & Tabachnikov, S.** (1999). "More on Paperfolding." *The American Mathematical Monthly*, 106(1).
- **Demaine, E.D. & O'Rourke, J.** (2007). *Geometric Folding Algorithms*. Cambridge University Press. Chapter 11: Curved Creases.
