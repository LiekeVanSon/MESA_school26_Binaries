---
title: Lab 2
weight: 3
math: true
toc: true
---

# Lab 2: Stellar Swirling

10:45 AM–12:00 PM
Timing: 10 min lecture + 1 hour MESA material


## Overview/Learning goals

[thinking notes for now, to filter back from]

#### Goals
The main physical object of Lab 2 is rotation. With Lab 1 providing an introduction to the binary module and the role of accretion physics, and Lab 3 extending the physics introduced in Labs 1 and 2 to the whole landscape of BBH formation, Lab 2 should therefore focus on the role of rotation insofar as it most significantly affects BBH formation. Other interesting aspects of rotation that do not bear directly on BBH formation should be left for bonuses or potential evening session topics.

This means that *sources* of rotation (with the exception of accretion spin-up, assuming it is included in Lab 1), are unlikely to fit in the Lab 2 timeslot this means that. Nevertheless, we can first try to explore a throughline for the discussion of rotation, before reducing it to the essentials.

The most dramatic effects of rotation on massive star evolution come from chemical mixing, AM transport and rotationally-enhanced mass loss. Both AM transport and chemical mixing depend crucially on whether rotation is **rigid body** or **differential**. This can be **Topic 1: rigid body X differential rotation**.

The natural question from Topic 1: what does it matter? Differential rotation allows for fundamnetally different modes of AM transport and chemical mixing than rigid body rotation. We have the emergence of **shear**, the **Tayler-Spruit dynamo**, **Eddington-Sweet circulation** (and Gratton-Opik, though MESA technically does not account for it because it is the advective/non-diffusive component of meridional mixing). **Convection** is also important as it imposes rigid body rotation.

Another natural question is: *what determines whether the star develops rigid body or differential rotation?* The question is a bit circular, because differential rotation allows the emergence of mechanisms like the TS dynamo that, if assumed to operate, suppress differential rotation. Therefore, the answer to the question depends on assumptions. The answer to the question has two components: *what is the spin-up mechanism* and *what AM transport is active*. Strong AM transport always tries to make the star rigidly rotating where it is present, regardless of the source of AM. Accretion spin-up only spins the surface up, and in the lack of efficient AM transport, it likely creates differential rotatoin (though this is dependent on what is assumed for the accreted angular momentum). 

**Tides** likewise interact with the assumptions for AM transport. While Lab 3 means the focus is on massive stars, for which we generally only worry about **dynamical tides**, it bears introducing both those and **equilibrium tides**. Equilibrium tides are also useful because they will be the most familiar: these are the ones driven by tidal deformation of a star by its companion, the trailing bulge when spin and orbit are not synchronized, which creates internal friction, which dissipates AM into the structure of the star. This familiar picture is very useful to set before talking about dynamical tides because it highlights the role of **dissipation**. The tidal bulge is just a geometrical deformation, until all that potential energy has a mechanism through which it can be transmitted into stellar structure. A convective envelope has **turbulent viscosity** - convective plumes move on the scale of 1e10 cm, allowing AM to be moved across mass shells with large AM differentials; this is so efficient MESA effectively assumes convective regions are always rigidly rotating. A radiative envelope only has **radiative viscosity**, which operates on ~1 cm scales related to photon emission and reabsorption, transporting AM across a small region; and **molecular viscosity**, which relies on Coulomb interactions on even smaller ~1e-5 cm scales. Therefore, equilibrium tides are very inefficient on massive stars, not because they are not tidally deformed, but because there is no efficient mechanism for dissipation of that potential energy.

The stable, stratified structure of radiative envelopes, however, does allow for the development of **g-modes**. Radiative zones, by definition, do not allow convection to develop because a cell that is pushed up, rises, the expands in the lower-density environment, cools down more quickly with radius than its surroundings ($\nabla_\mathrm{ad}<\nabla_\mathrm{rad}$) and sinks back down. Its retained kinetic energy then causes it to overshoot its initial position, heat up more quickly than the higer-density environment, and rise gain, oscillating in the local **Brunt-Väisäla frequency**. The cell moves material out of the way --- primarily in the horizontal direction --- and this propagation consists in a **gravity wave**. In a radiative zone, these gravity waves are bound to reach and be reflected by two boundaries: the convective zone boundary, which is opaque to gravity waves; and the stellar surface. This is a cavity, allowing only the establishment of standing waves, called the stars **g-modes**. g-modes typically have wavelengths smaller than the envelope scale ---- $10^7-10^9\,\mathrm{cm}$, compare $\mathrm{R}_\odot\sim10^{10}\,\mathrm{cm}$ --- allowing the development of significant temperature gradients along gravity waves, making them significantly **radiatively damped**. Dampening brings the wave out of phase with the companion, thereby making it into a forced, damped oscillation with a non-zero torque on the mass element being forced. The dampening deposits AM along the way, but because the fluid is nearly incompressible, and because the density gradient presents a barrier to pushing fluid up, the oscillating element displaces surrounding fluid azimuthally. The resulting out-of-phase azimuthal compression waves efficiently allow for a tidal torque in radiative envelopes as long as the forcing frequency ($2\left|\Omega_S-\Omega_L\right|$) is greater than that of the fundamental mode. 

AM transport is important because both models are, in principle, active simultaneously in the core and the envelope, and radiative damping's dependence on the temperature gradient further implies it does not drive rotation uniformly, particularly in a radiative envelope where opacity peaks develop, and where the very surface where the waves break. In the absence of efficient AM transpot beyond convection, both tides and accretion tend to produce differential rotation.

Rotation and AM transport also directly connect to chemical mixing across radiative zones and through convective boundaries. Key for us are **(dynamical) shear**, acting within a differentially rotating radiative envelope and across the boundary with a convective core; and **Eddington-Sweet circulation**, acting across the radiative envelope. Strong shear generally disfavors ES circulation, meaning that the two modes of radiative envelope mixing are generally mutually exclusive in their most efficient instances. 

The final key ingredient is the presence or absence of **magnetic fields**, which can efficiently drive AM transport through the development of **Tayler-Spruit instabilities** along differentially rotating interfaces, which thereafter drive the structure towards rigid body rotation, surpressing shear mixing and favoring ES circulation. 


- Birth rotation
- massive stars going CHE
- tides
- effect of AM transport

The **MESA implementation** of AM transport/chemical mixing deserves to be explicitly described. For rotation, the treatment of chemical barriers needs to be directly explained if the intention is to elucidate the difference between accretion-induced CHE and CHE from ZAMS, as it strongly limits the possibility of driving a star CHE in the middle of the MS.

[to be continued...]

## Session Plan

### Stellar rotation & CHE

Start with rapidly rotating star mini-grid
See CHE boundary? 

what are mixing processes in MESA? 

*Potentially bonus material:*
how do we approximate a 3D mixing process in 1D?
(diffusion etc.)


### Tides

Perhaps combine CHE in here

### The spins of BHs (or compact obj.)

explore different AM transport mechanisms
Add your own prescription

Try to run at least until He exhaust (preferably C-depletion)

What would the spin of a BH be if this core collapsed directly? I.e. explore J-profile


## Files

Supporting starter files for this lab are available here:

- [inlist](/thursday/lab2/inlist)
- [inlist_project](/thursday/lab2/inlist_project)
- [inlist_pgstar](/thursday/lab2/inlist_pgstar)

Notes for this lab remain in [content/thursday/lab2/notes.md](content/thursday/lab2/notes.md).
