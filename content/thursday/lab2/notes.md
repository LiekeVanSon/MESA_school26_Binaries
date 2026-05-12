# Preparation notes

## TO-DO

### Setup / prep
- [x] adapt 2017 "Rotation in binaries" setup to MESA 25
- [x] initial benchmark binary X single star
- [x] include j_rot profile in pgstar
- [x] include am_log_D plot in pgstar 
- [x] test TS on/off
- [x] Fuller & Lu TS prescription?
- [x] test different tide implementations - tested but too much for lab, TS dynamo dominates AM profile
- [x] prepare spin run_star_extras computation solution
- [x] test setup for MESA 26
- [x] run benchmark with 2 cores on MESA 26 over mass and AMT

---

## Runtime benchmark
MESA 26.04.1  
OMP_NUM_THREADS=2  
Ubuntu 24.04.1 LTS  
Lenovo ThinkPad X1 Carbon Gen 12  
Intel Core Ultra 7 155H @ 22x 4.5GHz  
32.0 GiB RAM  

| id | name | runtime_MS | runtime_HeB | runtime_total |
|----|------|------------|-------------|---------------|
| 00 | model00_m40_TSnu0 | 2m22s | 5m15s | 7m37s |
| 01 | model01_m40_TSnu01 | 2m21s | 4m17s | 6m38s |
| 02 | model02_m40_TSnu1 | 2m32s | 4m18s | 6m50s |
| 03 | model03_m40_TSfullerlu | 2m25s | 4m19s | 6m44s |
| 04 | model04_m70_TSnu0 | 3m24s | 3m59s | 7m23s |
| 05 | model05_m70_TSnu01 | 3m26s | 3m40s | 7m6s |
| 06 | model06_m70_TSnu1 | 3m29s | 3m34s | 7m3s |
| 07 | model07_m70_TSfullerlu | 4m39s | 3m37s | 8m16s |
| 08 | model08_m100_TSnu0 | 5m4s | 4m15s | 9m19s |
| 09 | model09_m100_TSnu01 | 5m20s | 3m49s | 9m9s |
| 10 | model10_m100_TSnu1 | 5m8s | 3m44s | 8m52s |
| 11 | model11_m100_TSfullerlu | 5m7s | 3m40s | 8m47s |
| 12 | model12_m300_TSnu0 | 7m23s | 3m55s | 11m18s |
| 13 | model13_m300_TSnu01 | 7m18s | 3m36s | 10m54s |
| 14 | model14_m300_TSnu1 | 7m20s | 3m37s | 10m57s |
| 15 | model15_m300_TSfullerlu | 7m22s | 3m37s | 10m59s |

How to read:
mXXX : initial mass is XXX Msun
TS:
    nu0: am_nu_ST_factor = 0
    nu01: am_nu_ST_factor = 0.1
    nu1: am_nu_ST_factor = 1.0
    fullerlu: Fuller & Lu (2022) (other_am_mixing hook)

D_ST_factor = 0 always

runtime_MS: wall-clock time to run from ZAMS to H depletion (xa_central_lower_limit h1 = 1d-5)  
runtime_HeB: wall-clock time to continue from H depletion to He depletion (xa_central_lower_limit he4 = 1d-5)


## Notes
The main physical object of Lab 2 is rotation. With Lab 1 providing an introduction to the binary module and the role of accretion physics, and Lab 3 extending the physics introduced in Labs 1 and 2 to the whole landscape of BBH formation, Lab 2 should therefore focus on the role of rotation insofar as it most significantly affects BBH formation. Other interesting aspects of rotation that do not bear directly on BBH formation should be left for bonuses or potential evening session topics.

This means that *sources* of rotation (with the exception of accretion spin-up, assuming it is included in Lab 1), are unlikely to fit in the Lab 2 timeslot. Nevertheless, we can first try to explore a throughline for the discussion of rotation, before reducing it to the essentials.

The most dramatic effects of rotation on massive star evolution come from chemical mixing, AM transport and rotationally-enhanced mass loss. Both AM transport and chemical mixing depend crucially on whether rotation is **rigid body** or **differential**. This can be **Topic 1: rigid body X differential rotation**.

The natural question from Topic 1: what does it matter? Differential rotation allows for fundamentally different modes of AM transport and chemical mixing than rigid body rotation. We have the emergence of **shear**, the **Tayler-Spruit dynamo**, **Eddington-Sweet circulation** (and Gratton-Opik, though MESA technically does not account for it because it is the advective/non-diffusive component of meridional mixing). **Convection** is also important as it imposes rigid body rotation.

