---
title: Lab 2
author: Lucas de Sá (lead), Annachiara Picco, Mathias Fabry, Lieke van Son
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

A rapidly rotating star will become oblate due to the stronger centrifugal force felt in the equator (where the distance to the axis of rotation is greatest) relative to that felt towards the poles (where the distance shrinks to zero). This rotation-induced difference in the distance to the center of mass means that the effective surface gravity, $g_\mathrm{eff}$, is greater at the poles than at the equator. Then, it follows from the von Zeipel theorem,

$$F_\mathrm{rad}\propto g_\mathrm{eff},$$

that the radiative flux is greater towards the poles than the equator. Because this makes the temperature gradient steeper towards the poles, and $\mathbf{F}_\mathrm{rad}\propto\nabla T$, we now no longer have $\nabla\cdot\mathbf{F}_\mathrm{rad}=0$ for a static solution, i.e., the star cannot simultaneously be in thermal and hydrostatic equilibrium. From energy conservation,

$$\rho T\mathbf{v}\cdot\nabla S=\rho\epsilon-\nabla\cdot\mathbf{F}_\mathrm{rad}.$$

Since no nuclear burning is taking place in the envelope, $\epsilon=0$, and the response to a non-zero flux divergence is the development of a velocity field. In concrete terms, on the poles rotation causes a negative flux divergence (the gas is being "boiled") and a centrifugal velocity field --- i.e., the gas rises towards the surface. On the equator, in contrast, the flux divergence is positive (the gas is being "cooled"), and the velocity field is centripetal --- the gas sinks.

This pattern --- gas rises at the poles, sinks at the equator --- goes all the way from the core to the surface in rigidly-rotating stars, and is called **Eddington-Sweet circulation**, or **meridional circulation**. As the star burns away hydrogen into helium in the core, this current keeps bringing up helium to the surface, and more hydrogen back to the core. If the circulation holds for the entire Main Sequence, by the time hydrogen depletes in the core, the surface will also be hydrogen-poor, if not hydrogen-free, and you have a bare helium core, or He star, and are on the way to forming a Wolf-Rayet star. In the absence of rotation, the hydrogen envelope needs to be physically removed in order to form Wolf-Rayets, such as by the mass transfer processes we saw in Lab 1, and will see again in Lab 3.


{{< details title="Is a He star not a WR star?" closed="true">}}
Not always! While all WR stars are He stars, Wolf-Rayet is a (mostly) well-defined collection of spectral types defined by the absence or near-absence of hydrogen lines, and by the presence of certain key emission lines from nitrogen, carbon and/or oxygen. Those lines are only excited at temperatures significantly higher than those characteristic of Main Sequence star surfaces - and therefore we should generally expect our star to spend at least some of its time as a He star with an O-type or O/WN spectrum. This last case, a "slash star", is a transitional type between the O-type and the coolest type of WR (the N in WN stands for nitrogen).
{{< /details >}}

Because the electron scattering opacity of helium is half that of hydrogen, several things change in the life of a CHE star compared to a non-rotating star. With lower opacity, light can pass more freely through the gas, therefore the radiative output is more energetic - the star is more luminous and bluer, i.e., hotter -, and the gas in the envelope is not heated, and therefore does not expand. A CHE star thus avoids the characteristic dramatic expansion into a supergiant phase post-MS, and, except for a brief ($\sim10\,\mathrm{kyr}$) phase of modest (factor of $\sim2-3$)expansion between H shell ignition and He core ignition, remains compact for its entire life. 

