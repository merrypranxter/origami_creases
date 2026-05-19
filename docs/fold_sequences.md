# Fold Sequences and Traditional Bases
## The Grammar of Folding: From Valley and Mountain to Complex Form

---

> *"The crane does not begin with the head. It begins with a square. The sequence is the secret."*

---

## Overview

A **fold sequence** is the ordered series of individual fold operations that transform a flat sheet of paper into a finished origami model. The sequence is not unique — many valid sequences exist for any model — but finding an efficient, physically feasible sequence is a non-trivial problem.

Understanding fold sequences means understanding:
- The **vocabulary of individual folds** (valley, mountain, inside/outside reverse, squash, petal...)
- The **grammar of fold combination** (which folds must precede others)
- The **bases** — canonical intermediate forms that appear in thousands of models
- The **computational hardness** of optimal sequencing

---

## 1. The Atomic Folds

### 1.1 Valley Fold

The most elementary fold. One layer of paper is brought toward the folder. The fold line appears as a **valley** — the paper opens away from the fold line when viewed from above.

**Notation**: Dashed line (- - - - -)

**Mathematical effect**: A reflection of the folded region about the fold line. If the fold line is the line L, then every point P on the folded region maps to its mirror image P' about L.

### 1.2 Mountain Fold

Paper is folded away from the folder. The crease appears as a **ridge** — the paper opens toward the fold line when viewed from above.

**Notation**: Dash-dot line (-·-·-·-)

**Mathematical effect**: Same reflection as a valley fold, but the folded region goes behind the rest of the paper instead of in front.

The choice of mountain vs. valley for a given crease is the **mountain-valley assignment problem** — NP-hard in general (see `computational_origami.md`).

### 1.3 Inside Reverse Fold

The tip of a pointed flap is folded inward, between the layers:
1. Partially unfold the layers
2. Push the tip inside, reversing the crease direction
3. Re-flatten

Effect: A valley becomes a mountain (and vice versa) at the reverse fold location.

**Used for**: Animal heads, beaks, tails, all "reversal" transitions.

### 1.4 Outside Reverse Fold

The tip of a pointed flap is wrapped around the outside:
1. Partially unfold the layers
2. Pull the tip outward and around
3. Re-flatten

Less common than inside reverse; creates a wrapped appearance.

### 1.5 Squash Fold

A folded edge is opened by pressing flat into a diamond shape:
1. Lift one layer of the paper
2. Open the pocket
3. Press flat so the single edge becomes a symmetric double-edge

**Effect**: Converts a single-layer edge into a flat quadrilateral with a central crease.

**Used for**: Kite bases, preliminary bases, any transition requiring symmetrical opening.

### 1.6 Petal Fold

A complex fold that creates a pointed "petal" shape:
1. Valley-fold the sides of a triangle inward to the centre line
2. Lift the bottom point and fold upward
3. The paper forms a long pointed flap with two hidden layers

**Used for**: Bird base → crane wings, frog base petals.

### 1.7 Sink Fold

One portion of the model is "sunk" inward:
1. Mountain-fold an entire layer of paper inward
2. The top of the sunk region becomes an interior surface

**Open sink**: The paper layers are separated during sinking.
**Closed sink**: All layers move together.

**Used for**: "Squaring" pointed flaps, creating interior cavities.

### 1.8 Rabbit Ear Fold

Three fold lines meeting at one point simultaneously crease:
1. Bring one point toward the adjacent crease
2. The paper at the point forms a triangular flap — the "ear"

**Used for**: Creating additional points from single-layer regions; the basis of many complex model techniques.

### 1.9 Crimp

Two parallel valley folds or two parallel mountain folds close together, creating an accordion-like step:
- **Valley crimp**: Paper steps forward at the crimp
- **Mountain crimp**: Paper steps backward

**Used for**: Positioning limbs and appendages at specific angles in animal models.

---

## 2. The Bases

A **base** is a canonical intermediate form from which many finished models can be folded. Bases concentrate the paper into the right topology (right number of points in the right configuration) before the final detailing.

### 2.1 Preliminary Base (Blintz Base)

**From**: A square.
**Sequence**: 
1. Fold in half vertically; unfold.
2. Fold in half horizontally; unfold.
3. Fold in half diagonally; unfold.
4. Fold in half diagonally the other way; unfold.
5. Collapse: push the corners together so the horizontal and vertical folds become mountains, the diagonal folds become valleys.

