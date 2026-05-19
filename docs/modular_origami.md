# Modular Origami
## Units, Assemblies, and the Mathematics of Interlocking Modules

---

> *"A Sonobe unit is nothing. Thirty Sonobe units, assembled without glue, become an icosahedron. The form emerges from repetition. The whole exceeds the sum of its parts by geometric necessity."*

---

## What Is Modular Origami?

**Modular origami** (also called **unit origami**) is a branch of origami in which a model is assembled from multiple identical folded units — called **modules** or **units** — that interlock with each other without glue, tape, or additional fastening.

Each unit serves a specific structural role:
- **Pocket**: A triangular opening that receives another unit's tab
- **Tab**: A pointed projection that inserts into another unit's pocket

The resulting assembly is held together entirely by tension and friction between the interlocking paper elements.

### Why Modular?

1. **Complexity from simplicity**: Each individual unit is simple to fold (5–10 steps). The assembly of many units creates forms of great geometric complexity.
2. **Collaborative creation**: Many people can fold units independently, then assemble together — a social activity.
3. **Structural integrity**: Properly designed modular assemblies are surprisingly rigid. A well-assembled Sonobe icosahedron can bear significant weight.
4. **Mathematical isomorphism**: Every modular assembly corresponds to a polyhedron or graph. The mathematics is explicit.

---

## 1. The Sonobe Unit

The Sonobe unit, attributed to Mitsunobu Sonobe (though with disputed origins), is the foundational modular unit.

### 1.1 The Fold Sequence

The Sonobe unit is folded from a square of paper:
1. Fold in half diagonally; unfold.
2. Fold both bottom corners to the diagonal centre line.
3. Fold the top layer down to align with the bottom.
4. Fold the left corner to the centre; fold the right corner under the left flap.
5. The result: a parallelogram with a **tab** (pointed corner) and a **pocket** (triangular opening).

The unit is roughly a 1:2 parallelogram when complete.

### 1.2 Assembly Mechanics

Three Sonobe units assemble into a **triangular pyramid** (triakis unit):
- Insert Tab A of Unit 1 into Pocket of Unit 2
- Insert Tab B of Unit 2 into Pocket of Unit 3
- Insert Tab B of Unit 3 into Pocket of Unit 1
- Close: insert remaining tabs into remaining pockets

Each **edge** of the final polyhedron corresponds to one **unit**. The unit spans the edge, with its tab and pocket engaging the vertices at each end.

### 1.3 Sonobe Assemblies and Polyhedra

| Units | Assembly | Polyhedron |
|-------|----------|------------|
| 3 | Triangle | Triakis unit (open pyramid) |
| 6 | Cube | Cube with stellated faces |
| 12 | Stellated octahedron | Triakis octahedron |
| 30 | Icosahedron | Icosahedron (stellated) |
| 90 | Stellated icosahedron | Triakis icosahedron |
| 270 | Stellated truncated icosahedron | Complex star polyhedron |

The general rule: **each edge of the target polyhedron requires exactly one Sonobe unit**.

For the icosahedron: V=12, E=30, F=20. Therefore: **30 units**.

### 1.4 Colour Patterns

The Sonobe unit has a visible "face" and a hidden "back." For the icosahedron assembly, a 5-colour pattern ensures each face of the stellated form shows a consistent colour. The mathematics of valid colouring patterns is equivalent to **proper edge-colouring** of the polyhedron's edge graph — a non-trivial combinatorics problem for complex polyhedra.

---

## 2. The PHiZZ Unit (Pentagon-Hexagon Zig-Zag)

Invented by Tom Hull in 1993. The PHiZZ unit is a small strip of paper folded into an angular module that assembles into any **planar 3-regular graph** (cubic graph).

### 2.1 The Unit

The PHiZZ unit is folded from a 1:5 (or 1:4) strip of paper:
1. Form a small triangle at one end.
2. Zig-zag fold the strip back and forth, threading each new fold through the previous one.
3. The result: a small angular unit with a pocket at each end.

### 2.2 Assembly and Graph Theory

**PHiZZ units → edges of a 3-regular graph** (every vertex has degree 3).

The most famous assembly: the **truncated icosahedron** (soccer ball / buckyball):
- 90 units (90 edges)
- 60 vertices (each vertex = 3 units meeting)
- 12 pentagonal faces + 20 hexagonal faces

The rule for valid assembly: **at each vertex, exactly 3 units meet**. The assembly must include a valid mixture of pentagonal and hexagonal cycles. For closed polyhedra, by Euler's formula and degree-counting:

```
12·(5-cycle) + n·(6-cycle) = any valid assembly
```

**(Always exactly 12 pentagons needed, regardless of n.)**

This is the same rule that determines fullerene molecules (C₆₀, C₈₀, etc.) — PHiZZ assemblies are physical models of carbon fullerenes.

### 2.3 Hull's Theorem

Tom Hull proved that a PHiZZ assembly is **structurally stable** iff the corresponding graph has no "flaps" (degree-2 vertices) and forms a valid closed polyhedron. The paper tension from the zig-zag mechanism locks the assembly in place.

---

## 3. Waterbomb Module

The waterbomb module is a square folded into a **triangular base** with two pockets and two tabs. It assembles into octahedra and cubes.

### 3.1 The Unit

From a square:
1. Fold in half vertically and horizontally; unfold.
2. Fold in half diagonally both ways; unfold.
3. Collapse on the diagonals into a "waterbomb base" — a right triangle with layers.
4. The result: a flat triangle with two open pockets at the back and two pointed tabs at the front.

### 3.2 Assemblies

