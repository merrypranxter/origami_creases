# Tessellation Origami
## Miura-ori, Resch, Waterbomb, Yoshimura, and Beyond

---

## What Is a Tessellation?

An origami **tessellation** is a crease pattern that tiles the plane by repetition of a fundamental unit cell. Unlike single-model origami, a tessellation:
- Has no defined "top" or "bottom" of the model
- Can be extended arbitrarily in 2D (or wrapped around 3D surfaces)
- Is often (but not always) rigid-foldable
- Typically has a high degree of symmetry

The repeating unit must satisfy Maekawa and Kawasaki at every interior vertex.

---

## 1. Miura-Ori

### History
Developed by astrophysicist **Koryo Miura** in the 1970s for deployable solar panel arrays. Used on the Japanese Space Flyer Unit (SFU) satellite in 1995.

### Geometry
- **Unit cell**: A parallelogram with one pair of sides parallel to the sheet edge and one pair at angle α
- **Grid**: Rows of alternating parallelograms, adjacent rows offset by half a cell
- **Crease types**: All creases are either mountain or valley; every interior vertex is degree-4
- **Sector angle**: α — the acute angle between crease directions (typically 30°–75°)

### Properties
- **Single DOF**: The entire sheet has exactly 1 degree of freedom. One fold angle determines all others.
- **Negative Poisson ratio**: When compressed in one direction, it expands in the perpendicular direction (auxetic behaviour).
- **Flat-packable**: Folds completely flat (all vertices satisfy Kawasaki with sector angles summing to π).
- **Rigid-foldable**: Does not require paper bending between creases.
- **Self-similar**: Scaled copies of the unit tile tile the plane identically.

### Kinematics
The fold angle θ drives the whole system:
```
width(θ)  = a · N · cos(θ) · cos(α)
height(θ) = b · M · √(1 − sin²(α) · sin²(θ))
```
where N × M is the grid size, a × b is the unit cell size.

### Applications
- Deployable solar panels (space engineering)
- Foldable maps (Miura map fold)
- Architectural facades (kinetic building skins)
- Medical stents and implants
- Sandwich panels for structural applications

---

## 2. Ron Resch Pattern

### History
Invented by sculptor and computer scientist **Ron Resch** in the 1960s–70s. Resch was a pioneer of computational design and patented several folding structures.

### Geometry
- **Unit cell**: An equilateral triangle with three fold lines radiating inward from midpoints of edges to a central point
- **Extended pattern**: Triangular grid; each hexagonal super-cell consists of 6 triangular units
- **Fold lines**: Each triangle has 3 valley folds from edge midpoints to centre; connecting creases between triangles are mountain folds

### Properties
- **Rigid-foldable**: Each unit folds as a rigid mechanism
- **Double-curved capability**: Unlike Miura-ori (which produces a cylinder-like surface), Resch patterns can approximate doubly-curved (synclastic) surfaces
- **Load-bearing**: The 3D folded form is mechanically stiff in compression — useful for structural panels
- **Concave folding**: The folded Resch pattern has an inward-folded central dimple per unit cell

### Degrees of Freedom
The Resch pattern has a finite DOF that depends on boundary conditions. Interior regions are over-constrained for rigid folding, but practical approximations work well.

---

## 3. Waterbomb Tessellation

### History
Named after the traditional origami **waterbomb** base (a degree-4 vertex with 2 mountain + 2 valley folds in a cross pattern). The tessellation generalises this base to fill the plane.

### Geometry
- **Unit cell**: A square with diagonals (creates an X-pattern crease from corners)
- **Extended pattern**: Alternating "popped" and "flat" vertices in a grid
- **Crease assignment**: Alternating mountain/valley in a checkerboard-like arrangement

### Properties
- **Rigid-foldable**: Yes, with 1 DOF (like Miura-ori)
- **Negative Poisson ratio**: Like Miura-ori, it exhibits auxetic behaviour
- **Twist-foldable**: Can fold helically by introducing a twist angle
- **Axisymmetric variant**: Wrapping the pattern around a cylinder produces a deployable tube

