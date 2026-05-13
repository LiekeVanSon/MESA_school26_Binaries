---
title: Lab 2
author: Lucas de Sá (lead), Annachiara Picco, Mathias Fabry, Lieke van Son
weight: 3
math: true
toc: true
---

# Lab 2: Stellar Swinging

10:45 AM–12:00 PM
Timing: 10 min lecture + 1 hour MESA material

In the previous lab, we explored the occurrence of mass transfer in binaries, and saw its effects not only on the stellar mass, but also on its radius and on the orbital separation. Mass transfer is triggered by the expansion of stars in close enough orbits, and, expansion being a common feature of massive stellar evolution, is a key factor in binary evolution. This needs not be so, however, if even the most massive stars are *rotating*. Rotation can have dramatic effects in stellar evolution, including on the mass-radius relation, and as a consequence on the occurrence of mass transfer. In Lab 2, we will look at the effect of rapid rotation on the structure of $40-100\,\mathrm{M}_\odot$ stars and their BH products. Along the way, we will also learn how to add a brand new history column to our output.

(Part 1, before lunch)

## Chemically homogeneous evolution

*LUCAS: I'm worried this intro is still too long; I cut parts and put some in detail boxes for the curious, but even then I can do a second cutting pass with a bit more time; should I consider keeping the details boxes a risk? It would be better for no one to get too distracted...*

![TidalLocking](lab2/figures/intro0tidallylocked.gif)
A rapidly rotating star will become oblate due to the stronger centrifugal force felt in the equator (where the distance to the axis of rotation is greatest) relative to that felt towards the poles (where the distance shrinks to zero). That distortion leads to an relative excess of radiative flux towards the poles relative to the around the equator, meaning the star cannot simultaneously sustain thermal and hydrostatic equilibrium. The result is the development of internal large-scale currents throughout the radiative envelope, where material sinks to the center on the equator, and floats to the surface around the poles. This pattern, called **Eddington-Sweet (ES) circulation**, thoroughly mixes material in the envelope. Since the convective core is already chemically homogeneous, the result is what we call a **chemically homogeneously evolving**, or CHE, star. The time ES circulation takes to transport a mass element all the way from core to surface defines its timescale, which is roughly

$$\tau_\mathrm{ES} = \mathrm{\tau_\mathrm{KH}}{(\Omega/\Omega_\mathrm{c})^2},$$

where $\tau_\mathrm{KH}$ is the star's thermal timescale, $\Omega$ is its angular rotation speed (assuming rigid body rotation), and $\Omega_\mathrm{c}$ is its critical $\Omega$ (at which the centrifugal force equals gravity on the surface).

![Collapse stages of CHE evolution](lab2/figures/che_diagram1.png)

{{<details title="More on ES circulation" closed="true">}}
This rotation-induced difference in the distance to the center of mass means that the effective surface gravity, $g_\mathrm{eff}$, is greater at the poles than at the equator. Then, it follows from the von Zeipel theorem,

$$F_\mathrm{rad}\propto g_\mathrm{eff},$$

that the radiative flux is greater towards the poles than the equator. Because this makes the temperature gradient steeper towards the poles, and $\mathbf{F}_\mathrm{rad}\propto\nabla T$, we now no longer have $\nabla\cdot\mathbf{F}_\mathrm{rad}=0$ for a static solution, i.e., the star cannot simultaneously be in thermal and hydrostatic equilibrium. From energy conservation,

$$\rho T\mathbf{v}\cdot\nabla S=\rho\epsilon-\nabla\cdot\mathbf{F}_\mathrm{rad}.$$

Since no nuclear burning is taking place in the envelope, $\epsilon=0$, and the response to a non-zero flux divergence is the development of a velocity field. In concrete terms, on the poles rotation causes a negative flux divergence (the gas is being "boiled") and a centrifugal velocity field --- i.e., the gas rises towards the surface. On the equator, in contrast, the flux divergence is positive (the gas is being "cooled"), and the velocity field is centripetal --- the gas sinks.
{{</details>}}

As the star burns away hydrogen into helium in the core, this current keeps bringing up helium to the surface, and more hydrogen back to the core. If the circulation holds for the entire Main Sequence (MS), by the time hydrogen depletes in the core, the surface will also be hydrogen-poor, if not hydrogen-free, and you have a bare helium core, or He star, and are on the way to forming a Wolf-Rayet star. He stars are characteriscally compact, and therefore the defining feature of CHE star is that they remain compact during the MS and further contract afterwards. In the HR diagram, their tracks bend to the left (hotter), rather than right (cooler).

![Collapse stages of CHE evolution](lab2/figures/che_diagram2.png)

{{< details title="Is a He star not a Wolf-Rayet star?" closed="true">}}
Not always! While all Wolf-Rayet stars are He stars, Wolf-Rayet is a (mostly) well-defined collection of spectral types defined by the absence or near-absence of hydrogen lines, and by the presence of certain key emission lines from nitrogen, carbon and/or oxygen. Those lines are only excited at temperatures significantly higher than those characteristic of MS star surfaces - and therefore we should generally expect our star to spend at least some of its time as a He star with an O-type or O/WN spectrum. This last case, a "slash star", is a transitional type between the O-type and the coolest type of WR.
{{< /details >}}

