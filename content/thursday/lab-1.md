---
title: "Lab 1: Give and Take"
weight: 2
math: true
toc: true
---

## Overview

This lab will introduce you to the inner workings of `MESA/binary`, and give you an understanding of how massive stars exchange mass.

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

## Case A and B

When stars evolve, they become bigger over time.
As soon as the most massive star evolves to fill its **Roche Lobe**, mass transfer will ensue.
Depending on the evolutionary stage of the donor, we destinguish different mass transfer _cases_.
When the donor is still hydrogen burning, we speak of case A mass transfer, while when it is core-helium burning, we have case B (there's even case C for mass transfer post core-helium exhaustion).

The main parameter controlling when mass transfer will occur is the initial orbital period.
For massive stars, the rule of thumb is that case A occurs for initial periods under 10 days, and case B occurs between 10 and 1000 days (with case C at a small interval of even larger periods).

> [!Note]
> To get started with binary-evolution runs, copy the contents of the binary `work` directory from `$MESA_DIR/binary/work` into your directory tree where you are running the school labs.
> It should contain familiar files like `./rn` `inlist` and contain a `src/` directory
> Next, download and extract the [inlist_tarball](/thursday/lab1/inlists.tar) for this lab.
> Remember that `MESA` always looks for a file named `inlist` to start reading in parameters.
> We've setup up the inlist chain to read the appropriate parameters from appropriately named inlist file.

### Case A evolution: Tidal domination

When interaction occurs during the main sequence, the initial period of the system must be small, because the stars are compact (relative to post-main-sequence (super-)giants).


### Case B evolution: You spin me round

Set up `inlist_project` with `initial_period_days = 20d0`, and run the simulation with `./mk` and `./rn`, just as you'd do for a single-star evolution run.