**Result**: A small square with 4 flaps, half the size of the original square.

**Models that start here**: Waterbomb, bird base (via petal fold), jumping frog.

### 2.2 Bird Base

**From**: Preliminary base.
**Additional sequence**:
1. Petal fold on one side (front).
2. Petal fold on the other side (back).

**Result**: A diamond shape with 4 long triangular points.

**Models**: Paper crane (most famous), flapping bird, pelican.

**Mathematical note**: The bird base has 6 interior vertices. Checking Kawasaki at all 6 and Maekawa at all 6 is the "simple bird base test" mentioned in `origami_math.md`.

### 2.3 Frog Base

**From**: Preliminary base (or directly from square).
**Sequence**: Apply petal folds to all 4 sides of the preliminary base.

**Result**: A diamond with 4 very long, narrow points and 4 shorter flaps behind them.

**Models**: Frog (the base gives the 4 legs + 4 head-body flaps), lily, iris flower.

### 2.4 Waterbomb Base

**From**: A square.
**Sequence**:
1. Fold in half diagonally twice; unfold.
2. Fold in half horizontally once; unfold.
3. Fold in half vertically once; unfold.
4. Collapse: push the midpoints of the horizontal and vertical folds together, creating a triangular form.

**Result**: A triangle with 4 flaps (2 front, 2 back).

**Models**: Waterbomb (inflate by blowing into the bottom point), balloon.

**Note**: This is the "waterbomb base" — the unit vertex from which the waterbomb tessellation is named.

### 2.5 Kite Base

**From**: A square.
**Sequence**:
1. Fold in half diagonally.
2. Bring the right edge to the centre diagonal; crease.
3. Bring the left edge to the centre diagonal; crease.

**Result**: A kite shape — a quadrilateral taller than it is wide, with a central mountain ridge.

**Models**: Sandbagger, jumping frog (alternative), fish base → various fish.

### 2.6 Fish Base

**From**: Kite base.
**Additional sequence**: Squash fold the two "ear" points flat.

**Result**: A narrow elongated form with 4 small points at the sides and one main point at top.

**Models**: Fish, various simple animals.

### 2.7 Windmill Base

**From**: Preliminary base with an additional step.
**Sequence**: Apply partial squash folds at all 4 corners of the preliminary base.

**Result**: A pinwheel-like form with 4 outward-pointing flaps arranged rotationally.

**Models**: Windmill (of course), pinwheel.

---

## 3. The Paper Crane: A Fold Sequence in Full

The **tsuru** (Japanese paper crane) is the most folded origami model in history. It is the benchmark for fold sequence notation and the cultural icon of origami. Here is the complete sequence from a 15cm square:

1. **Preliminary base**: Complete the preliminary base (8 steps — see §2.1).
2. **Petal fold (front)**: Fold the right and left edges of the front to the centre crease; lift the bottom point up; press flat.
3. **Petal fold (back)**: Turn over; repeat step 2 on the back.
4. **Result**: Bird base.
5. **Narrow points**: Fold right half of front flap to centre; repeat on back. Repeat on reverse side.
6. **Inside reverse fold (head)**: Inside-reverse the right point to form the head and beak.
7. **Inside reverse fold (tail)**: Inside-reverse the left point slightly upward.
8. **Wings**: Hold both sides of the body and pull gently apart; the body expands and wings flatten.

**Total steps**: ~28 depending on counting convention.

**Crease count**: ~20 distinct creases.

**Mathematical note**: The crane has exactly 6 interior vertices. All satisfy Kawasaki (alternating angle sums = π). Maekawa is satisfied (M-V=±2) at each vertex. The mountain/valley assignment is highly constrained — there are only a small number of valid assignments.

---

## 4. Fold Sequence Complexity

### 4.1 What Makes a Sequence Hard?

Not all fold sequences are equal in difficulty:

- **Accessibility**: Can you physically reach the fold with your fingers in the current model state?
- **Layer count**: Folding through many layers is difficult; sequences should minimise peak layer count.
- **Precision dependency**: Some folds require previously-made creases to be exactly accurate; others are forgiving.
- **Reversal**: Some fold sequences require partially unfolding and re-folding — physically demanding and conceptually confusing.