Because $\tau_\mathrm{ES}\propto(\Omega/\Omega_\mathrm{c})^{-2}$ a CHE star needs to sustain a very high rotation rate through all of the MS. It is generally assumed that this is achieved through tidal forces: in a binary with period of a few days or less, tides are strong enough that we can assume the star is synchronized to the orbital period at birth. That orbital period itself being very short, the star will also be spinning with a short period.

In Lab 2, we will explore the conditions under which a star is able to evolve chemically homogeneously, and calculate the resulting black hole (BH) spins that can be expected from this kind of object. Assuming that rotation comes from tidal synchronization, we will vary the initial orbital period of a massive star binary, test what happens if a star is spun-up in the middle of the MS, compute BH spins, and try out variations of angular momentum transport mechanisms.

{{< details title="What about equations? And the non-rigidly rotating case?" closed="true" >}}

In the more general case, allowing for **differential rotation**, the neat picture of ES circulation breaks down. While we cannot explore the full theory of circulation in rotation stars here, in case you are curious, it is instructive to look at what changes in the equations for the circulation velocity between rigid-body and differential rotation. The full expression for the velocity of ES circulation can be broken down into a radial and a horizontal component, as

$$\mathbf{U} = U_2(r)P_2(\cos\vartheta)\mathbf{e}_r + V_2(r)\frac{\mathrm{d}P_2(\cos\vartheta)}{\mathrm{d}\vartheta}\mathbf{e}_\vartheta,$$

where $P_2$ are second-order Legendre polynomials and $U_2$ and $V_2$ are the radial and horizontal velocity amplitudes, respectively. For the radial amplitude, the full expression is

$$U_2(r) = \frac{P}{\bar{\rho}\bar{g}C_P\bar{T}(\nabla_\mathrm{ad}-\nabla+\frac{\phi}{\delta}\nabla_\mu)} \left[
    \frac{L(r)}{M(r)}(E_\Omega + E_\mu) + \frac{C_P}{\delta}\bar{T}\frac{\partial \Theta}{\partial t},
\right]$$

where the diverse quantities, including averages ($\bar{\rho}$, $\bar{T}$, etc.) are evaluated at mass shell of radius $r$, accounting for horizontal fluctuations. Radial motion can be driven by rotation, encoded in the $E_\Omega$ term, or chemical fluctuations, encoded in the $E_\mu$ term. The quantity $\Theta$ encodes density fluctuations, and is given by what is called the baroclinic equation,

$$\Theta:=\frac{\tilde{\rho}}{\bar{\rho}}=\frac{1}{3}\frac{r^2}{\bar{g}}\frac{\mathrm{d}\Omega^2}{\mathrm{d}r},$$

and thus, for rigid rotation, $\mathrm{d}\Omega/\mathrm{d}r=0\to\Theta=0$. If the star is also chemically homogeneous along each mass shell, then $E_\mu=0$. This is the assumption in MESA, and physically justified by the presence of strong horizontal turbulence. By expanding $E_\Omega$ and including a correction for the importance of radiation pressure, the expression for the radial velocity becomes

$$U_2(r)=\frac{16}{9}\frac{\beta}{32/3-8\beta-\beta^2} \frac{L(r)r^2}{GM_r^2} \frac{1}{\nabla_\mathrm{ad}-\nabla+\frac{\phi}{\delta}\nabla_\mu}\frac{\Omega^2r^3}{GM_r},$$

where $\beta=P_\mathrm{gas}/(P_\mathrm{gas}+P_\mathrm{rad})$. Since in a radiative zone (or a semiconvective zone) $\nabla_\mathrm{ad}-\nabla+\frac{\phi}{\delta}\nabla_\mu>0$, $U_2(r)$ is strictly positive across our envelope. Plugging it back into the first equation and accounting for the sign of $P_2$ yields the neat picture: matter rises towards the poles, sinks at the equator.

Conversely, any significant departure from these specific conditions: chemically homogeneous, radiative, rigid-body rotation, reintroduces terms that can have a negative sign into the expression for $U_2$. For differential rotation, this comes back through the time derivative of $\Theta$, which itself goes with $\mathrm{d}\Omega^2/\mathrm{d}r$. The circulation then can, and does, stall and even reverse as a function of radius. 

Since MESA adopts a diffusive picture for every mixing process, this means it cannot naturally adapt this *advective* part of rotational mixing, which can potentially go either with or against the chemical gradient. This is a known limitation, and how to model rotational mixing, and to what extent the diffusive approach is a limitation, is an active topic of debate in stellar evolution. For our lab, we are far more concerned with large-scale, mean effects of rotation, and generally staying in the rigid-body regime, and the diffusive approach is adequate for our regime. If you are curious, you can find the full treatment in Zahn; Maeder 2009. *LUCAS: I don't have Zahn at hand atm, if I forgot to fix the reference please remind me!*