### Hexagonal Waterbomb
A variant using hexagonal unit cells (with 6-fold symmetry):
- More isotropic mechanical properties
- Biologically analogous to certain plant cell arrays
- Can approximate spherical surfaces

---

## 4. Yoshimura Pattern

### History
Named after **Yoshimaru Yoshimura**, who studied the buckling patterns of thin cylindrical shells under axial compression (1955). The diamond buckling pattern is mathematically equivalent to an origami tessellation.

### Geometry
- **Unit cell**: A diamond (rhombus) with the long axis parallel to the cylinder axis
- **Extended pattern**: Alternating rows of diamonds, creating a "pineapple" or "diamond weave" pattern
- **Fold lines**: The long diagonals of each diamond are mountain folds; the short diagonals are valley folds (or vice versa)

### Properties
- **Cylindrical**: Naturally forms a tube, not a flat sheet
- **Compressible axially**: The cylinder can be compressed along its axis by folding the diamonds
- **Rigid-foldable**: Yes, though with more DOF than Miura-ori for finite segments
- **Load-bearing**: Appears naturally in thin-walled pressure vessel buckling

### Applications
- Compressed thin-walled tubes (crash energy absorption)
- Deployable cylindrical structures
- Drinking straws, corrugated pipes
- Biological: thin-walled plant stems under compressive load

---

## 5. Triangulated Cylinder (Kresling)

Not strictly a single-inventor design, but related to work by **Biruta Kresling** on natural helix-buckling patterns.

- Unit cell: right triangles arranged helically
- Creates a **twist-fold** mechanism: opening/closing the cylinder involves rotation
- Used for deployable robotic joints and actuators

---

## 6. Square Twist

A minimal tessellation using **twist folds** — rotational mechanisms.

- **Unit cell**: A central square that rotates as the pattern folds
- **DOF**: 1 per unit cell
- **Not rigid-foldable** in general (requires some paper bending)
- Aesthetically beautiful: the rotating squares create optical illusions of depth

---

## 7. Comparison Table

| Pattern | Unit cell | Rigid-foldable | DOF | Poisson ratio | Applications |
|---------|-----------|---------------|-----|---------------|--------------|
| Miura-ori | Parallelogram | Yes | 1 (global) | Negative (auxetic) | Solar panels, architecture |
| Resch | Triangle | Yes (approx.) | Limited | Varies | Structural panels |
| Waterbomb | Square (X) | Yes | 1 (global) | Negative | Tubes, wearables |
| Yoshimura | Diamond | Yes | Multiple | Compressive | Cylinders, crash absorption |
| Kresling | Right triangle | Yes | 1 (twist) | Coupled rotation | Robotic joints |
| Square Twist | Square | No | 1/cell | Complex | Art, architecture |

---

## 8. References

- **Miura, K.** (1985). "Method of Packaging and Deployment of Large Membranes in Space." *Proceedings of 31st IAF Congress*, Tokyo.
- **Resch, R.** (1968). *Self-Supporting Structural Unit Having a Three-Dimensional Surface.* US Patent 3,407,558.
- **Yoshimura, Y.** (1955). "On the Mechanism of Buckling of a Circular Cylindrical Shell Under Axial Compression." *Technical Memorandum 1390*, NACA.
- **Schenk, M. & Guest, S.D.** (2013). "Geometry of Miura-folded metamaterials." *PNAS*, 110(9).
- **Demaine, E., Demaine, M. & Koschitz, D.** (2010). "Reconstructing David Huffman's Legacy in Curved-Crease Folding." *Origami 5: Fifth International Meeting of Origami Science, Mathematics, and Education*.
- **Tachi, T.** (2009). "Simulation of Rigid Origami." *Origami 4: Fourth International Meeting of Origami Science, Mathematics, and Education*.
