# Origami Architecture
## Buildings That Fold: Deployable Structures, Kinetic Facades, and Parametric Skins

---

> *"Architecture is frozen music. Origami architecture is music that plays — that opens and closes, deploys and packs, breathes with the weather."*

---

## Overview

The relationship between origami and architecture is not metaphorical — it is structural, kinematic, and mathematical. Origami principles solve real architectural problems:

- How to make a large surface **deployable** from a small package
- How to make a building skin **adaptive** to light and climate
- How to derive **structural stiffness** from folded geometry alone, without added material
- How to design **parametric surfaces** that respect the constraints of real materials

This document traces the full arc from abstract crease patterns to built structures.

---

## 1. Folded Plate Structures

### 1.1 The Structural Principle

A flat sheet has zero bending stiffness in its plane — it buckles trivially. Fold it into a zigzag, and the bending stiffness scales as:

```
EI_eff = E · t³ · sin²(φ) / 12
```

where E is the material's Young's modulus, t is the thickness, and φ is the fold angle. At φ = 90° (perpendicular panels), the stiffness is maximised. At φ = 0° (flat), it vanishes.

This is the geometric miracle of folded plate structures: **fold = stiffness, for free**.

### 1.2 Historical Examples

**Shell houses (1950s–70s)**: Thin concrete shells achieve span-to-thickness ratios of 200:1 through curvature. Folded plates use the same principle without double curvature.

**Felix Candela** (Mexico, 1950s): Hyperbolic paraboloid thin shells. Not strict origami, but uses developable-surface geometry.

**Pier Luigi Nervi** (Italy): Corrugated concrete floors. The corrugation is a folded-plate principle — folding provides depth, depth provides stiffness, stiffness spans long distances.

### 1.3 Contemporary Folded Plate Architecture

**The Beijing National Aquatics Centre** (PTW Architects, 2008): Faceted facade of ETFE cushions in a Weaire-Phelan foam geometry. Not origami per se, but geometrically equivalent to a polyhedral crease pattern.

**Yokohama International Passenger Terminal** (FOA, 2002): The ground plane folds continuously into floors, walls, and roof. Single-surface architecture — the crease is architecture.

**ICD/ITKE Research Pavilions** (Stuttgart, 2010–present): Carbon fibre composite shells derived from biological folding principles. The crease pattern is computed, not hand-designed.

---

## 2. Kinetic Facades

### 2.1 What Is a Kinetic Facade?

A **kinetic facade** is a building skin that moves: panels open and close in response to sun position, temperature, wind, or user control. When the movement is a rigid fold — each panel rotating about a fixed hinge line — the facade is an application of rigid origami.

Design requirements:
- **Single-DOF per unit**: Each module should have one drive actuator, not per-panel control
- **Stow/deploy precision**: Panels must align correctly in both open and closed states
- **Structural integrity at all positions**: The fold is not just aesthetic; it provides load resistance
- **Weatherproofing**: Seals at hinges must accommodate angular range of motion

### 2.2 The Institut du Monde Arabe

**Jean Nouvel, 1987 — Paris, France**

240 square **mashrabiya** apertures on the south facade, each composed of mechanical irises that open and close in response to light intensity. Each aperture has a photovoltaic sensor and a central drive mechanism.

The geometry is explicitly derived from traditional Islamic geometric patterns — specifically 8-fold star designs — and implemented as a mechanical kinetic system.

*Note*: This is not strictly rigid origami (it uses prismatic sliding, not only rotation), but it is the most architecturally significant realisation of the "adaptive facade" concept.

### 2.3 Al Bahar Towers

**Aedas Architects, 2012 — Abu Dhabi, UAE**

The most technically refined kinetic facade built to date:
- 2,093 individual umbrella-like panels, each 5.5m diameter
- Each panel tracks the sun: opens on shaded faces, closes on direct-sun faces
- Reduces solar heat gain by 50% compared to fixed facade
- Motor drive via BMS (Building Management System)

The panel geometry is derived from a traditional mashrabiya pattern (hexagonal lattice). Each panel is a soft membrane stretched over a rigid frame — **compliant origami** (not pure rigid).

### 2.4 One Ocean Pavilion

**SOMA Architects, 2012 — Yeosu, South Korea**

16 ETFE "blade" fins on the facade, each 16m tall and 2m wide. The fins flex in response to wind and actuator control, creating a breathing facade that changes the building's appearance continuously.