{{< /details >}}

*LUCAS: looking at this now and at previous labs, I don't think I can fit a theory of 1D implementation of mixing processes here.  I could still put it in slides and explain it live. We should settle this with the labs in hand.*

## Step 1: starting in *close position*, or CHE stars in the MS
![ClosePosition](lab2/figures/step1close.gif)

We have seen that that the timescale of ES circulation depends primarily on the mass (through the thermal timescale) and the rotation rate of our stars. Assuming that tidal forces are the source of that rotation, let's put our massive stars in a short-period binary like we did in Lab 1 and see what combinations of mass and orbital period produce CHE. 

> [!Note]
> To get started, create a work folder, `lab2work`, somewhere convenient. Inside, make a copy of the `binary/work` folder and name it `binary_model`, like you did in Lab1, and then copy the contents of [/static/thursday/lab2/](/static/thursday/lab2/lab2work) folder to it and let them overwrite. The `initial_model` contains a basic single star setup to generate our ZAMS models. In `binary_model`, the inlists contain most of the settings for our runs, and the `.list` files necessary output. The `src/run_star_extras.f90` contains a custom implementation of stellar winds geared towards CHE stars. We will later go back to the extras file. By the end of this lab we would like to have run a CHE star star binary to helium depletion, which is no easy task for a single lab's time on two cores. In the first part of the lab, you will learn some useful settings to make this achievable.

With your work folder setup, choose one of the following masses for your stars, which you will carry through to the end of the lab. More massive stars take longer to run, so pick based on how your computer performed in previous labs! 

| $M_1/\mathrm{M}_\odot$ |
| :--------------------- |
| 40 |
| 70 |
| 100 |
| 300 |

You will first generate the ZAMS model for your binary. Go into `initial_model` and find the correct mass setting in `inlist_project`, then compile (`./mk`) and run (`./rn`). This run should take a few seconds. Note down the radius of your star at ZAMS from the terminal output, then copy the produced `zams.mod` to the `binary_template` folder.

{{<details title="Solution" closed="true">}}
Add to `inlist_project`,
```fortran
&controls
    initial_mass = ! your mass
```
{{</details>}}

CHE stars in binaries are amenable to being treated as twins because they are generally expected to have close masses (when tides are strongest) and suffer near net-zero mass transfer (being compact). We will leverage that fact to cut our runtime in half by solving the primary's structure only, and telling MESA to treat the secondary as if it were identitical to the primary. Relative to simply solving the primary as a single star, running it in a binary with a twin keeps the effect of tides and accounts for both stars' mass-loss in computing the orbital evolution.

*LUCAS: I can't really spend time explaining why no mass transfer twins is a reasonable assumption for CHE, so I stated it; I could not even mention it and go ahead with twin modeling as a computational speed expediency*

We will manually adapt the setup in `binary_model` to evolve our stars as twins. MESA already has a setting for this, which you will be able to find in the inlist defaults.

> [!Warning]
> Even when you set the stars to be treated as twins, you must explicitly set the secondary to have the same mass as the primary. Otherwise, an implementation quirk will make it so that their mass is not the same at startup, and you will get spurious behavior.

The `inlist_star` file is already set up for a CHE star and to load `zams.mod` as a starting model. In `inlist_project`,
1. Point the primary to `inlist_star`, and set the secondary to have the same starting mass as the same mass as the primary.
{{<details title="Solution" closed="true">}}
Add 
```fortran
&binary_job
   inlist_names(1) = 'inlist_star' 
```
and
```fortran
&binary_controls
    m2 = ! your chosen mass
```
{{</details>}}
2. Tell MESA to set the stars as twins in the initial model.
{{<details title="Solution" closed="true">}}
Add
```fortran
&binary_job
   change_initial_model_twins_flag = .true.
   new_model_twins_flag = .true. 
```
{{</details>}}
3. MESA has flags to ignore mass transfer inside a binary. Do you need to manually turn them on?
{{<details title="Solution" closed="true">}}
You can find those controls in `binary_job.defaults` as
```fortran
change_ignore_rlof_flag = .false.
change_initial_ignore_rlof_flag = .false.
new_ignore_rlof_flag = .false.
```
But if you trace through the calls to `new_model_twins_flag` with `grep -rin new_model_twins_flag` within `binary/private`, you will find that this flag gets passed within `binary/private/run_binary_support.f90` to a subroutine named `set_model_twins_flag`. This subroutine is defined in `binary/private/binary_utils.f90` as
```fortran
      subroutine set_model_twins_flag(binary_id, model_twins_flag, ierr)
         integer, intent(in) :: binary_id
         logical, intent(in) :: model_twins_flag
         integer, intent(out) :: ierr

         type (binary_info), pointer :: b

         ierr = 0
         call binary_ptr(binary_id, b, ierr)
         if (ierr /= 0) return

         b% model_twins_flag = model_twins_flag

         ! also need to set ignore_rlog_flag to true
         if (model_twins_flag) then
            call set_ignore_rlof_flag(binary_id, .true., ierr)
            if (ierr /= 0) return
            call set_point_mass_i(binary_id, 2, ierr)
         end if
      end subroutine set_model_twins_flag
```
So we do not need to set the `ignore_rlof` flags manually.
{{</details>}}

