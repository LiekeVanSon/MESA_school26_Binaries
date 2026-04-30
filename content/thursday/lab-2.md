---
title: Lab 2
weight: 3
math: true
toc: true
---

# Lab 2: Stellar Swirling

10:45 AM–12:00 PM
Timing: 10 min lecture + 1 hour MESA material

In the previous lab, we explored the occurrence of mass transfer in binaries, and saw its effects not only on the stellar mass, but also on its radius and on the orbital separation. Another natural effect of accretion is the spin-up of the accretor: the accreted material is originally co-rotating with the donor; then, as it settles on an accretion disk it is still rotating around the accretor; and, therefore, the accreted layers are themselves rotating even if the accretor originally was not. Rotation can have dramatic effects in stellar evolution, including on the mass-radius relation, and as a consequence on the occurrence of mass transfer. In Lab 2, we will look at the effect of rapid rotation on the structure of a 35 solar mass star, and explore how that changes depending on the timing of spin-up and the final core spins as a function of AM transport mechanisms.

(Part 1, before lunch)

## Theory: chemically homogeneous evolution

* CHE
* Tidal spin-up
* Caveats of point mass companion model (either here or next scetion)
* 1D implementation of mixing processes

## Setting up your work directory

* Definition of CHE
* Point mass companion set-up - what is compensated for, what is missing
* Resolution etc
* Generate initial model

Before we start, we need to 

| 📋 TASK 1 |
| :---------|
| In `inlist_project`, find `initial_mass` in the `&control` namespace and set it to 35.0, then run. Copy the output `model.mod` to the `binary_template` folder.|

## Step 1: Exploring the CHE window

For this task we will merely explore the initial orbital period space for a fixed mass.
* Customize pgstar window to see 1D plots?

| 📋 TASK 2 |
| :---------|
| Choose an initial orbital period between A and B and set in `initial_period_in_days` in `inlist_project`, then run.  
Watch the pgstar window closely, in particular the diffusion coefficient panel. Does your star go homogeneous?|

| 📋 TASK 3 |
| :---------|
| Try to find two periods, one leading to CHE and the other not. Can you spot what precedes the loss of homogeneity from your pgstar plots?|

{{< details title="Hint: How to get CHE?" closed="true" >}}

The period range for getting CHE with a 35 Msun star is very narrow. 0.95d is a reliable number, and anything above 1.0d will not go CHE.

{{< /details >}}

BONUS: mass variations

## Step 2: Exploring spin-up timing

In this section we learn how to include a restart and switch to different inlist in order to emulate accretion spin-up partway through the MS.  We include a new stopping condition in run_star_extras based on the differential of hydrogen or helium abudance between core and surface. Try spin-up at different instants and see if you can still get CHE. Look at the diffusion coefficient plot.

BONUS: try setting high initial rotation manually in a wide binary and play around with wind rotation (or Task 3?)

(Part 2, after lunch)

## Step 3: post-MS evolution

* Core spin-up, AMT+Wind effects

## Step 4: Computing core spin at He depletion

Solving Einstein's equations for the general case of a black hole with mass $M$, angular momentum $J$ and electric charge $Q$ (this is called a Kerr-Newman geometry), yields the condition

$$\frac{Q^2}{4\pi\epsilon_0} + \frac{c^2J^2}{GM^2}\leq GM^2$$

for the presence of an event horizon around the singularity. Under the assumption of *cosmic censorship* --- that no so-called *naked singularities* can exist in Nature ---, this is a hard limit on the three numbers that fully define a black hole (this is the No Hair Theorem). For the case of an eletrically neutral black hole, this simplifies to

$$\chi=\frac{cJ}{GM^2}\leq1,$$

this is the spin parameter.



BONUS: compute spin as a function of accreted mass
BONUS: Create a j x free fall time profile and compare to j_ISCO

## Step 5: Changing the AM transport prescription

BONUS: change the wind prescription

## Big Bonus Binary

For reducing the running time, we made the companion a point mass. You can, however, turn on simultaneous evolution with a few easy steps. What happens?

# Preparation notes

## TO-DO

- [x] adapt 2017 "Rotation in binaries" setup to MESA 25
- [x] initial benchmark binary X single star
- [x] include j_rot profile in pgstar
- [ ] simply D plot in pgstar to only relevant mixing modes, turn rest off
- [x] include am_log_D plot in pgstar 
- [x] test TS on/off
- [x] Fuller & Lu TS prescription?
- [x] test different tide implementations - tested but too much for lab, TS dynamo dominates AM profile
- [ ] prepare spin run_star_extras computation solution
- [ ] run benchmark on a virtual budget laptop configuration with systemd-run

## Setups

- **2017 setup**: adapted version from the 2017 MESA Summer School "Stellar rotation in binary systems" maxilab, by Pablo Marchant 
    - Note: TS dynamo OFF
- **2017 setup point secondary**: 2017 setup but secondary is set to a point mass and mass transfer is turned off; binary module runs orbital evolution and tides; currently cannot stop the run in case of RLOF

## Runtime benchmark
MESA 25.12.1
OMP_NUM_THREADS=2
Ubuntu 24.04.1 LTS
Lenovo ThinkPad X1 Carbon Gen 12
Intel Core Ultra 7 155H @ 22x 4.5GHz
32.0 GiB RAM

Times to reach TAMS unless stated otherwise
- 2017 setup
 - m1=30, m2=30, Z=1d-3, p_zams=0.9 d, ~10 min
- 2017 setup point secondary
 - m1=30, m2=30, Z=1d-3, p_zams=0.9 d, ~5 min to TAMS, ~10 min to He depl

## Notes
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

## Files

Supporting starter files for this lab are available here:

- [inlist](/thursday/lab2/inlist)
- [inlist_project](/thursday/lab2/inlist_project)
- [inlist_pgstar](/thursday/lab2/inlist_pgstar)

Notes for this lab remain in [content/thursday/lab2/notes.md](content/thursday/lab2/notes.md).