The fins are **compliant mechanisms** — they bend elastically, not rigidly. This is origami in spirit (one-DOF mechanism, geometric stiffness) if not in mathematics.

### 2.5 Design Tool: Rigid Origami Simulator

For genuinely rigid kinetic facades, Tachi's **Rigid Origami Simulator** (ROS) is the industry-adjacent design tool:
1. Input the panel geometry and crease pattern
2. ROS verifies rigid-foldability and computes the 1-DOF deployment path
3. Export to structural analysis software (Rhinoceros + Karamba, ANSYS)

---

## 3. Deployable Architecture

### 3.1 The Compaction Problem

A building must be:
- Large when deployed (30–100 m² shelter, 20m span)
- Small when transported (fits in a shipping container: 12m × 2.4m × 2.6m)

This is the origami compaction problem at architectural scale.

### 3.2 Deployable Roof Systems

**Retractable stadium roofs**: The Veltins-Arena (Gelsenkirchen), Sapporo Dome, and others use retractable roofs on trolleys. Not origami — sliding, not folding.

**True deployable origami roofs** remain mostly research/prototype:

**Hoberman Sphere** (Chuck Hoberman, 1990): Spherical linkage that collapses like a folded origami sphere. Used at Olympic ceremonies. The mechanism uses scissors linkages, not creases, but the mathematics is equivalent to origami rigid folding.

**Flectofin** (ICD Stuttgart, 2011): Plant-inspired deployable fin. A curved-crease elastic mechanism — the fin opens by a global elastic deformation, not a hinged mechanism. Derived from Strelitzia flower (bird-of-paradise), which uses a curved-crease opening mechanism.

### 3.3 Emergency Shelter and Rapid Deployment

**Requirements**: Flat-pack for transport, rapid deployment (one person, <1 hour), structural under weather loads, reusable.

**Origami solutions**:

*Wearable solar tent* (IKEA Foundation, design research): Miura-ori-inspired flat-pack shelter. Stows at 1/8 volume. Deployed by one person in 20 minutes. R&D stage.

*UNHCR emergency shelter kit* (current): Not origami-based. Uses hollow aluminium poles and fabric. Origami replacement would reduce kit weight by 40% and deployment time by 60% (projected).

*Cardboard Cathedrals* (Shigeru Ban, 2013 — Christchurch, NZ): Post-earthquake temporary cathedral using cardboard tube columns and origami-folded paper roof. 700 capacity. Structurally permanent (still standing). Demonstrates origami at inhabited scale.

### 3.4 Space Architecture: Inflatable + Origami

**Bigelow Aerospace** BEAM module (ISS, 2016): Inflatable habitat module. Launched in compressed state, deployed by pressurisation. Not strict origami, but uses fold-and-expand principles.

**Lunar/Mars habitat concept** (NASA Ames, research): Rigid origami pressure vessel. Stows as flat pack in cargo bay, deploys to 30m diameter habitat. Combines Miura-ori flat-folding with pressure inflation for final deployment. Analysis stage.

---

## 4. Parametric Surface Design

### 4.1 Developable Surfaces in Architecture

A **developable surface** (K=0) can be built from flat sheet material (glass, metal panel, plywood) without double-curve forming — drastically reducing manufacturing cost.

Most architectural parametric surfaces are NOT developable — they have K≠0. When a designer specifies a doubly-curved facade, the material must be either:
- Cold-bent (stressed into shape — expensive, limited curvature)
- Hot-formed (heated and shaped — very expensive)
- Discretised into flat panels with visible faceting

Origami-based design naturally produces developable surfaces. Designing with this constraint produces facades that are cheaper to build AND mathematically elegant.

### 4.2 Zaha Hadid Architects: Folded Continuity

Hadid's formal language — often described as "parametric" — is deeply informed by folded surface geometry:

**MAXXI National Museum of 21st Century Arts** (Rome, 2010): Interior stairways and mezzanines are continuous surfaces that fold to change from floor to wall to ceiling. The fold is not structural — it is spatial and phenomenological. "You cannot see where the floor ends and the wall begins."

**Heydar Aliyev Centre** (Baku, 2012): Single continuous white skin, folding at large radius to create building volume. The fold language is explicit: the building is a sheet that has been bent. Parametric design tools (CATIA) ensured every panel was developable.