Our last piece of setup is to choose an initial orbital period for our binaries. This is where the ZAMS radius of your star comes in --- it roughly sets the lower initial period separation as 

$$\frac{P_{\min}}{\mathrm{d}}=\frac{0.07449}{\sqrt{M_1+M_2}}\left(\frac{R_1}{\mathrm{R}_\odot}\right)^{3/2}.$$

Regardless of your chosen mass, CHE is always achievable somewhere below $2\,\mathrm{d}$. Within this period range, you will now find an initial $P$ that leads to CHE from the table below, which you will carry to the further parts of the lab. Even when one of your runs fails to go CHE, watch the pgplot window and take note of the termination code. There is also physics in why stars do *not* go CHE.

| $P_\mathrm{orb}/\mathrm{d}$ | $P_\mathrm{orb}/\mathrm{d}$ |
| :-------------------------- | :-------------------------- |
| 0.90 | 1.50 |
| 1.00 | 1.60 |
| 1.10 | 1.70 |
| 1.20 | 1.80 |
| 1.30 | 1.90 |
| 1.40 | 2.00 |

*LUCAS: removing the period exploration and instead giving fixed m1,p pairs to students is an easy way to leave more time for later exercises*

Now follow the instructions below,

1. Recall the definition of $\tau_\mathrm{ES}$. How close to your choosen mass's $P_{\min}$ do you think your $P_\mathrm{max}$ is? Do you expect $P_{\max}$ to vary much across the mass range?

{{<details title="Solution" closed="true">}}
This question is not about precise number, but rather about developing intuition for the timescale of ES circulation. It is proportional to the thermal timescale, which is shorter for more massive stars, divided by the rotation rate. Therefore, the more massive star, the more it can get away with slower rotation while still developing fast mixing. Because of this, you can expect $P_{\max}$ to increase with stellar mass and move away from $P_{\min}$. The allowed period range widens with growing mass.
{{</details>}}

2. Choose an initial period in days and set it in `inlist_project`.

{{<details title="Solution" closed="true">}}
Nothing changes from Lab 1 here. Simply include
```fortran
&binary_controls
    initial_period_in_days = ! your choosen period
```
{{</details>}}

3. Watch the pgplot window, in particular the HR diagram and the diffusion coefficient plot. Is your star behaving differently from a non-rotating MS star in the HR diagram? What does each diffusion coefficient represent, and how do different mixing modes contribute to mixing from center to surface? Can you tell just from watching them whether your star is going homogeneous or not?  
{{<details title="Solution" closed="true">}}
If your star is going CHE, as we saw in the introduction, it should move blue-wards in the HR diagram (to the high temperatures, to the left) for almost the entire MS, indicating very little to no expansion. If it starts moving to the right, MESA will stop the run very soon due to it not going CHE. This is the effect of the lower electron scattering opacity of helium we mentioned before.

In the diffusion panel, you should be able to find the convective core (dominated by $D_\mathrm{conv}$) and the overshooting layer above it ($D_\mathrm{ovr}$). Everything above it is the radiative envelope, which, if your star is going CHE, is dominated by the ES circulation ($D_\mathrm{ES}$). The large scale picture is: the core is mixed by convection, the envelope by ES circulation, and the two are connected by convective overshooting.

If your star does not go CHE, you should be able to spot a narrow strip above the overshooting region where $D_\mathrm{ES}$ drops to zero before MESA even stops the run, chemically disconnecting core and envelope.
{{</details>}}

4. If your run is stopped before reaching the end of the MS, note the termination message. What was the reason? This should tell you whether you need to move the period up or down.

{{<details title="Solution" closed="true">}}
There are only a few termination messages you should be able to get in a stable run. If you see `Terminate due to primary not evolving homogeneously`, that means your star is not spinning rapidly enough and needs to be in a closer orbit. If you see `termination code: Terminate because of overflowing initial model` (or L2 overflow), it means your stars are so close they would have undergone an episode of likely unstable mass transfer and merged; in this case, you need a wider orbit.
{{</details>}}

> [!Warning]
> Regardless of mass, a succesful MS CHE run is not supposed to take more than 8 minutes, potentially no more than 3 min for the low masses. If you picked one of the higher masses and find yourself waiting for longer than this, try a lower mass. 

{{<details title="Solution" closed="true">}}
If you are having trouble, some reliable settings to get CHE are:
| $M_1/\mathrm{M}_\odot$ | $P_\mathrm{orb}/\mathrm{d}$ |
| :--------------------- | :-------------------------- |
| 40 | 1.00 |
| 70 | 1.20 |
| 100 | 1.50 |
| 300 | 1.80 |
{{</details>}}

Note that MESA still tracks the Roche lobe geometry even as the mass transfer rate is set to zero. This is what allows us to compute stellar structure only once while still self-consistently tracking the occurence of Roche lobe or L2 overflow. 

