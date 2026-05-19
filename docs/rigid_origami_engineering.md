# Rigid Origami Engineering
## From Mathematical Mechanism to Physical Structure

---

## Overview

**Rigid origami** treats each panel as a perfectly rigid flat surface and each crease as a frictionless rotational hinge. No bending occurs between creases — only at the creases. The fold is a **mechanical linkage**.

This model has two faces:
1. **A restriction**: Most flat-foldable crease patterns are NOT rigid-foldable. The rigid model eliminates most origami models.
2. **An engineering superpower**: Rigid-foldable patterns can be manufactured from metal, carbon fibre, plastic — any material that can be hinged. They don't rely on paper's ability to bend between creases.

The result is a family of mechanisms with extraordinary engineering properties: large compaction ratios, single-DOF deployment, geometric precision, and scalability from nanometers to meters.

---

## 1. Rigid Origami as Mechanism Theory

### 1.1 The Linkage Model

A rigid-foldable crease pattern is a **spatial linkage**:
- **Links**: The flat panels (rigid bodies)
- **Joints**: The crease lines (revolute joints)
- **Constraints**: Each crease hinge constrains 5 DOF (all except rotation about the hinge axis)

For a pattern with P panels, C creases, and boundary panels:
```
DOF = 6P − 5C − 6   (Grübler's formula for spatial linkages)
```

For a pattern to be non-trivially foldable: DOF ≥ 1.

### 1.2 Overconstrained Mechanisms

Most rigid origami patterns appear **overconstrained** by Grübler's formula (DOF < 1), yet fold. This is because they satisfy special geometric conditions that introduce **hidden DOF** — the constraints are not independent.

The Miura-ori, waterbomb, and Resch patterns all achieve this via global symmetry: the geometric constraints cancel each other, leaving exactly 1 DOF.

### 1.3 The Compatibility Matrix

For rigorous analysis, the rigid-foldable DOF is computed via the **compatibility matrix** C of the linkage:
```
C · θ̇ = 0
```
where θ̇ is the vector of hinge angular velocities. The mechanism's DOF = dim(null space of C).

A pattern is rigid-foldable iff null(C) is non-trivial (contains non-zero vectors).

---

## 2. Engineering Metrics

### 2.1 Compaction Ratio

The ratio of deployed area to stowed volume:
```
η = A_deployed / V_stowed
```

For Miura-ori with N × M cells, panel dimensions a × b, and sector angle α:
```
η_Miura = (2N·a · 2M·b·sin(α)) / (2N·a·t · 2M·b·sin(α) · cos(α) · N·M)
```

Simplified for large N, M:
```
η_Miura ≈ 1 / (t · N · M · cos(α))
```

For typical parameters (N=M=10, t=1mm, α=45°): η ≈ **1400 m²/m³** — extraordinarily efficient.

### 2.2 Actuation Force

The force required to fold or unfold a rigid origami structure:
```
F = ∂E_hinge / ∂δ
```
where E_hinge is the total elastic energy stored in the crease hinges and δ is the deployment coordinate.

For spring-loaded hinges: F is approximately constant during deployment (linear spring model) — one of Miura-ori's most practically useful properties for deployment mechanisms.

### 2.3 Load-bearing Capacity

Folded plate structures resist loads through **geometric stiffness**: the angled panels carry forces as structural members (compression/tension), not in bending.

For a simple zigzag (alternating mountain-valley, panel length L, thickness t, fold angle φ):
```
EI_eff = E · t³ · L · sin²(φ) / 12
```
The effective bending stiffness scales as sin²(φ) — zero when flat, maximum at φ = 90°.

This is the engineering principle behind **folded plate roofs** and **origami-inspired structural panels**.

---

## 3. Key Rigid-Foldable Patterns

### 3.1 Miura-Ori

**Parameters**: sector angle α, panel aspect ratio a/b, grid size N×M

**DOF**: 1 (global)

**Kinematic equations**:

```
Width(θ)  = 2N·a·cos(θ)·cos(α)
Height(θ) = 2M·b·√(1 − sin²(α)·sin²(θ))
Thickness(θ) = 2·b·sin(α)·sin(θ)
```

where θ ∈ [0°, 90°] is the deployment parameter (0 = folded, 90° = fully flat).

**Negative Poisson ratio**: ν = −(∂ε_y/∂ε_x) < 0

```
ν = −(∂H/H) / (∂W/W) = −cos²(α) · (1 − sin²(α)·sin²(θ)) / sin²(α)·sin²(θ)
```

This is always negative: stretch in x → contraction in y; squeeze in x → expansion in y. Auxetic behaviour.

### 3.2 Waterbomb Tessellation

**DOF**: 1 (global)

