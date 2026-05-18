# Computational Origami
## TreeMaker, Circle Packing, NP-Hardness, and Algorithmic Design

---

## Overview

**Computational origami** is the study of origami through algorithms and mathematical proofs. It asks:
- Given a 3D target shape, can we find a crease pattern that folds to it?
- How hard is it to verify that a crease pattern is flat-foldable?
- Can computers design origami better than humans?

The field bridges classical origami, computational geometry, and combinatorics.

---

## 1. TreeMaker: From Stick Figure to Crease Pattern

**TreeMaker** is software (and an algorithm) created by origami artist and physicist **Robert J. Lang**. It solves the inverse problem of origami design.

### The Problem

You want to fold a model with specific "flaps" — a crane's wings, a spider's legs, a dinosaur's horns. These flaps correspond to a **tree**: a graph with no cycles where:
- Each **leaf node** represents one flap
- **Edge lengths** encode the length of each flap (in units of paper)
- **Internal nodes** are branching points in the model

### The Algorithm

1. **Encode the model as a metric tree**: Assign lengths to all edges such that the total path length between any two leaves equals the sum of paper needed for those flaps.

2. **Map tree to paper**: Each leaf node maps to a **circle** on the flat paper. The radius of circle *i* equals half the path-length in the tree from leaf *i* to its nearest branch point.

3. **Pack the circles**: All circles must:
   - Fit within the unit square of paper
   - Not overlap: `|cᵢ − cⱼ| ≥ rᵢ + rⱼ` for all pairs *i, j*
   - The **active path condition**: `|cᵢ − cⱼ| = rᵢ + rⱼ` if the path from *i* to *j* in the tree passes through no other node (the path is "active")

4. **Compute the crease pattern**: The crease pattern emerges from the circle packing:
   - The **perpendicular bisector** of each active path becomes a crease
   - **River lines** (boundaries between adjacent circles) define fold sequences
   - The resulting CP is mathematically guaranteed to fold to the target tree form

### Circle Packing as Optimisation

Finding the optimal circle packing is a **nonlinear optimisation problem**. TreeMaker uses a gradient-descent approach on the constraint:

```
minimise: −(total area of circles)
subject to: all gap conditions ≥ 0
            all circles within unit square
```

### Limitations

- TreeMaker designs the **topology** and **crease locations** but not the exact fold sequence or mountain/valley assignment for complex 3D forms.
- The method works perfectly for **uniaxial** bases (models designed along a single axis). Multi-axial designs require extensions.
- Many practical origami designs require manual refinement after TreeMaker output.

---

## 2. Disk Packing on the Unit Square

The geometric core of TreeMaker. Given a set of circles with specified radii and mutual distance constraints, find a valid placement.

### Key Results

- **Existence**: A valid packing always exists if the radii are small enough relative to the paper size.
- **Optimality**: The optimal packing (maximising circle sizes) is generally NP-hard to compute exactly, but effective heuristics work well in practice.
- **Active paths**: In the optimal packing, the majority of active paths are "activated" — the circles are touching. This creates the most efficient use of paper.

### Algorithmic Approaches