> [!Bonus]
> If you are following the mass-loss rate plot, specially if you picked a greater mass, you might notice it suddenly starts to increase, and the uptick in mass-loss causes your star to dip down in luminositny sharply. Unfortunately, we will not have time in our lab to go in-depth into stellar winds, but this behavior is a direct consequence of the inclusion of MS optically-thick winds in our setup, which are normally characteristic of very massive stars ($\gtrsim100\,\mathrm{M}_\odot$), but can get triggered at lower masses for CHE. As a bonus exercise, you may try later to figure out why that is so by looking at the `wyoming_wind` subroutine implemented in the `run_star_extras`.

By the end of this step, you should have an initial mass, orbital period pair that leads to CHE across the MS, which you will keep for the next exercises.

> [!Bonus]
> If you already found the M,P pair you will from the tabulated values, and still have time, you can also try to map out exactly the $P_{\min}-P_{\max}$ range for your mass! For some masses you might have to go above the tabulated periods. Remember that for the next steps you should use a pair from the tabulated values only.

---

## Step 2: do the *rock step*, or post-MS
![SpinningUp](lab2/figures/step2rock.gif)


Besides BH masses, BH spins also are a key quantity that is imprinted in GW signals and can help lift degeneracies between BH formation channels that, in pure terms of mass, populate the same range of the mass spectrum. As rapidly rotating stars, CHE stars are natural candidates for producing high-spin BHs, which would stand out for the current, low-spin-dominated, population of merging BBHs. In order to get a more accurate estimate of the BH spins produced by CHE stars, we will now take one of our models from the previous sessions, and run it up to helium depletion.

Fortunately, MESA makes it very easy for us to keep going from where stopped in the previous step, instead of having to start over. It is always possible to simply restart the run from the last photo by calling `./re`, which will them continue the run from a precise snapshot of where it had previously stopped, loading up any changes we make to the inlists and extra files. We will restart the run from the end of the MS and let it continue until helium is depleted in the core, alongside some other adjustments.

1. If we change nothing, this will of course let the run stop exactly where it had already stopped before, so you should change the stopping condition to He depletion.

{{<details title="Solution" closed="true">}}
In `inlist_star`, change
```fortran
xa_central_lower_limit_species(1) = 'h1'
xa_central_lower_limit(1) = 1d-5
```
to
```fortran
xa_central_lower_limit_species(1) = 'he4'
xa_central_lower_limit(1) = 1d-5
```
{{</details>}}

2. Add the "dynamo" plot to the middle column so that we can see the evolution of the internal angular momentum profile.

{{<details title="Solution" closed="true">}}
Where we had the "abundance-power-mixing" plot we should now have
```fortran
Grid2_plot_name(3) = 'Profile_Panels4'
Profile_Panels4_title = 'Abundance-Power-Mixing-Dynamo'
Profile_Panels4_num_panels = 4
Profile_Panels4_yaxis_name(1) = 'Abundance'
Profile_Panels4_yaxis_name(2) = 'Power'
Profile_Panels4_yaxis_name(3) = 'Mixing'
Profile_Panels4_yaxis_name(4) = 'Dynamo'
```
{{</details>}}


3. Restart your run with `./re`. Closely watch the HR diagram, the Kippenhahn diagram, the angular momentum plot and the tidal synchronization timescale. How does your star behave? Would it be accurate to say that it never expands at all? Take the time to compare your results to neighbors running different masses, both during and after the MS. Do their tracks look very different from yours?



{{<details title="Solution">}}

As you watch your star evolve post-MS, for the lower masses you will notice a very brief phase of expansion, evident by a short hook towards towards the top-right in the HRD. This is a very brief back-and-forth excursion into larger radii (like a rock step). Do you have an idea for why that is happening? And what evolutionary phases does it correspond to?

The Kippenhahn diagram reveals the connection between the external behavior and the internal dynamics clearly. There is an initial phase of contraction of the whole star, once it loses support from core hydrogen burning, until a layer around the He core becomes hot and dense enough to ignite hydrogen - this is the hydrogen shell burning phase. During shell burning, the envelop responds to further core contraction by expanding, keeping the shell burning rate constant. This is the so-called "mirror effect" of shell burning, which you might have already met in a stellar structure class.

Eventually, the core does ignite helium and stops contracting. At this point the envelope contracts again, and the star continues to contract as helium is burned. The "hook" feature makes it very easy to identify H shell ignition and He core ignition, when it is present.

{{</details>}}

4. Has the angular momentum profile of your star changed at all by the end of the run? Comparing with your neighbors, you might find that the answer depends quite a bit on your mass. The initial shape of the profile is characteristic of rigidly-rotating bodies. Does your star retain that shape, meaning all layers are rotating with the same angular velocity, or does the profile deform, developing *differential rotation*? --- different layers rotating with different $\omega$?
{{<details title="Solution" closed="true">}}
If you compare, you should see that only more massive stars develop differential rotation. This is because the driver of differential rotation is wind mass-loss, which only spins down the surface. More massive stars have higher mass-loss rates, and therefore are able to develop differential rotation.