Another natural question is: *what determines whether the star develops rigid body or differential rotation?* The question is a bit circular, because differential rotation allows the emergence of mechanisms like the TS dynamo that, if assumed to operate, suppress differential rotation. Therefore, the answer to the question depends on assumptions. The answer to the question has two components: *what is the spin-up mechanism* and *what AM transport is active*. Strong AM transport always tries to make the star rigidly rotating where it is present, regardless of the source of AM. Accretion spin-up only spins the surface up, and in the lack of efficient AM transport, it likely creates differential rotatoin (though this is dependent on what is assumed for the accreted angular momentum). 

**Tides** likewise interact with the assumptions for AM transport. While Lab 3 means the focus is on massive stars, for which we generally only worry about **dynamical tides**, it bears introducing both those and **equilibrium tides**. Equilibrium tides are also useful because they will be the most familiar: these are the ones driven by tidal deformation of a star by its companion, the trailing bulge when spin and orbit are not synchronized, which creates internal friction, which dissipates AM into the structure of the star. This familiar picture is very useful to set before talking about dynamical tides because it highlights the role of **dissipation**. The tidal bulge is just a geometrical deformation, until all that potential energy has a mechanism through which it can be transmitted into stellar structure. A convective envelope has **turbulent viscosity** - convective plumes move on the scale of 1e10 cm, allowing AM to be moved across mass shells with large AM differentials; this is so efficient MESA effectively assumes convective regions are always rigidly rotating. A radiative envelope only has **radiative viscosity**, which operates on ~1 cm scales related to photon emission and reabsorption, transporting AM across a small region; and **molecular viscosity**, which relies on Coulomb interactions on even smaller ~1e-5 cm scales. Therefore, equilibrium tides are very inefficient on massive stars, not because they are not tidally deformed, but because there is no efficient mechanism for dissipation of that potential energy.

The stable, stratified structure of radiative envelopes, however, does allow for the development of **g-modes**. Radiative zones, by definition, do not allow convection to develop because a cell that is pushed up, rises, the expands in the lower-density environment, cools down more quickly with radius than its surroundings ($\nabla_\mathrm{ad}<\nabla_\mathrm{rad}$) and sinks back down. Its retained kinetic energy then causes it to overshoot its initial position, heat up more quickly than the higher-density environment, and rise again, oscillating in the local **Brunt-Väisälä frequency**. The cell moves material out of the way --- primarily in the horizontal direction --- and this propagation consists of a **gravity wave**. In a radiative zone, these gravity waves are bound to reach and be reflected by two boundaries: the convective zone boundary, which is opaque to gravity waves; and the stellar surface. This is a cavity, allowing only the establishment of standing waves, called the stars **g-modes**. g-modes typically have wavelengths smaller than the envelope scale ---- $10^7-10^9\,\mathrm{cm}$, compare $\mathrm{R}_\odot\sim10^{10}\,\mathrm{cm}$ --- allowing the development of significant temperature gradients along gravity waves, making them significantly **radiatively damped**. Damping brings the wave out of phase with the companion, thereby making it into a forced, damped oscillation with a non-zero torque on the mass element being forced. The dampening deposits AM along the way, but because the fluid is nearly incompressible, and because the density gradient presents a barrier to pushing fluid up, the oscillating element displaces surrounding fluid azimuthally. The resulting out-of-phase azimuthal compression waves efficiently allow for a tidal torque in radiative envelopes as long as the forcing frequency ($2\left|\Omega_S-\Omega_L\right|$) is greater than that of the fundamental mode. 

AM transport is important because both models are, in principle, active simultaneously in the core and the envelope, and radiative damping's dependence on the temperature gradient further implies it does not drive rotation uniformly, particularly in a radiative envelope where opacity peaks develop, and where the very surface where the waves break. In the absence of efficient AM transpot beyond convection, both tides and accretion tend to produce differential rotation.

Rotation and AM transport also directly connect to chemical mixing across radiative zones and through convective boundaries. Key for us are **(dynamical) shear**, acting within a differentially rotating radiative envelope and across the boundary with a convective core; and **Eddington-Sweet circulation**, acting across the radiative envelope. Strong shear generally disfavors ES circulation, meaning that the two modes of radiative envelope mixing are generally mutually exclusive in their most efficient instances. 

The final key ingredient is the presence or absence of **magnetic fields**, which can efficiently drive AM transport through the development of **Tayler-Spruit instabilities** along differentially rotating interfaces, which thereafter drive the structure towards rigid body rotation, suppressing shear mixing and favoring ES circulation. 


- Birth rotation
- massive stars going CHE
- tides
- effect of AM transport

The **MESA implementation** of AM transport/chemical mixing deserves to be explicitly described. For rotation, the treatment of chemical barriers needs to be directly explained if the intention is to elucidate the difference between accretion-induced CHE and CHE from ZAMS, as it strongly limits the possibility of driving a star CHE in the middle of the MS.