**Key constraint** (degree-4 vertex, α = 90°):
```
tan(θ₁/2) · tan(θ₂/2) = 1
```
This is the waterbomb constraint: the two independent dihedral angles are "complementary" in the tan-half-angle sense. Setting one determines the other.

The waterbomb tessellation also has a negative Poisson ratio and is used in foldable tubes and cylinders.

### 3.3 Kresling Tower

**DOF**: 1 (coupling of height and rotation)

**Kinematic coupling**:
```
cos(β) = 1 − 2·sin²(π/N)·sin²(θ/2)
h = L·sin(β)·cos(π/N)
```
where N = number of panels, θ = twist angle, h = height, L = panel diagonal length.

This means the Kresling tower **cannot be deployed without rotating**. It is a screw-type mechanism. The coupling provides built-in locking at the fully deployed state.

**Applications**: Robotic joints (rotational and translational DOF coupled), deployable booms with torsional stiffness.

### 3.4 Ron Resch Pattern

The Resch pattern is approximately rigid-foldable. In finite-element simulation, small amounts of in-plane deformation are required at the vertices, but macroscopic deployment proceeds smoothly.

**Unique property**: Unlike Miura-ori (cylinder-like curvature) or waterbomb (spherical approximation), the Resch pattern can form **doubly curved surfaces** — approximating saddle shapes and domes. This makes it valuable for architectural applications.

---

## 4. Engineering Applications

### 4.1 Space Deployable Structures

**Solar arrays**: The canonical application. NASA and JAXA have flown Miura-ori-inspired folded arrays.

- **IKAROS solar sail** (JAXA, 2010): 200 m² Mylar sail, folded to 14 m² package. Miura-ori fold. Deployed by centrifugal force (spinning spacecraft). First successful solar sail demonstration.
- **Eyeglass telescope** (JPL, Lawrence Livermore): 25-metre diameter optical lens, folded to 4-metre launch fairing. Uses a Miura-variant crease pattern with concentric rings.
- **Starshade** (NASA, proposed): 26-metre petal-shaped shade for exoplanet imaging. Folds to cylinder, deploys to flower shape with <1mm precision across 26m.

**Key engineering challenge**: Manufacturability with zero-thickness assumption versus real material thickness. Solutions include hinge-gap compensation and tapered panel edges (see `thick_origami.glsl`).

### 4.2 Medical Devices

**Cardiovascular stents**: Kresling and Yoshimura tube geometries for expandable stents.

- Delivered in catheter at collapsed diameter (4-6mm)
- Deployed by balloon inflation or shape-memory alloy (Nitinol): expands to 2-3× diameter
- The fold pattern provides a controlled expansion with no stress concentrations
- FDA-approved origami-inspired stent designs exist (Xience, Absorb BVS variants)

**Surgical tools**: Rigid origami mechanisms for instruments that must enter through small incisions and expand at the surgical site. Joints with controlled DOF replace complex cable-driven mechanisms.

**Drug delivery**: Nano-scale origami structures (DNA origami) as drug carriers — fold to protect payload, unfold to release.

### 4.3 Architecture

**Adaptive facades**: Building skins with operable panels that fold to modulate light, ventilation, and thermal gain.

Notable examples:
- **Institut du Monde Arabe** (Paris, Jean Nouvel, 1987): 240 square mashrabiya apertures that open/close. Not true rigid origami, but origami-principle inspired.
- **One Ocean Pavilion** (South Korea, SOMA, 2012): ETFE fins that flex in response to wind. Compliant mechanism, not rigid.
- **Iris Dome** (research concept, Tachi + Hoberman): Rigid origami dome that opens like a camera iris. Demonstrated at 1:10 scale.

**Deployable shelters**: Rigid-foldable modules for emergency housing, field hospitals, and disaster response.

- Flat-packed: entire 30m² shelter fits in standard shipping container
- One-person deployment in <30 minutes
- Structural without internal supports (folded plate provides stiffness)

**Foldable furniture**: Chairs, tables, and partition walls that fold flat for storage. IKEA-style flat-pack taken to mechanical extreme.

### 4.4 Robotics

**Soft robots**: Compliant origami mechanisms that deform in controlled, programmable ways.

- **Pneumatic origami actuators**: Waterbomb bellows that extend/contract via air pressure
- **Magnetic origami** (MIT CSAIL): Flat-printed magnetic patterns that fold on cue when exposed to external field
- **Self-folding robots** (Harvard/MIT): Printed circuits with thermally activated hinges that fold into 3D bots when heated

**Robotic grippers**: Origami mechanisms for grasping irregular objects:
- Kresling tube: grips by torsion-coupled compression
- Waterbomb finger: one DOF per finger, scalable
- Deployed from flat: can be 3D-printed flat and activated in situ

