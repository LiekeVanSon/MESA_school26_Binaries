---
title: "Lab 1: Give and Take"
weight: 2
math: true
toc: true
---

mass transfer and accretion efficiencies.
compare to observed post mass transfer systems

## Overview

Summarize the scientific goal, expected runtime, and the key MESA concepts introduced in this lab.

## Anatomy of a binary

Simulating single stars is fun, but simulating binary stars is even _more_ fun.
MESA can do this by separately solving the equations of stellar structure on both objects, and potentially link them by invoking interaction routines.

Imagine two rows of boxes, representing the stars.
Each box is filled with the properties of the interiors ($T, \rho, r, L, X$), varying from the cores to the surfaces.
`MESA/star` is in charge of evolving those two rows of boxes by advancing the time by $\Delta t$, and solving the stellar structure equations, keeping in mind all of the required microphysics (nuclear nets, eos, opacities, mixing, etc...).
A binary star, however, is more than just its two components.
The two objects are _orbiting_ each other, which requires 4 variables to fully specify (we do not care about the orbit's orientation to a potential observer):
We choose them to be the masses of the objects, the orbit's angular momentum, and its eccentricity.
$$M_1, M_2, J_{\rm orb}, e.$$
Each variable has an associated evolution equation, e.g.:
$$\frac{dM_1}{dt} = \dot{M}_{1, \rm wind} + \dot{M}_{1, \rm trans}$$

`MESA/binary`'s job is to carefully track the orbital quantities, and check that the state of the stars are "acceptable."
For example:

1. If $\dot{M}_{1, \rm trans}=0$ and both stars do not overflow their respective Roche Lobes, we are good, as it fulfills the requirements for a non-interacting binary.
2. On the other hand, if it turns out that the evolution of donor (as reported by `MESA/star`) is such that its radius is larger than the Roche Lobe radius, the `roche_lobe` scheme of mass transfer is violated!
We have to redo the step with a higher mass-transfer rate, so that (hopefully) this reduces the radius of the donor star to just within the Roche Lobe radius.

With the most basic concepts of `MESA/binary` out of the way, let us continue by exploring the science of massive binary stars and their interactions.

## Learning goals/concepts

- How stars accrete
- how stars respond to mass loss and gain
- stars out of thermal equilibruium

## Session Plan

### stable mass transfer from star to star

Explore both a case A and case B mass transfer case.
See how conservative the mass transfer is in both cases
(understand critical rotation, tides etc.)

### Compare output to observed post mass transfer systems

I.e. Algols or subdwarfs. Possibly we tell them what to assume for stellar params
Should mass transfer be more conservative?

### Add own model for accretion efficiency

explore more conservative case B mass transfer
See if this matches better

## Files

Supporting starter files for this lab are available here:

- [inlist](/thursday/lab1/inlist)
- [inlist_project](/thursday/lab1/inlist_project)
- [inlist_pgstar](/thursday/lab1/inlist_pgstar)

Notes for this lab remain in [content/thursday/lab1/notes.md](content/thursday/lab1/notes.md).