You should see that the tidal synchronization is growing by orders of magnitude while the mass loss rate is continuing to rise. The 'p_orb_div_p_rot_1' column in pgplot will tell you whether your star's spin period is shorter or longer than the orbital period, but at any rate the synchronization timescale becomes so long that the wind mass-loss becomes the dominant source of torque, and they always spin the star down.
{{</details>}}

The development of differential rotation is limited by any form of angular momentum transport inside the star, which will try to redistribute angular momentum away from areas spinning more rapidly to those spinning more slowly. By default, we have worked since the beginning with the *Tayler-Spruit dynamo*, which for a wide range of masses is enough to keep the star rigidly rotating to the end of helium burning.

More crucially for BHs, wind mass-loss only spins down the surface of the star, but not the core, which will eventually be the seed for BH formation. Post-MS, the core is already spinning more rapidly than it was at the end of the MS due to conservation of AM and its post-MS contraction, and therefore it needs to rely on wind mass loss to spin-down. This will only be effective if AM is being efficiently transported from core to surface, which will be the topic of the last part of this lab.

## Step 3: *open position* into *underarm twirl*, or the He core spin
![OpenPosition](lab2/figures/step3underarm.gif)

In this last part, we will use the mass and spin of our CHE stars at the end of helium burning --- by which point they are all naked He cores --- to estimate the produced BH masses and spins under different prescriptions for angular momentum transport. The BH dimensionless spin parameter, $\chi$ (sometimes $a$), is defined as 

$$\chi:=\frac{cJ}{GM^2},$$

and takes on values between $0$ and $1$. Our first task will be to implement a new history column through `run_star_extras` named `chi_he_core` that will track this parameter for the He core. While our CHE stars are already all He core (such that the core mass and spin are simply the total mass and spin), explicitly looking for the He core boundary will allow the same column to be used for stars with a hydrogen envelope later.

{{<details title="Why $0<\chi<1$?" closed="true">}}

The motivation for comes from solving Einstein's equations for the general case of a BH with mass $M$, angular momentum $J$ and electric charge $Q$ (this is called a Kerr-Newman solution). Demanding that the solution include an event horizon around the singularity yields the condition

$$\frac{Q^2}{4\pi\epsilon_0} + \frac{c^2J^2}{GM^2}\leq GM^2.$$

The hypothesis that Nature does not produce so-called *naked singularities* is called the Cosmic Censorship hypothesis and is tacitly assumed everywhere when $\chi<1$ is imposed. This is a hard constraint on the three numbers that fully define a BH (that the three numbers $M$, $J$, $Q$ suffice is called the No Hair Theorem). Further defining,

$$\chi:=\frac{cJ}{GM^2}\leq1,$$

also encodes the assumption that the BH is electrically neutral, which follows reasonably from stellar evolution.
{{</details>}}

For implementing a new column in `run_star_extras`, we will rely on a few quantities that are already internally computed in mesa and available through a `star_info` object, instantiated as `s`. Scalar quantities stored in `s` can be recovered as `s% property_name`, while arrays can be recovered as `s% array_name(index or indices)`. The available properties are listed in `star_data\public`. 

> [!Note]
> MESA arrays run from the surface to the center. The index of the innermost "shell" corresponds to the total number of zones into which the star is divided, which is stored as `s% nz`. Fortran arrays can be sliced as `array(index1:index2)`. 

For calculating physical quantities, MESA already includes a large collection of physical constants in CGS in the `const_def` library. This library is already imported by default in `run_star_extras` and its constants, which you can find in `const/public/`, can be used directly. 


1. Let's first make sure we understand how to get properties at the He core boundary. MESA already finds and stores information about the boundary for us, so to start we just want to note down how to get the numbers we need to compute $\chi$. Browse through `star_data/public` to find them. Keep an eye out for any quantities that are not stored in CGS; these cases are highlighted explicitly.
{{<details title="Hint" closed="true">}}
Try running `grep -rin he_core` inside `star_data/public`.
{{</details>}}
{{<details title="Solution" closed="true">}}
We find in `star_data/public/star_data_step_work.inc` the list of available quantities computed by MESA at the He core boundary,
```fortran
! abundance boundaries

real(dp) :: he_core_mass ! baryonic (Msun)
real(dp) :: he_core_radius ! Rsun
real(dp) :: he_core_lgT
real(dp) :: he_core_lgRho
real(dp) :: he_core_L ! Lsun
real(dp) :: he_core_v
real(dp) :: he_core_omega ! (s^-1)
real(dp) :: he_core_omega_div_omega_crit
integer :: he_core_k ! boundary is in this cell
```
While the mass is there, we are missing angular momentum. We have, however, the index at the core boundary, meaning we could compute it if we had the angular momentum profile. 