In order to remain homogeneous, a star needs to sustain a very high rotation rate through all of the Main Sequence. Because massive stars naturally tend to spin-down due to stellar winds, which also carry away angular momentum, it is generally assumed that an external force must continuously drive rotation during that period. In a binary, tidal forces play that role: in a binary with period of a few days or less, tides are strong enough that we can assume the star is synchronized to the orbital period at birth (like the Moon's spin is synchronized to its rotation around the Earth). That orbital period itself being very short, the star will also be spinning with a short period.

In Lab 2, we will explore the conditions under which a star is able to evolve chemically homogeneously, and calculate the resulting black hole spins that can be expected from this kind of object. Assuming that rotation comes from tidal synchronization, we will vary the initial orbital period of a massive star binary, test what happens if a star is spun-up in the middle of the Main Sequence, compute black hole spins, and try out variations of angular momentum transport mechanisms.

{{< details title="What about equations? And the non-rigidly rotating case?" closed="true" >}}

In the more general case, allowing for **differential rotation**, the neat picture of Eddington-Sweet circulation breaks down. While we cannot explore the full theory of circulation in rotation stars here, in case you are curious, it is instructive to look at what changes in the equations for the circulation velocity between rigid-body and differential rotation. The full expression for the velocity of meridional circulation can be broken down into a radial and a horizontal component, as

$$\mathbf{U} = U_2(r)P_2(\cos\vartheta)\mathbf{e}_r + V_2(r)\frac{\mathrm{d}P_2(\cos\vartheta)}{\mathrm{d}\vartheta}\mathbf{e}_\vartheta,$$

where $P_2$ are second-order Legendre polynomials and $U_2$ and $V_2$ are the radial and horizontal velocity amplitudes, respectively. For the radial amplitude, the full expression is

$$U_2(r) = \frac{P}{\bar{\rho}\bar{g}C_P\bar{T}(\nabla_\mathrm{ad}-\nabla+\frac{\phi}{\delta}\nabla_\mu)} \left[
    \frac{L(r)}{M(r)}(E_\Omega + E_\mu) + \frac{C_P}{\delta}\bar{T}\frac{\partial \Theta}{\partial t},
\right]$$

where the diverse quantities, including averages ($\bar{\rho}$, $\bar{T}$, etc.) are evaluated at mass shell of radius $r$, accounting for horizontal fluctuations. Radial motion can be driven by rotation, encoded in the $E_\Omega$ term, or chemical fluctuations, encoded in the $E_\mu$ term. The quantity $\Theta$ encodes density fluctuations, and is given by what is called the baroclinic equation,

$$\Theta:=\frac{\tilde{\rho}}{\bar{\rho}}=\frac{1}{3}\frac{r^2}{\bar{g}}\frac{\mathrm{d}\Omega^2}{\mathrm{d}r},$$

and thus, for rigid rotation, $\mathrm{d}\Omega/\mathrm{d}r=0\to\Theta=0$. If the star is also chemically homogeneous along each mass shell, then $E_\mu=0$. This is the assumption in MESA, and physically justified by the presence of strong horizontal turbulence. By expanding $E_\Omega$ and including a correction for the importance of radiation pressure, the expression for the radial velocity becomes

$$U_2(r)=\frac{16}{9}\frac{\beta}{32/3-8\beta-\beta^2} \frac{L(r)r^2}{GM_r^2} \frac{1}{\nabla_\mathrm{ad}-\nabla+\frac{\phi}{\delta}\nabla_\mu}\frac{\Omega^2r^3}{GM_r},$$

where $\beta=P_\mathrm{gas}/(P_\mathrm{gas}+P_\mathrm{rad}$). Since in a radiative zone (or a semiconvective zone, if you have encountered the definition) $\nabla_\mathrm{ad}-\nabla+\frac{\phi}{\delta}\nabla_\mu>0$, U_2(r) is strictly positive across our envelope. Plugging it back into the first equation and accounting for the sign of $P_2$ yields the neat picture: matter rises towards the poles, sinks at the equator.

Conversely, any significant departure from these specific conditions: chemically homogeneous, radiative, rigid-body rotation, reintroduces terms that can have a negative sign into the expression for $U_2$. For differential rotation, this comes back through the time derivative of $\Theta$, which itself goes with $\mathrm{d}\Omega^2/\mathrm{d}r$. The circulation then can, and does, stall and even reverse as a function of radius. 

Since MESA adopts a diffusive picture for every mixing process, this means it cannot naturally adapt this *advective* part of meridional mixing, which can potentially go either with or against the chemical gradient. This is a known limitation, and how to model meridional mixing, and to what extent the diffusive approach is a limitation, is an active topic of debate in stellar evolution. For our lab, we are far more concerned with large-scale, mean effects of rotation, and generally staying in the rigid-body regime, and the diffusive approach is adequate for our regime. If you are curious, you can find the full treatment in Zahn X, Maeder 2009.

{{< /details >}}




* 1D implementation of mixing processes - where?

## Setting up your work directory

| 📋 TASK 1 |
| :---------|
| Download the lab2 work directory from the Google Drive link. |

Let's start with a tour of the working directory and note a few points. The `initial_model` folder contains a basic single-star setup to generate a non-rotating ZAMS model for your chosen mass. This is used as setup for the full binary run in the `binary_model` folder. You can go ahead and compile and run MESA in the `initial_model` folder now. This will generate our fiducial ZAMS model with mass $35\,\mathrm{M}_\odot$ and metallicity $Z=0.001$.

| 📋 TASK 2 |
| :---------|
| Compile and run MESA in `initial_model`, then copy the new `model.mod` file to the `binary_model` folder. This is the starting model. |

You may later want to try out different masses or even metallicities as a bonus. The important controls are all in `inlist_project`: `initial_mass` in `&controls`, `Zbase` in `&kap`, and `new_Z` in `&star_job`.

Let's take a small tour of the `binary_model` folder. Starting by looking at `inlist_project`. At the very top we have,

```fortran
&binary_job
    inlist_names(1) = 'inlist1'
    evolve_both_stars = .false.
```

This means that we are telling MESA to only solve stellar structure for the primary, and giving it the settings only for that star. When 'evolve_both_stars=.false.', the secondary is treated as a constant-mass point mass. We do this here to keep computational times down, since we want to be able to get to the end of He burning. 

Using a point-mass companion instead of running a single-star primary further gives us the advantage of keeping the effect of tides on the primary, as well as tracking the orbital evolution. While this setup will not compute mass transfer (for the sake of the computational time), it will still track the occurence of L2 overflow, in which case the run will be stopped as a case of a stellar merger.

Further down in `&binary_controls`, the mass of the secondary must be set explicitly with `m2=35.d0`, since it will not load a full model file like the primary. We will be focusing solely on equal-mass binaries in this lab, in order to maximize the efficiency of tides. 

Another setting to be aware is the second-to-last block in `inlist_project`

```fortran
   sync_mode_1 = "Uniform"
   sync_type_1 = "Hut_rad"
   Ftid_1 = 1
   do_initial_orbit_sync_1 = .true.
```


Which is doing several important things. In order, it tells MESA to apply the tidal torque to every mass shell uniformly; to compute the torque according to the Hutt+1999 model for radiative envelopes (always the case for our massive, compact stars); to not further scale the tidal synchronization timescale; and to synchronize the star to the orbital period at the start of the run.

As we saw at the top, the primary is configured by loading `inlist`. Inside that file, a few settings are worth pointing out. In `&star_job`, the lines

```fortran
    new_rotation_flag = .true.
    change_rotation_flag = .true.
    set_initial_surface_rotation_v = .true.
    !set rotational velocity to zero, tides will change this
    new_surface_rotation_v = 0
    num_steps_to_relax_rotation = 30
```

are telling MESA: change the initial rotation (lines 1-2), set the initial rotation through the rotation velocity (line 3, velocity in km/s), target $v_\mathrm{i}=0\mathrm{km}\,\mathrm{s}^{-1}$, and take up to 30 steps to relax the stellar structure to that velocity. Further down, `load_saved_model` and `load_model_filename` point it to the model you created and copied from `initial_model`. 

What follows is a long list of resolution settings calibrated to make the run relatively fast on 2 cores, which we will not touch. Further down we have a long block of rotational mixing coefficients. Eddington-Sweet circulation is controled by `D_ES_factor`, which when set to `1` turns it on at the baseline intensity for chemical mixing. Angular momentum transport multiplied the factor specified in `am_D_mix_factor` - so it is weaker by a factor of 3.



* Caveats of point mass companion model (either here or next scetion)
* Definition of CHE
* Point mass companion set-up - what is compensated for, what is missing
* Resolution etc
* Generate initial model

Before we start, we need to 

| 📋 TASK 1 |
| :---------|
| In `inlist_project`, find `initial_mass` in the `&control` namespace and set it to 35.0, then run. Copy the output `model.mod` to the `binary_template` folder.|

## Step 1: Exploring the CHE window

Our first task is simple: for a fixed initial mass, we will try to determine the shape of the CHE window on the initial orbital period axis. For this, each group will choose one of the masses below --- try to coordinate so that those with more powerful computers take the greater masses.

* Customize pgstar window to see 1D plots?

| 📋 TASK 2 |
| :---------|
| Choose an initial orbital period between A and B and set in `initial_period_in_days` in `inlist_project`, then run.  
Watch the pgstar window closely, in particular the diffusion coefficient panel. Does your star go homogeneous?  
What happens if the period is too short?
What happens if the period is too long?|

| 📋 TASK 3 |
| :---------|
| Try to find two periods, one leading to CHE and the other not. Can you spot what precedes the loss of homogeneity from your pgstar plots?|

{{< details title="Hint: How to get CHE?" closed="true" >}}

The period range for getting CHE with a 35 Msun star is very narrow. 0.95d is a reliable number, and anything above 1.0d will not go CHE, while anything lower will lead to a merger. As the masses go up, the window widens, with approximate ranges.

{{< /details >}}


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

$$\chi:=\frac{cJ}{GM^2}\leq1,$$

where we define the black hole spin parameter, $\chi$, which you might be familiar with. Our objective in this step will be computing the spin parameter for our stellar cores, under the assumption that this will be conserved during black hole formation. We will later reconsider the feasibility of this assumption.

We will do this by adding a new column to our history files named `chi_core`, which will hold the value of $\chi$ computed with the He core mass and total angular momentum. For post-MS CHE stars, which are already exposed He cores themselves, these are merely the total mass and angular momentum. Including an explicit logic for looking for the core boundary, however, will allow us to later use the same code to compute core spins for stars that retain their H envelope.





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