1. **Sequential packing**: Place circles one at a time in greedy order (fast, sub-optimal)
2. **Gradient descent**: Simultaneously optimise all positions (Lang's TreeMaker approach)
3. **Simulated annealing**: Probabilistic search, good for escaping local minima
4. **Force-directed layout**: Treat circles as repulsive particles and relax to equilibrium

---

## 3. NP-Hardness in Origami

Several fundamental origami problems are computationally intractable:

### 3.1 Flat-Foldability is NP-Hard

**Bern and Hayes (1996)** proved that deciding if a given crease pattern with a fixed mountain-valley assignment is flat-foldable is **NP-hard**.

The proof uses a reduction from **graph 3-colourability** — a classic NP-complete problem. The key difficulty is the **layer ordering problem**: determining a consistent stacking order for all panels.

### 3.2 Mountain-Valley Assignment is NP-Hard

Even given a crease pattern without assignment, finding a valid mountain-valley assignment that makes the pattern flat-foldable is **NP-hard** (Arkin et al., 2004).

### 3.3 Optimal Folding Sequence

Given a flat-foldable CP, finding the **minimum number of fold steps** to achieve the folded form is NP-hard.

### 3.4 Exceptions

Not everything is hard:
- **Single-vertex flat-foldability**: Checking Kawasaki and Maekawa at a single vertex is O(n) where n is the number of creases.
- **Strip folding**: For patterns that fold a 1D strip of paper, flat-foldability can be checked in polynomial time.
- **Uniaxial crease patterns** (from TreeMaker): Flat-foldability verification is efficient for these structured patterns.

---

## 4. The Fold-and-Cut Problem

**Can any straight-line figure be cut from a single sheet of paper using one straight cut?**

**Yes.** Demaine, Demaine, and Lubiw (1999) proved that any straight-line graph (finite set of line segments in the plane) can be achieved by:
1. Folding the paper flat along appropriate creases
2. Making one straight cut

This means you can cut out a star, a swan silhouette, or any connected polygon with a single cut — just fold the right crease pattern first.

### Proof Method: Straight Skeleton

The crease pattern is constructed using the **straight skeleton** of the target shape — the path traced by the inward-moving wavefront as you shrink the shape boundary. The skeleton determines the fold lines.

---

## 5. 3D Origami from Flat: The Universality Result

**Demaine and Tachi (2017)** proved that any 3D polyhedron can be produced by folding a flat sheet of paper (possibly with cuts in kirigami). For pure origami (no cuts), approximate results exist.

### Key Tools
- **Gluing trees**: A polyhedron is described by gluing edges of a polygon
- **Spanning trees**: The unfolding of the polyhedron's surface is a valid crease pattern
- **Tucking**: Excess paper is hidden in tucks (a classical origami technique generalised algorithmically)

---

## 6. Computational Tools and Software

| Tool | Creator | Purpose |
|------|---------|---------|
| **TreeMaker** | Robert J. Lang | Uniaxial origami design from stick-figure input |
| **Origamizer** | Tomohiro Tachi | 3D polyhedral approximation from flat sheet |
| **Freeform Origami** | Tomohiro Tachi | Interactive curved-fold surface design |
| **ORIPA** | Jun Mitani | Crease pattern editing and flat-foldability checking |
| **Rigid Origami Simulator** | Tomohiro Tachi | Kinematic simulation of rigid-foldable patterns |
| **ReferenceFinder** | Robert J. Lang | Find fold sequences to achieve target points on paper |

---

## 7. Ongoing Research Areas

- **Inverse design**: Given a 3D form, compute the crease pattern
- **Curved creases**: Computational design of Huffman-style curved folds
- **Thick origami**: Engineering foldable structures with non-zero material thickness
- **Self-folding sheets**: Programming flat sheets to fold autonomously (heat-activated, magnetically, etc.)
- **DNA origami**: Folding DNA strands into 2D and 3D nanoscale structures (a different "paper")
- **Robotic origami**: Using origami principles for deployable robotic mechanisms and soft robots

---

## 8. References

- **Lang, R.J.** (1996). "A Computational Algorithm for Origami Design." *Proceedings of the 12th Annual ACM Symposium on Computational Geometry*.
- **Bern, M. & Hayes, B.** (1996). "The Complexity of Flat Origami." *Proceedings of SODA 1996*.
- **Demaine, E.D., Demaine, M.L. & Lubiw, A.** (1999). "Folding and Cutting Paper." *Lecture Notes in Computer Science*, 1763.
- **Demaine, E.D. & O'Rourke, J.** (2007). *Geometric Folding Algorithms*. Cambridge University Press.
- **Tachi, T.** (2010). "Origamizing Polyhedral Surfaces." *IEEE Transactions on Visualization and Computer Graphics*, 16(2).
- **Demaine, E.D. & Tachi, T.** (2017). "Origami Universality." *Proceedings of the 49th Annual ACM STOC*.
- **Arkin, E.M. et al.** (2004). "When Can You Fold a Map?" *Computational Geometry: Theory and Applications*.