Note also that `he_core_mass` is in Msun, not grams. We can convert it to the CGS by multiply it by `Msun` later.
{{</details>}}
2. While the He core mass is already available, we will need to compute the He core total angular momentum ourselves by integrating the *specific* angular momentum from the center to the He core boundary,
$$J_\mathrm{He} = \int_0^{M_\mathrm{He}}j_\mathrm{rot}\,\mathrm{d}m.$$
Look for the necessary arrays again in `star_data/public`.
{{<details title="Hint" closed="true">}}
Try running `grep -rin "angular momentum"` inside `star_data/public`.
{{</details>}}
{{<details title="Solution" closed="true">}}
The specific angular momentum array is defined in `star_data/public/star_data_step_input.inc`,
```fortran
! rotation
real(dp), pointer, dimension(:) :: j_rot ! (nz)
! j_rot(k) is specific angular momentum at outer edge of cell k; = i_rot*omega
```
While the $\mathrm{d}m$ array --- here, the mass per shell --- is in `star_data/public/star_data_work_input.inc`
```fortran
real(dp), pointer :: dm(:)
! dm(k) is baryonic mass of cell k
! dm(k) = s% dq(k)*s% xmstar
```
{{</details>}}

3. Knowing which variables to call on, add the `chi_he_core` column through `run_star_extras.f90`. Remember to look for constants in `const/public` if you need them.
{{<details title="Hint 1: constants" closed="true">}}
You will use `clight` and `standard_cgrav` for constants. Remember that the constants, specific angular momentum and masses are already in CGS! 
{{</details>}}
{{<details title="Hint 2: integration" close="true">}}
Since MESA discretizes stellar structure, your integral will be a sum over the product of the `j_rot` and `dm` arrays. Element-wise array products are implemented in `math_lib` with `dot_product`, and array slices can be taken as `array(i1:i2)`. 
{{</details>}}
{{<details title="Solution" closed="true">}}
You must first tell MESA to expect one more extra column that it already has.
```fortran
   integer function how_many_extra_history_columns(id)
      integer, intent(in) :: id
      integer :: ierr
      type (star_info), pointer :: s
      ierr = 0
      call star_ptr(id, s, ierr)
      if (ierr /= 0) return
      how_many_extra_history_columns = 2
   end function how_many_extra_history_columns
```
Then you can name that column and add the computed spin value. Your final implementation should look approximately like this.
```fortran
   subroutine data_for_extra_history_columns(id, n, names, vals, ierr)
      integer, intent(in) :: id, n
      character (len=maxlen_history_column_name) :: names(n)
      real(dp) :: vals(n)
      integer, intent(out) :: ierr
      real(dp) :: dt, chi_he_core, J_he_core
      type (star_info), pointer :: s
      ierr = 0
      call star_ptr(id, s, ierr)
      if (ierr /= 0) return
      
      ! note: do NOT add the extras names to history_columns.list
      ! the history_columns.list is only for the built-in history column options.
      ! it must not include the new column names you are adding here.
      
      dt = dble(time1 - time0) / clock_rate / 60
      names(1) = 'runtime_minutes'
      vals(1) = dt

      ! NEW
      if (s% he_core_k == 0) then
         ! no He core yet
         chi_he_core = 0d0
      else
         J_he_core = dot_product(s% j_rot(s% he_core_k : s% nz), &                                                                                              
                                 s% dm(s% he_core_k : s% nz))
         chi_he_core = clight * J_he_core / (standard_cgrav * s% he_core_mass * s% he_core_mass * Msun * Msun)
      end if

      names(2) = 'chi_he_core'
      vals(2) = chi_he_core

   end subroutine data_for_extra_history_columns
```
{{</details>}}

Once you have included your new column, go ahead and recompile MESA by running `./mk` in your work folder. Remember you have to do this everytime you change any files inside `src/`. If you run into errors while compiling and are not sure what you did wrong, don't hesitate to ask for help!

![Collapse stages of CHE evolution](lab2/figures/che_diagram3.png)

For the last MESA run of this lab, we would like to test the effect on the final spins of different AM transport mechanisms. We will do this by changing the prescription, adding our new `chi_he_core` column to the text summary in pgplot, and running a small crowd-sourced exercise at the end of the lab. To add the column to the text , modify the `&pgstar` settings in `inlist_star`.
{{<details title="Solution" closed="true">}}
Luckily the last row on column 4 is free, so it is enough to add,
```fortran
Text_Summary1_name(8,4) = 'chi_he_core'
```
{{</details>}}

For the TS dynamo, we can turn it off or apply a flat intensity modifier through the `am_nu_TS_factor` control in `inlist_star`. After opening your `run_star_extras`, you might have noticed the following line 

```fortran
s% other_am_mixing => TSF_Fuller_Lu22
```

While based on the fundamental physical mechanisme (the Tayler instability), the AM transport model by Fuller & Lu (2022) is significicantly stronger than the standard TS dynamo. To turn it on, we must modify `inlist_star` so that

```fortran
&controls
am_nu_ST_factor = 0
use_other_am_mixing = .true.
```

Note that pointing the `other_am_mixing` hook is necessary in `run_star_extras` for `use_other_am_mixing` (as is already done) to have an effect. 