**Galaxy SOHO** (Beijing, 2012): Court-yard complex with undulating roofscapes. The roof surfaces are designed as doubly-curved shells — not developable, but the visual language is of flowing folds.

### 4.3 Kazuyo Sejima / SANAA: Precision Flatness

Where Hadid folds, SANAA (Sejima and Nishizawa) celebrate the flat. But their flat is the flat **after** understanding what folding means.

**Rolex Learning Centre** (Lausanne, 2010): A single-storey flat plate that undulates — rises and falls with gentle hills and valleys. The structural floor slab is a continuous thin concrete shell; the folds are gentle enough to avoid cracking, sharp enough to define spatial hierarchy.

### 4.4 Shigeru Ban: Paper Architecture

Shigeru Ban uses paper tubes as structural columns and has designed paper-based origami-structure roofs:

**Pompidou-Metz** (2010): Timber lattice roof derived from hexagonal weave pattern (similar to a triangulated origami tessellation). Not deployable, but the geometry is explicitly origami-derived.

**Paper Church** (1995, Kobe post-earthquake): 58 paper tube columns in an elliptical plan. Cardboard box foundation. Proved that folded paper could be structural architecture.

---

## 5. Origami Principles in Structural Engineering

### 5.1 Folded Plate as Structural Principle

The folded plate is the architect's version of rigid origami:
- **Shell depth** comes from fold geometry, not material thickness
- **Load path** follows fold angles — panels in compression, hinges in bending
- **Lateral stability** from triangulated (rigid) fold patterns

Engineering text: "A flat concrete slab needs 300mm of depth to span 10m. A folded slab with 45° fold angle needs only 80mm of material at 1.5m fold depth."

### 5.2 Auxetic Origami in Architecture

Miura-ori's **negative Poisson ratio** (auxetic behaviour) has architectural implications:

- **Seismic isolation**: Auxetic panels expand perpendicular to applied load — useful for seismic damping panels in earthquake-prone buildings
- **Adaptive thermal panels**: When thermally stressed (expanding), auxetic panels accommodate expansion without buckling
- **Textile architecture**: Auxetic fabric (origami-patterned fabric) drapes differently from conventional fabric — wider vocabulary for tensile architecture

### 5.3 The Yoshimura Column

A steel column with Yoshimura diamond creases is stiffer than a smooth cylinder of the same material weight and **absorbs more energy before failure** (progressive buckling, not catastrophic collapse).

This is used in **automotive crash structures**: the B-pillar in modern cars often uses origami-inspired progressive buckling geometry. The crumple zone "knows" how to buckle.

---

## 6. Computational Tools for Origami Architecture

| Tool | Application |
|------|-------------|
| **Rhinoceros + Grasshopper** | Parametric panel layout, origami surface generation |
| **Karamba3D** | Structural analysis of folded plate structures |
| **Kangaroo** | Form-finding with folded constraints, dynamic relaxation |
| **Origami Simulator** (Ghassaei) | Rapid visualisation of crease patterns in 3D |
| **Freeform Origami** (Tachi) | Curved crease surface design |
| **Rigid Origami Simulator** (Tachi) | Kinematic verification of deployable facades |
| **CATIA / Alias** | Manufacturing-grade developable surface design |

---

## 7. References

- **Tachi, T.** (2011). "Rigid-foldable Thick Origami." *Origami 5: Fifth International Meeting of Origami Science, Mathematics, and Education*.
- **Schenk, M. & Guest, S.D.** (2011). "Origami Folding: A Structural Engineering Approach." *Origami 5*.
- **Trautz, M. & Künstler, A.** (2009). "Deployable Folded Plate Structures." *Symposium of the IASS*, 57.
- **Hoberman, C.** (1993). "Unfolding Architecture." *Architectural Design*, 63(3–4).
- **Glynn, R. & Sheil, R.** (2011). *Fabricate: Making Digital Architecture*. Riverside Architectural Press. Chapter: Folded Architecture.
- **Sakamoto, T. & Ferré, A.** (eds.) (2008). *From Control to Design: Parametric/Algorithmic Architecture*. Actar.
- **Kolarevic, B.** (2003). *Architecture in the Digital Age*. Taylor & Francis.
- **Tibbits, S.** (2017). *Active Matter*. MIT Press. Chapter: Self-Assembly and Origami Structures.