- **3 units → triangular dipyramid** (bipyramid with 2 triangular faces and 3 square faces)
- **6 units → octahedron** (8 triangular faces, but 6 units give the correct edge count E=12)
- **12 units → cuboctahedron**
- **30 units → icosahedron** (same as Sonobe, different visual texture)

The waterbomb octahedron is the simplest stable 3D modular form — often taught as a first modular project.

---

## 4. Kusudama: The Modular Flower Ball

**Kusudama** (from Japanese: *kusuri* = medicine, *dama* = ball) is an ancient Japanese paper craft. Modern kusudama blurs the line between modular origami and wet-folded sculpture.

### 4.1 Classic Kusudama Unit

The traditional kusudama unit is a **pinwheel flower** module:
1. Fold a square diagonally.
2. Curl or fold the two open corners inward to create a petal shape.
3. Glue (traditionally) or interlock 5 petals to form a flower unit.
4. Assemble 12 flower units into a sphere (using glue or elastic bands at the joining faces).

### 4.2 Mathematics

The kusudama corresponds to a **regular dodecahedron** (12 pentagonal faces):
- 12 flower units = 12 pentagonal faces
- Each flower = 5 petals = 5 triangular sub-faces
- Total paper units = 12 × 5 = 60

Euler check: V=20, E=30, F=12 for dodecahedron. ✓

### 4.3 Modular Kusudama (No Glue)

Modern kusudama designs (Tomoko Fuse, Miyuki Kawamura) use **interlocking tabs** instead of glue:
- Each petal has a slit that receives the adjacent petal's tip
- Tighter interlocking requires the paper to be slightly curved (wet-folding helps)
- The tension of 60 units in the spherical assembly provides structural stability

---

## 5. Modular Polyhedra: The Complete Family

The five **Platonic solids** and their modular origami correspondences:

| Solid | V | E | F | Unit count (by edge) | Unit count (by face) |
|-------|---|---|---|---------------------|---------------------|
| Tetrahedron | 4 | 6 | 4 | 6 Sonobe | 4 pyramid units |
| Cube | 8 | 12 | 6 | 12 Sonobe | 6 square units |
| Octahedron | 6 | 12 | 8 | 12 Sonobe | 8 triangle units |
| Dodecahedron | 20 | 30 | 12 | 30 Sonobe | 12 pentagon units |
| Icosahedron | 12 | 30 | 20 | 30 Sonobe | 20 triangle units |

**Archimedean solids** follow the same logic. The truncated icosahedron (buckyball):
- V=60, E=90, F=32 (12 pentagons + 20 hexagons)
- 90 PHiZZ units or 90 other edge-based units

### 5.1 Euler's Formula as a Constraint

For any valid closed polyhedron: V - E + F = 2. This constrains how many units are needed:
- If using edge-based units: units = E
- If using vertex-based units: units = V × (vertex valence / valence_per_unit)
- If using face-based units: units = F

A modular origami designer must solve: "given my unit's tab/pocket structure, what polyhedron does it build?"

---

## 6. Structural Mechanics of Modular Origami

### 6.1 Load Paths

In a Sonobe icosahedron, each unit is under **axial compression** along its long axis (the edge direction) and **bending stress** at the tabs. The assembly is pre-stressed by the mutual tension of all 30 units.

The icosahedron is the **most efficient triangulated structure** per unit volume — the same reason geodesic domes (Buckminster Fuller) use icosahedral symmetry.

### 6.2 Failure Modes

1. **Tab pullout**: The tab slides out of the pocket under load. Prevented by sufficient pocket depth and paper friction.
2. **Paper creep**: Under sustained load, paper fibres relax. Assemblies should be stored without stress.
3. **Humidity**: Paper weakens significantly above 70% relative humidity. Museum kusudama are stored at controlled humidity.
4. **Catastrophic unfolding**: If one unit fails, adjacent units may cascade. The icosahedron is particularly resistant to this (triangulated structures are inherently stable).

---

## 7. Notable Artists and Designers

### Tomoko Fuse
The undisputed master of unit origami. Her books define the field:
- *Unit Origami: Multidimensional Transformations* (1990)
- *Spiral Origami Art Design* (2012)
- *Origami Quilts* (2002)

Fuse's contribution: bringing mathematical rigour to modular origami design, producing units that are simultaneously elegant and structurally sound.

### Tom Hull
Mathematician at Western New England University. Invented the PHiZZ unit and proved formal results about modular origami's relationship to graph theory.

### Miyuki Kawamura
Creates modular forms that approximate smooth curved surfaces using faceted units. Her "polypolyhedra" (multiple interlocking polyhedra) demonstrate extreme modular complexity.

### Robert Lang
Though primarily a single-sheet artist, Lang designed the **Opus 236** (modular icosahedron using 30 units of his own design) as a study in geometric modular origami.

---

## 8. References

- **Fuse, T.** (1990). *Unit Origami: Multidimensional Transformations*. Japan Publications.
- **Hull, T.** (1994). "On the Mathematics of Flat Origamis." *Congressus Numerantium*, 100.
- **Hull, T.** (2002). "The combinatorics of flat folds: a survey." *Origami 3: Third International Meeting of Origami Science, Mathematics, and Education*.
- **Kawamura, M.** (2001). *Polyhedron Origami for Beginners*. Japan Publications Trading.
- **Lang, R.J.** (2011). *Origami Design Secrets*. CRC Press. Chapter 15: Modular Origami.
- **Mitchell, D.** (1997). *Mathematical Origami: Geometrical Shapes by Paper Folding*. Tarquin Publications.
- **Kasahara, K. & Takahama, T.** (1987). *Origami for the Connoisseur*. Japan Publications.
