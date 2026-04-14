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
> Remember that `MESA` always looks for a file named `inlist` first to start reading in parameters.
> However, as is customary, we've setup up an inlist chain to read the appropriate parameters from appropriately named inlist files.

### Case A evolution: Tidal domination

When interaction occurs during the main sequence, the initial period of the system must be small, because the stars are compact (relative to post-main-sequence (super-)giants).
We also expect tidal interaction to be very strong between stars that orbit each other so tightly.
Let's see what this does to the rotation rate of the stars in this system.

In `inlist_project`, set the initial period to 5 days, and start the `MESA` run with `./mk` and `./rn`, just as you'd do for single-star evolution!

During the run, watch the following quantities in the `pgbinary` window:

1. Mass-transfer rate: How much mass is the primary dumping onto the secondary, and what is its efficiency? Is is constant over time (or model number)? Are there more than one mass-transfer phases?
{{< details title="Hints" closed="true" >}}
look at `lg_mtransfer_rate`, `eff_xfer_fraction` (the "effective transfer fraction") and their associated graphs.
Don't be alarmed if the `xfer_fraction` is negative when no mass transfer is happening, that is because it is naively calculated as `eff_xfer_fraction = - dot_M2 / dot_M1`, which contains contributions from the stellar winds.
{{< details title="Result" closed="true" >}}
You should see two distinct phases of mass transfer, case A and later case AB when the primary exhausts hydrogen and tries to become a giant.
In fact, the first mass-transfer phase is split in 2: a mass-transfer rate _fast case A_ followed by a more mellow _slow case A_ where the mass transfer rate is a couple of orders of magnitude lower.
{{< /details >}}
{{< /details >}}

2. Luminosity profiles: Are the stars in thermal equilibrium? If not, how does this manifest?
{{< details title="Hint" closed="true" >}}
Thermal equilibrium is defined as $\frac{dL}{dm} = \epsilon_{\rm nuc}$.
Where is nuclear burning occuring?
Compare the numbers for the `kh_timescale` and the `mdot_timescale` in the text summary of both stars.
{{< details title="Result" closed="true" >}}

You should see that neither star satisfies it during rapid mass-transfer phases.
The donor's luminosity profile dips significantly in the envelope, so that $\frac{dL}{dm} \ne 0$, but we have that $\epsilon_{\rm nuc} = 0$ as no burning takes place in the envelope.

The accretor is slightly more luminous than its nuclear luminosity, due to the accretion energy it gains.
In the slow case A phase, thermal equilibrium is nearly satisfied, as the thermal timescale of the stars is shorter than the mass-transfer timescale.
{{< /details >}}
{{< /details >}}

3. Rotation rates: Do the stars spin up or down significantly during mass transfer events?
{{< details title="Hints" closed="true" >}}
Look `omega_div_omega_crit` profiles of either star.
{{< details title="Result" closed="true" >}}
Tides keep the stars rotating very close to the keplerian (synchronized) velocity!
{{< /details >}}
{{< /details >}}

4. How does the period evolve during the mass transfer events?
5. At the end of the run, what is the state of both of the stars? Is the secondary star significantly evolved?

### Case B evolution: _You spin me 'round_

Copy the directory from case A into a new folder for case B mass transfer (so that you'll have nicely separated end models for either case).

Edit `inlist_project` with so that this system has an initial period of 20 days.
Also, change the tides prescription from `Orb_period` to `Hut_rad`.
We make this choice here because at larger periods (and thus larger separations between the stars), tides are weaker, and the prescription of Hut, P. 1981, A&A, 99, 126, is a physically motivated computation of how tides operate in the radiative envelopes of massive stars.

Run the simulation, and watch as the primary star first exhausts hydrogen before a phase of mass transfer starts.