Regardless of your stellar mass, you can now choose one of four AM transport alternatives to implement (or keep). Again, try to coordinate so that you and your neighbors pick different ones. All variations except No TS should take roughly the same amount of time, for a given mass, but even No TS should take at most an extra minute to run. The model tag will be used later.

| AM transport model | Model tag | Settings |
| :----------------- | :-------- | :------- |
| No TS | nu0 | `am_nu_ST_factor=0`, `use_other_am_mixing=.false.` |
| 0.1x TS | nu01 | `am_nu_ST_factor=0.1d0`, `use_other_am_mixing=.false.` |
| 1x TS | nu1 | `am_nu_ST_factor=1.0d0`, `use_other_am_mixing=.false.` |
| FullerLu | fullerlu | `am_nu_ST_factor=0`, `use_other_am_mixing=.true.` |

Because we are changing fundamental physics, this time we will have to restart the entire run from ZAMS, which you can do by simply calling `./rn`. Expect that the run will take at least 10 minutes, which you can use to read ahead on the final crowd-sourcing exercise, or discuss your results with your colleagues.

> [!Warning]
> The entire run should still take 10 to 15 minutes, most of it spend in the MS. If you notice your run is past 10 minutes and your star still has not reached hydrogen depletion (check the center_h1), ask for someone to have a look. For the next step you can always use the final profile from step 2, which corresponds to the 1x TS model.

Once your run is concluded, you might find that $\chi>1$, but that should not be possible! How do you interpret that?

{{<details title="Solution" closed="true">}}
The direct reason why we are able to find $\chi>1$ is, of course, that we do not actually have a $\chi>1$ BH. We have a $\chi>1$ He core, which is very far from a relativistic regime. What we are finding is more precisely put as: if all the mass and angular momentum in this He core were to turn into a BH, it would have $\chi>1$. If that is assumed not to happen in Nature, then the conclusion is that *not all* the mass and angular momentum can actually make it into the eventual BH.
{{</details>}}

Regardless of what $\chi$ you find, this is only a very rough approximation for what kind of BH will eventually be produced. We can do one better by accounting for the AM structure of the star.

# Step 4: now switch partners! or crowd-sourcing BH spins
![CrowdDancing](lab2/figures/step4crowd.gif)

The *innermost stable circular orbit* around a BH is the highest AM orbit matter can enter around a BH without going over the speed of light, and the truncation radius of an accretion disk. If we assume that the innermost $2.5\,\mathrm{M}_\odot$ of our star (roughly the maximum neutron star mass) form a seed BH upon core-collapse, we can walk inside-out through the mass shells outside that seed, and ask each one: is the specific AM $j$ of this shell greater than the corresponding $j_\mathrm{ISCO}$, assuming an orbit around all the mass below?

![Innermost stable circular orbit, rotating x nonrotating BH](lab2/figures/isco_rxte.jpg)
*Credit: NASA/CXC/M.Weiss*

Anywhere where $j/j_\mathrm{ISCO}>1$ *cannot* be accreted onto the BH without losing AM first and is likely to settle into a disk before being accreted or *ejected*. While we cannot simulate a disk, we can estimate the *prompt* BH mass and spin, by including only for the layers that can be accreted without extra AM loss. In order to do this, we start at the layer enclosing $2.5\,\mathrm{M}_\odot$, and find the first layer above it where $j/j_\mathrm{ISCO}=1$. Everything between the two can be added to the seed BH. This breaks any sort of trivial mapping between the stellar spin and the BH spin, and as we will see in the final plot, across multiple masses and AM transport models, it is not trivial to form a highly-spinning BH from a highly-spinning star!

A collab notebook has been prepared in order to compute that mass and show you the $j/j_\mathrm{ISCO}$ of all your final models in this Drive folder. Please rename your last profile.data file according to the instructions.

> [!Naming]
> In order to create labels, the notebook reads your physical settings from the file name. The file you upload should be named `NAME_mX_AMy.data`, where you should replace `NAME` with your name, `X` with your mass (integer) and `y` with your AM transport model tag from the table above. For example, f I ran the $70\,\mathrm{M}_\odot$ star with the 1x TS AM transport model, I would upload my last profile with the name `lucas_m70_AMnu1.data`.

After uploading your profile, you can try running the notebook online. It should automatically pickup your file (if not, check the naming), add it to $j/j_\mathrm{ISCO}$ plot, and compute the prompt mass and spin. How would you explain the emerging patterns over mass and AM transport?

*LUCAS: below is a very wip example of the crowd source plot*

![Crowd-sourcing example](lab2/figures/bh_spins_v2_isco.png)

## Conclusions

By the end of this lab, we have encountered first-hand the most dramatic difference between CHE and non-CHE stars --- their compactness, driven by rotation-driven Eddington-Sweet circulation ---, and how post-MS evolution can decouple the surface and core rotation rates.  We have also learned how to compute the BH spin corresponding to a He core, and how that assumption does not trivially hold. As we will return to in Lab 3, accretion can also spin stars up, but under very different circumstances from CHE, and the stellar-BH spin connection remains a fresh  topic.