**Locomotion**: Jumping robots use folded energy-storing mechanisms (accordion springs from Yoshimura patterns). Crawling robots use Kresling tubes as directional friction mechanisms.

### 4.5 Aerospace: Folded Aerodynamic Surfaces

- **Morphing wings** (Airbus research): Wing surfaces with origami-inspired skin panels that change curvature in flight for optimal aerodynamics
- **Origami airbrake**: Deployable deceleration panels for spacecraft re-entry
- **Parachute replacement**: Rigid origami decelerators — arrays of Miura panels that create aerodynamic drag more efficiently than fabric chutes

---

## 5. Manufacturing Considerations

### 5.1 Material Selection

| Material | Thick origami method | Best application |
|----------|---------------------|-----------------|
| Aluminium sheet (0.5-2mm) | Panel offset or hinge gap | Space structures, architectural panels |
| Carbon fibre composite | Membrane hinge | High-stiffness aerospace |
| Spring steel | Natural elasticity at crease | Self-deploying mechanisms |
| Mylar (polyester film) | Very thin: near-ideal | Solar sails, thin-film optics |
| Nitinol (shape memory) | Crease "remembers" fold angle | Medical devices, self-folding |
| Cardboard / honeycomb | Kirigami slots | Packaging, furniture, lightweight panels |

### 5.2 Hinge Design

The crease hinge is the engineering critical path in rigid origami:

**Living hinge**: Thin zone of same material, locally thinned. Works well for polymers and thin metal. Self-contained; no added parts.

**Pin hinge**: Traditional mechanical hinge added at each crease. Adds weight and complexity but allows high-precision, high-load applications.

**Compliant joint**: A short flexible beam connecting adjacent panels. Spring constant tuned by geometry. Used in precision instruments.

**Magnetic hinge**: Panels with embedded magnets; alignment force provides a restoring torque. Self-locking at target angle.

### 5.3 Tolerances and Error Accumulation

A rigid origami array with N cells accumulates geometric errors:
```
σ_total ≈ √N · σ_cell
```
(assuming random, independent manufacturing errors per cell)

For N = 100 cells with σ_cell = 0.1mm: σ_total ≈ 1mm — acceptable for most applications.

For precision optics (Starshade, Eyeglass), this requires:
- Sub-micron precision per cell
- Active control of deployment shape
- Compensation mechanisms

---

## 6. Simulation and Design Tools

| Tool | Method | Use case |
|------|--------|---------|
| **Rigid Origami Simulator** (Tachi) | Geometric constraint propagation | Kinematic feasibility, deployment path |
| **ABAQUS + origami plugin** | FEM + contact | Stress analysis, thick panels |
| **Origami Simulator** (Amanda Ghassaei) | WebGL real-time | Rapid visualisation, education |
| **OpenCM** (research) | Constraint manifold traversal | Complex multi-DOF patterns |
| **Grasshopper + Kangaroo** | Particle spring simulation | Architectural concept design |

---

## 7. Open Research Challenges

- **Optimal crease patterns for target 3D forms**: Given a 3D shape, find the most efficient rigid-foldable crease pattern that approximates it.
- **Stiffness-to-weight optimisation**: For structural panels, optimise fold angle and cell size for maximum stiffness per unit mass.
- **Dynamic deployment**: Rigid origami analysis is mostly quasi-static. Deployment dynamics (inertia, damping, impact at full extension) are poorly understood.
- **Fault tolerance**: What happens when one hinge jams? Can the structure still deploy? How to design for partial-failure modes?
- **Multi-material origami**: Combining rigid and compliant regions for programmable mechanical response.

---

## 8. References

- **Schenk, M. & Guest, S.D.** (2013). "Geometry of Miura-folded metamaterials." *PNAS*, 110(9).
- **Tachi, T.** (2009). "Generalization of Rigid Foldable Quadrilateral Mesh Origami." *Symposium on the International Association of Shell and Spatial Structures*.
- **Zirbel, S.A. et al.** (2013). "Accommodating Thickness in Origami-Based Deployable Arrays." *ASME Journal of Mechanical Design*, 135(11).
- **Natori, M.C. et al.** (2013). "Conceptual Model Study Using Origami for Membrane Space Structures." *ASME IDETC*.
- **Rus, D. & Tolley, M.T.** (2018). "Design, fabrication and control of origami robots." *Nature Reviews Materials*, 3(6).
- **Morgan, J. et al.** (2016). "An origami-inspired approach to worm robots." *IEEE Robotics and Automation Letters*, 1(2).
- **Demaine, E.D. & O'Rourke, J.** (2007). *Geometric Folding Algorithms*. Cambridge University Press.
- **Gattas, J.M. et al.** (2013). "Miura-Base Rigid Origami: Parameterizations of First-Level Derivative and Piecewise Geometries." *ASME Journal of Mechanical Design*, 135(11).