### 4.2 The Optimal Sequencing Problem

Given a target crease pattern, find the **minimum-length fold sequence** that achieves it.

**This is NP-hard** (Demaine, 2010). The difficulty comes from the combinatorial explosion of fold-order choices combined with the physical reachability constraint (at each step, the accessible folds depend on the current folded state).

**Practical approach**: Human origami designers find good sequences through experience and trial-and-error. No general algorithm exists.

### 4.3 Single-Straight-Cut Fold Sequences

A special case where the target is to cut out a shape with one straight cut (see `computational_origami.md`). The fold-and-cut theorem guarantees a valid fold sequence exists, and the straight-skeleton algorithm provides a constructive sequence. This IS polynomial-time computable.

---

## 5. Lang's Fold Notation

Robert Lang's textbook *Origami Design Secrets* standardises fold notation for complex origami:

### 5.1 Arrow Conventions

- **Straight arrow**: Fold in the direction of the arrow
- **Curved arrow**: Rotate the paper
- **Double-headed arrow**: Fold and unfold
- **Hollow arrow**: Turn paper over
- **Looping arrow**: Sink fold
- **Tuck arrow**: Paper goes behind/inside

### 5.2 Symbol Set

The full Lang notation includes:
- X-ray lines (dashed): creases on hidden layers
- Equality marks: equal lengths
- Angle marks: equal angles
- Division marks: fold to bisect

This notation system allows origami diagrams to be unambiguous across language and culture — a genuinely universal visual grammar.

---

## 6. Traditional Bases vs. Computational Bases

### 6.1 Hand-Designed Bases (Traditional)

Traditional bases (bird, frog, waterbomb, kite) were discovered empirically over centuries. They are:
- **Memory-efficient**: Simple sequences, easy to teach
- **Sub-optimal for complexity**: Limited number of points; no provision for fine detail

### 6.2 TreeMaker Bases (Computational)

Robert Lang's TreeMaker algorithm designs bases algorithmically (see `computational_origami.md`). These bases are:
- **Optimally efficient**: Maximum model complexity for a given paper size
- **Arbitrarily complex**: Any number of points, any proportions
- **Hard to fold**: The sequences for TreeMaker bases are long and unintuitive

For a 64-point base (a humanoid figure with fingers, toes, etc.), TreeMaker designs a crease pattern requiring a 50-step sequence and precise reference points that cannot be found by simple folding.

### 6.3 The Middle Path

Most master origami artists (Kamiya, Lang, Yoshino) work in the gap:
- Use TreeMaker to establish the basic point topology
- Manually refine the crease pattern for foldability and aesthetics
- Design the fold sequence by hand, exploiting familiarity with the pattern

This human-computer collaboration defines the current state of the art.

---

## 7. Yoshizawa's Wet-Folding Technique

**Akira Yoshizawa** (1911–2005) is considered the father of modern origami. His contributions include:
- Standardising fold notation (mountain/valley symbols, arrows)
- Inventing the **wet-folding technique** (see `paper_physics.md`)
- Producing over 50,000 original models across his lifetime

His fold sequences are notable for their **rhythm**: he would fold at a specific pace, allowing the paper to settle into each position before the next fold. He spoke of "listening to the paper."

---

## 8. References

- **Yoshizawa, A.** (1957). *Origami Tokuhon (Origami Reader)*. Tokyo Origami Association.
- **Lang, R.J.** (2011). *Origami Design Secrets: Mathematical Methods for an Ancient Art*, 2nd ed. CRC Press. (Full fold notation system, chapters on bases and sequences.)
- **Kasahara, K.** (1988). *Origami Omnibus*. Japan Publications.
- **Fuse, T.** (1990). *Unit Origami*. Japan Publications.
- **Demaine, E.D.** (2010). "Computational Origami." *Proceedings of the 26th ACM Symposium on Computational Geometry* (invited talk).
- **Hull, T.** (2013). *Project Origami: Activities for Exploring Mathematics*, 2nd ed. CRC Press. Chapter 1: Fold Sequences as Mathematics.
- **Engel, P.** (1989). *Folding the Universe: Origami from Angelfish to Zen*. Vintage Books. (Detailed fold sequences for complex representational origami.)
