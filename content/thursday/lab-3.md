---
title: Lab 3
author: Annachiara Picco (lead), Matthias Fabry, Lucas de Sá, Lieke Van Son
weight: 4
math: true
toc: true
---

# Lab 3: Stable relationships

## Introduction

In this last minilab3 we will pick up on the system you evolved in minilab1 and follow its further evolution into a double black hole binary. Remember that at the end of your minilab1 you had two systems: 
- One system underwent mass transfer during the Main Sequence (Case A mass transfer), with final properties listed in the below [Table 1](#table-binary).
- The other underwent mass transfer after the Main Sequence (Case B mass transfer), with final properties as in [Table 2](#table-caseB).

<div style="display: flex; justify-content: center; margin-bottom: 2rem; margin-top: 2rem;">
<table id="table-binary" style="margin:auto; text-align:center;">
  <tr>
    <th></th>
    <th>Primary (Stripped star)</th>
    <th>Secondary (Accretor)</th>
  </tr>
  <tr>
    <td>Mass</td>
    <td>16.8 M☉</td>
    <td>39.6 M☉</td>
  </tr>
  <tr>
    <td>Ω / Ωcrit</td>
    <td>0.02</td>
    <td>0.15</td>
  </tr>
  <tr style="background: rgba(246, 171, 59, 0.22);">
    <td>Orbital Period</td>
    <td colspan="2" style="text-align:center;">4.5 days</td>
  </tr>
  <tr>
    <td>Mass ratio</td>
    <td colspan="2" style="text-align:center;">0.42</td>
  <tr>
  <td>Final model</td>
  <td>
    <a href="static/thursday/lab3/final1_caseA.mod" download>
      <code>final1_caseA.mod</code>
    </a>
  </td>
  <td>
    <a href="static/thursday/lab3/final2_caseA.mod" download>
      <code>final2_caseA.mod</code>
    </a>
  </td>
</tr>
<caption id="table-binary"><strong>Table 1:</strong> CASE A binary at the end of minilab1.</caption>
</table>
</div>

<div style="display: flex; justify-content: center;">
<table id="table-binary" style="margin:auto; text-align:center;">
  <tr>
    <th></th>
    <th>Primary (Stripped star)</th>
    <th>Secondary (Accretor)</th>
  </tr>
  <tr>
    <td>Mass</td>
    <td>17.14 M☉</td>
    <td>40.8 M☉</td>
  </tr>
  <tr>
    <td>Ω / Ωcrit</td>
    <td>?</td>
    <td>?</td>
  </tr>
  <tr style="background: rgba(246, 171, 59, 0.22);">
    <td>Orbital Period</td>
    <td colspan="2" style="text-align:center;">32.2 days</td>
  </tr>
  <tr>
    <td>Mass ratio</td>
    <td colspan="2" style="text-align:center;">0.42</td>
  <tr>
  <td>Final model</td>
  <td>
    <a href="/files/final1_caseB.mod" download>
      <code>final1_caseB.mod</code>
    </a>
  </td>
  <td>
    <a href="/files/final2_caseB.mod" download>
      <code>final2_caseB.mod</code>
    </a>
  </td>
</tr>
<caption id="table-caseB"><strong>Table 2:</strong> CASE B binary at the end of minilab1.</caption>
</table>
</div>

Both these systems have a rapidly rotating (spun-up) secondary that has accreted a lot of mass from the primary; it is, therefore, "rejuvenated" (fresh fuel has prolonged its Main Sequence lifetime), and is happily burning hydrogen (H) in its core. The primary, on the other hand, has already depleted helium (He) in its core and has been "stripped" off its H-rich envelope. 

> [!Important]
> Notice that the Case A system has a much lower orbital period than the Case B. These different post-mass transfer properties determine a different further evolutionary history!
> In this minilab3, we will understand how **both** types of binaries need to evolve in order to form gravitational wave sources such as merging binary black holes.


## 1. Stable mass transfer

Let's start by copying the standard work directory from ```$MESA_DIR``` to your preferred local folder:

```bash
cp -r $MESA_DIR/binary/work stable_MT
cd stable_MT
```

Inspect your ```inlist_project``` and pay attention to the following two controls:

- **`evolve_both_stars`** When false, MESA will model just one star, and keep the other as a point mass, while solving for the full orbital evolution of the binary. This is convenient for binaries with compact objects, like black holes (BH). You can find more info in here: `$MESA_DIR/binary/defaults/binary_job.defaults`

- **`limit_retention_by_mdot_edd`** When true, the accretion rate of material onto the point-mass companion will be capped to a physical limit, called "Eddington limit". This is because the infall of hot stellar material onto a compact object creates radiation pressure that may halt the accretion process. In this case, the excess transferred mass is ejected from the binary with the specific angular momentum of the point mass. You can find more info in here: `$MESA_DIR/binary/defaults/binary_controls.defaults`

As you can see, our simulation is already set up to model one of the components as a point mass with Eddington limited accretion. Ideal starting point for us to model a binary with a BH.

### Building the setup

Now we will perform some adjustments to the template. A significant number of these are meant to make the simulation faster in order to be efficiently computed in the duration of this lab.

#### Modify `history_columns.list` 
Grab the `history_columns.list` file from `$MESA_DIR/star/defaults` and copy it into your work folder:

```bash
cp -r $MESA_DIR/star/defaults/history_columns.list .
```

We will add an option to this file to visualize the quantities in the Kippenhahn diagram in the `pgstar` window. Search through this file for the string `mixing_regions`. Add below:

```fortran
mixing_regions 10

```

#### Modify `binary_controls` in `inlist_project`

By default MESA also includes the effect of magnetic braking for angular momentum loss. This implementation is meant for late type stars and should be removed when working with massive binaries. Additionally, by default MESA reduces the growth of the BH mass to account for the rest-mass energy radiated away during accretion, determined by a radiative efficiency parameter. For simplicity, in this lab we will switch this control off. For these purposes, you can include:

```fortran
! be 100% sure magnetic braking is always off
do_jdot_mb = .false.
! don't reduce the BH accretion efficiency
use_radiation_corrected_transfer_rate = .false.
```

To run the simulation faster we will relax multiple timestepping controls of the binary module by including:

```fortran
! relax timestep controls
fm = 0.1d0
fa = 0.02d0
fa_hard = 0.04d0
fr = 0.5d0
fj = 0.01d0
fj_hard = 0.02d0
```
The exact purpose of each of these controls can be checked in the defaults file `$MESA_DIR/binary/defaults/binary_controls.defaults`. Contrary to the `star` module, there is not a single `time_delta_coeff` control to easily scale all timesteps, so each of these controls relax the solver conditions based on the binary properties (orbital separation, Roche Lobe radius, ecc.).

Finally, let's add some options for the output of our simulation:
```fortran
! output preferences
photo_interval = 50
history_interval = 1
```

#### Modify `controls` in `inlist1`
We will add a lot of options here that involve the individual stripped star model. Most of them are purely to make the run faster; we add also a prescription for the convective overshooting and a terminating condition at core-Helium depletion. Going through everything is beyond the scope of this lab (we are focusing on binaries here 🙃 and you have seen many of these already in the previous days), but feel free to dig into them! Remember that the exact purpose of each of these controls can be checked in the defaults file `$MESA_DIR/star/defaults/controls.defaults`.

{{< details title="Modified `controls` for `inlist1`" closed="true" >}}
```fortran
&controls

   extra_terminal_output_file = 'log1' 
   log_directory = 'LOGS1'

   ! we use step overshooting
   overshoot_scheme(1) = 'step'
   overshoot_zone_type(1) = 'burn_H'
   overshoot_zone_loc(1) = 'core'
   overshoot_bdy_loc(1) = 'top'
   overshoot_f(1) = 0.345
   overshoot_f0(1) = 0.01

   ! a bit of exponential overshooting for convective core during He burn
   overshoot_scheme(2) = 'exponential'
   overshoot_zone_type(2) = 'burn_He'
   overshoot_zone_loc(2) = 'core'
   overshoot_bdy_loc(2) = 'top'
   overshoot_f(2) = 0.01
   overshoot_f0(2) = 0.005

   use_ledoux_criterion = .true.
   alpha_semiconvection = 1d0

   ! stop when the center mass fraction of h1 drops below this limit
   ! relax default dHe/He, otherwise growing convective regions can cause things to go at a snail pace
   dX_limit_species(1) = 'he4'
   dX_div_X_limit(1) = 5d0
   dX_div_X_limit_min_X(1) = 1d-1
   ! we're not looking for much precision at the very late stages
   dX_nuc_drop_limit = 5d-2
   ! stop when the center mass fraction of he4 drops below this limit
   xa_central_lower_limit_species(1) = 'he4'
   xa_central_lower_limit(1) = 1d-2

   ! reduce resolution and solver tolerance to make runs faster
   mesh_delta_coeff = 3d0
   time_delta_coeff = 3d0
   varcontrol_target = 1d-2
   use_gold2_tolerances = .false.
   use_gold_tolerances = .true.

   ! Use scaled corrections to aid the solver
   scale_max_correction = 0.03d0
   ignore_min_corr_coeff_for_scale_max_correction = .true.
   ignore_species_in_max_correction = .true.
   scale_max_correction_for_negative_surf_lum = .true.

   use_superad_reduction = .true.
   eps_mdot_leak_frac_factor = 0d0

   ! output options
   profile_interval = 500
   history_interval = 1
   terminal_interval = 1
   write_header_frequency = 10
   max_num_profile_models = 10000

/ ! end of controls namelist
```
{{< /details>}}

#### Modify `pgstar` in `inlist1`

Playing with `pgstar` can be very entertaining, but for this lab we will use a pre-made window. You can copy all this content and replace the default entirely:

{{< details title="Nice `pgstar` window" closed="true" >}}

```fortran
&pgstar

   pgstar_interval = 1

   pgstar_age_disp = 2.5
   pgstar_model_disp = 2.5

   !### scale for axis labels
   pgstar_xaxis_label_scale = 1.3
   pgstar_left_yaxis_label_scale = 1.3
   pgstar_right_yaxis_label_scale = 1.3

   Grid2_win_flag = .true.

   Grid2_win_width = 15
   Grid2_win_aspect_ratio = 0.65 ! aspect_ratio = height/width

   Grid2_plot_name(4) = 'Mixing'

   Grid2_num_cols = 7 ! divide plotting region into this many equal width cols
   Grid2_num_rows = 8 ! divide plotting region into this many equal height rows
   Grid2_num_plots = 6 ! <= 10

   Grid2_plot_name(1) = 'TRho_Profile'
   Grid2_plot_row(1) = 1 ! number from 1 at top
   Grid2_plot_rowspan(1) = 3 ! plot spans this number of rows
   Grid2_plot_col(1) =  1 ! number from 1 at left
   Grid2_plot_colspan(1) = 2 ! plot spans this number of columns 
   Grid2_plot_pad_left(1) = -0.05 ! fraction of full window width for padding on left
   Grid2_plot_pad_right(1) = 0.01 ! fraction of full window width for padding on right
   Grid2_plot_pad_top(1) = 0.00 ! fraction of full window height for padding at top
   Grid2_plot_pad_bot(1) = 0.05 ! fraction of full window height for padding at bottom
   Grid2_txt_scale_factor(1) = 0.65 ! multiply txt_scale for subplot by this


   Grid2_plot_name(5) = 'Kipp'
   Grid2_plot_row(5) = 4 ! number from 1 at top
   Grid2_plot_rowspan(5) = 3 ! plot spans this number of rows
   Grid2_plot_col(5) =  1 ! number from 1 at left
   Grid2_plot_colspan(5) = 2 ! plot spans this number of columns 
   Grid2_plot_pad_left(5) = -0.05 ! fraction of full window width for padding on left
   Grid2_plot_pad_right(5) = 0.01 ! fraction of full window width for padding on right
   Grid2_plot_pad_top(5) = 0.03 ! fraction of full window height for padding at top
   Grid2_plot_pad_bot(5) = 0.0 ! fraction of full window height for padding at bottom
   Grid2_txt_scale_factor(5) = 0.65 ! multiply txt_scale for subplot by this
   Kipp_title = ''
   Kipp_show_mass_boundaries = .true.

   Grid2_plot_name(6) = 'HR'
   HR_title = ''
   Grid2_plot_row(6) = 7 ! number from 1 at top
   Grid2_plot_rowspan(6) = 2 ! plot spans this number of rows
   Grid2_plot_col(6) =  6 ! number from 1 at left
   Grid2_plot_colspan(6) = 2 ! plot spans this number of columns 

   Grid2_plot_pad_left(6) = 0.05 ! fraction of full window width for padding on left
   Grid2_plot_pad_right(6) = -0.01 ! fraction of full window width for padding on right
   Grid2_plot_pad_top(6) = 0.0 ! fraction of full window height for padding at top
   Grid2_plot_pad_bot(6) = 0.0 ! fraction of full window height for padding at bottom
   Grid2_txt_scale_factor(6) = 0.65 ! multiply txt_scale for subplot by this

   History_Panels1_title = ''      
   History_Panels1_num_panels = 3

   History_Panels1_xaxis_name='model_number'
   History_Panels1_max_width = -1 ! only used if > 0.  causes xmin to move with xmax.

   History_Panels1_yaxis_name(1) = 'period_days' 
   History_Panels1_other_yaxis_name(1) = ''
   History_Panels1_yaxis_log(1) = .true.
   History_Panels1_yaxis_reversed(1) = .false.
   History_Panels1_ymin(1) = -101d0 ! only used if /= -101d0
   History_Panels1_ymax(1) = -101d0 ! only used if /= -101d0        
   !History_Panels1_dymin(1) = 0.1 

   History_Panels1_yaxis_name(2) = 'lg_mtransfer_rate' !
   History_Panels1_yaxis_reversed(2) = .false.
   History_Panels1_ymin(2) = -8d0 ! only used if /= -101d0
   History_Panels1_ymax(2) = -1d0 ! only used if /= -101d0        
   History_Panels1_dymin(2) = 1 

   History_Panels1_other_yaxis_name(2) = 'log_abs_mdot' 
   History_Panels1_other_yaxis_reversed(2) = .false.
   History_Panels1_other_ymin(2) = -8d0 ! only used if /= -101d0
   History_Panels1_other_ymax(2) = -1d0 ! only used if /= -101d0        
   History_Panels1_other_dymin(2) = 1 

   History_Panels1_yaxis_name(3) = 'rl_relative_overflow_1'
   History_Panels1_other_yaxis_name(3) = ''
   History_Panels1_yaxis_reversed(3) = .false.

   Grid2_plot_name(2) = 'Text_Summary1'
   Grid2_plot_row(2) = 7 ! number from 1 at top
   Grid2_plot_rowspan(2) = 2 ! plot spans this number of rows
   Grid2_plot_col(2) = 1 ! number from 1 at left
   Grid2_plot_colspan(2) = 4 ! plot spans this number of columns 
   Grid2_plot_pad_left(2) = -0.08 ! fraction of full window width for padding on left
   Grid2_plot_pad_right(2) = -0.10 ! fraction of full window width for padding on right
   Grid2_plot_pad_top(2) = 0.08 ! fraction of full window height for padding at top
   Grid2_plot_pad_bot(2) = -0.04 ! fraction of full window height for padding at bottom
   Grid2_txt_scale_factor(2) = 0.19 ! multiply txt_scale for subplot by this
   Text_Summary1_name(7,1) = 'period_days'
   Text_Summary1_name(8,1) = 'star_2_mass'

   ! ADD THE TDELAY TO THE TEXT SUMMARY
   Text_Summary1_name(7,4) = ''
   Text_Summary1_name(8,4) = ''

   Grid2_plot_name(3) = 'Profile_Panels3'
   Profile_Panels3_title = 'Abundance-Power-Mixing'
   Profile_Panels3_num_panels = 3
   Profile_Panels3_yaxis_name(1) = 'Abundance'
   Profile_Panels3_yaxis_name(2) = 'Power'
   Profile_Panels3_yaxis_name(3) = 'Mixing'

   Profile_Panels3_xaxis_name = 'mass'
   Profile_Panels3_xaxis_reversed = .false.

   Grid2_plot_row(3) = 1 ! number from 1 at top
   Grid2_plot_rowspan(3) = 6 ! plot spans this number of rows
   Grid2_plot_col(3) = 3 ! plot spans this number of columns 
   Grid2_plot_colspan(3) = 3 ! plot spans this number of columns 

   Grid2_plot_pad_left(3) = 0.09 ! fraction of full window width for padding on left
   Grid2_plot_pad_right(3) = 0.07 ! fraction of full window width for padding on right
   Grid2_plot_pad_top(3) = 0.0 ! fraction of full window height for padding at top
   Grid2_plot_pad_bot(3) = 0.0 ! fraction of full window height for padding at bottom
   Grid2_txt_scale_factor(3) = 0.65 ! multiply txt_scale for subplot by this

   Grid2_plot_name(4) = 'History_Panels1'
   Grid2_plot_row(4) = 1 ! number from 1 at top
   Grid2_plot_rowspan(4) = 6 ! plot spans this number of rows
   Grid2_plot_col(4) =  6 ! number from 1 at left
   Grid2_plot_colspan(4) = 2 ! plot spans this number of columns 
   Grid2_plot_pad_left(4) = 0.05 ! fraction of full window width for padding on left
   Grid2_plot_pad_right(4) = 0.03 ! fraction of full window width for padding on right
   Grid2_plot_pad_top(4) = 0.0 ! fraction of full window height for padding at top
   Grid2_plot_pad_bot(4) = 0.07 ! fraction of full window height for padding at bottom
   Grid2_txt_scale_factor(4) = 0.65 ! multiply txt_scale for subplot by this

   Grid2_file_flag = .true.
   Grid2_file_dir = 'png1'
   Grid2_file_prefix = 'grid_'
   Grid2_file_interval = 1 ! 1 ! output when mod(model_number,Grid2_file_interval)==0
   Grid2_file_width = -1 ! negative means use same value as for window
   Grid2_file_aspect_ratio = -1 ! negative means use same value as for window
      
/ ! end of pgstar namelist
```

{{< /details>}}

#### Get `final1_caseA.mod` and `final2_caseA.mod`
Grab the final models `final1_caseA.mod` and `final2_caseA.mod` from your minilab1 (or download them from [Table 1](#table-binary)) and copy them into your work folder.

<!-- #### Get `history_columns.list` and `binary_history_columns.list`
Grab the <a href="/files/binary_history_columns.list" download>`history_columns.list`</a> and <a href="/files/binary_history_columns.list" download>`history_columns.list`</a> and copy them into your work folder. -->




### The stripped star becomes a BH companion
After He depletion in its core, the stripped star has a very short remaining lifetime: for a star of total mass ~ 20 $M_{\odot}$ (and He-core mass of ~ 10 $M_{\odot}$), you can expect it to live only another ~ 300 years! For simplicity, we will just assume that the properties at core He depletion can be representative of those at the end of the star's life. Additionally, we will assume that all the mass contained in the primary directly collapses to form a BH.

<div style="
  margin:1rem 0;
  padding:0.8rem 1rem;
  background:rgba(16,185,129,0.10);
  border-left:5px solid #10b981;
">

  <div style="font-weight:600; margin-bottom:0.5rem;">
    🧪 Task: Modify <code>inlist_project</code>
  </div>

Find the mass of the stripped star at core He depletion from your <code>minilab1</code> and make it directly collapse into a BH. Set the period of your binary to be the one you found at the end of <code>minilab1</code>.
</div>



<details>
  <summary style="
    cursor:pointer;
    padding:0.5rem;
    background:rgba(246, 171, 59, 0.22);
    border-left:4px solid rgba(246, 171, 59, 0.22);
  ">
    💡 <strong>How do I find the BH mass?</strong>
  </summary>

  <div style="
    padding:0.75rem;
    background:rgba(246, 171, 59, 0.22);
    border-left:4px solid rgba(246, 171, 59, 0.22);
  ">

  Your <code>inlist_project</code> already has <code>evolve_both_stars = .false.</code>, so one of the two stars will be treated as a point mass --> BH!
  To find the mass of this BH, you can open the <code>final1_caseA.mod</code> and look at the header.


  </div>
</details>

<details>
  <summary style="
    cursor:pointer;
    padding:0.5rem;
    background:rgba(246, 171, 59, 0.22);
    border-left:4px solid rgba(246, 171, 59, 0.22)
  ">
    💡 <strong><code>m1</code> or <code>m2</code>?</strong>
  </summary>

  <div style="
    padding:0.75rem;
    background:rgba(246, 171, 59, 0.22);
    border-left:4px solid rgba(246, 171, 59, 0.22)
  ">

  Remember which one was stripped in Minilab1 (the primary, <code>final1_caseA.mod</code>), and which one was accreted (the secondary, <code>final2_caseA.mod</code>). The stripped star will become the BH (<code>m2</code>), and the accreted star will become your new primary (<code>m1</code>).

  </div>
</details>


{{< details title="Solution" closed="true" >}}
```fortran
   m1 = 39.6d0 ! primary mass in Msun
   m2 = 16.8d0 ! BH mass in Msun
   initial_period_in_days = 4.5d0 ! final period from minilab1
```
{{< /details >}}

Now you have set up the properties of your binary system. We are only missing one piece: we need to load the model of the accretor from minilab1 as our new primary star.

<div style="
  margin:1rem 0;
  padding:0.8rem 1rem;
  background:rgba(16,185,129,0.10);
  border-left:5px solid #10b981;
">

  <div style="font-weight:600; margin-bottom:0.5rem;">
    🧪 Task: Modify <code>inlist1</code>
  </div>

Load the right model from your <code>minilab1</code> in your `inlist1`.
</div>

<details>
  <summary style="
    cursor:pointer;
    padding:0.5rem;
    background:rgba(246, 171, 59, 0.22);
    border-left:4px solid rgba(246, 171, 59, 0.22);
  ">
    💡 <strong>Which command is it?</strong>
  </summary>

  <div style="
    padding:0.75rem;
    background:rgba(246, 171, 59, 0.22);
    border-left:4px solid rgba(246, 171, 59, 0.22);
  ">

  Try your luck by checking inside `$MESA_DIR/star/defaults/star_job.defaults`. You can search for the string `load`...

  </div>
</details>

{{< details title="Solution" closed="true" >}}
```fortran
&star_job
   ...
   load_saved_model = .true.
   load_model_filename = 'final2_caseA.mod'
   ...
/ ! end of star_job namelist
```
{{< /details >}}

> [!NOTE]
> Did you need to set both masses in `inlist_project`? Nope! Since you loaded a pre-computed model for your new primary (the accretor of minilab1), its mass and properties will be read directly from the model `final2_caseA.mod`.


### Computing the time delay
Let's compute the time delay of your BH + BH system to see if it will merge within the age of the Universe, in the beta>0 and Eddington-limited case. Compare!
Maybe let's find a GW signal that can be matchy-matchy

$$
t_{\rm delay} = \frac{5}{256} \, \frac{c^5 \, a^4}{G^3 \, m_1 m_2 (m_1 + m_2)}
$$

<div style="
  margin:1rem 0;
  padding:0.8rem 1rem;
  background:rgba(16,185,129,0.10);
  border-left:5px solid #10b981;
">

  <div style="font-weight:600; margin-bottom:0.5rem;">
    🧪 Task: Modify <code>run_binary_extras.f90</code>
  </div>

Let's compute the $t_{\mathrm{delay}}$ as an extra binary history column in `run_binary_extras.f90`, and print its value on the `pgstar` window, in the Text Summary part.
</div>

<details>
  <summary style="
    cursor:pointer;
    padding:0.5rem;
    background:rgba(246, 171, 59, 0.22);
    border-left:4px solid rgba(246, 171, 59, 0.22);
  ">
    💡 <strong>Mind the units...</strong>
  </summary>

  <div style="
    padding:0.75rem;
    background:rgba(246, 171, 59, 0.22);
    border-left:4px solid rgba(246, 171, 59, 0.22);
  ">

  In stellar astrophysics and in MESA we like to use the centimeter-gram-second units, therefore we saved our own useful constants to convert between energy units, or from seconds to years, and such.

  Those constants are readily accessible in <code>run_star_extras.f90</code>, if you know what their name is 🙃

  You may want to use:
  <ul>
    <li><code>secyer</code>, the conversion between years and seconds</li>
    <li><code>standard_cgrav</code>, the gravitational constant in c.g.s.</li>
  </ul>

  Loaded via: <code>use const_def</code><br>
  See also: <code>$MESA_DIR/const/public/const_def.f90</code>

  </div>
</details>

{{< details title="Solution for `run_binary_extras.f90`" closed="true" >}}
```fortran
subroutine data_for_extra_binary_history_columns(binary_id, n, names, vals, ierr)
  type(binary_info), pointer :: b
  integer, intent(in) :: binary_id
  integer, intent(in) :: n
  character(len=maxlen_binary_history_column_name) :: names(n)
  real(dp) :: vals(n)
  integer, intent(out) :: ierr
  ierr = 0
  call binary_ptr(binary_id, b, ierr)
  if (ierr /= 0) then
      write (*, *) 'failed in binary_ptr'
      return
  end if
  
  names(1) = 'tdelay(Gyr)'
  vals(1) = (5d0/256d0) * (clight**5 * b%separation**4) / &
        (standard_cgrav**3 * b%m(1) * b%m(2) * (b%m(1) + b%m(2)))

  ! convert from seconds -> years -> Gyr
  vals(1) = vals(1) / secyer / 1d9

end subroutine data_for_extra_binary_history_columns
```

```fortran
integer function how_many_extra_binary_history_columns(binary_id)
  use binary_def, only: binary_info
  integer, intent(in) :: binary_id
  how_many_extra_binary_history_columns = 1
end function how_many_extra_binary_history_columns
```
{{< /details >}}

{{< details title="Solution for `pgstar`" closed="true" >}}
```fortran
Text_Summary1_name(8,4) = 'tdelay(Gyr)'
```
{{< /details >}}


> [!WARNING]
> Don't forget to do `./clean` and `./mk` after modifying the `run_binary_extras.f90` file.

<div style="
  max-width: 600px;
  margin: 20px auto;
  border: 1px solid #d9534f;
  border-radius: 8px;
  background-color: #f5c2c2;
  overflow: hidden;
  color: black;
  font-family: sans-serif;
">

  <!-- Header -->
  <div style="
    background-color: #d9534f;
    color: black;
    font-weight: bold;
    text-align: center;
    padding: 8px;
  ">
    RUN 1 (5 minutes on 4 cores, 748 models)
  </div>

  <!-- Body -->
  <div style="
    padding: 15px;
    text-align: center;
  ">
    <p style="margin: 0;">
      Run your star + BH model.<br>
      In case you need them, here are the complete inlists for this run:
      <a href="/thursday/lab3/stable_MT_SOL.zip" download>
        <code>stable_MT_SOL.zip</code>
      </a>
    </p>
  </div>

</div>

### Analysis of the output: time delay, mass ratio, orbit
Let's compare how much orbital shrinkage you get with Eddington-limited accretion with respect to what you saw in Minilab1
Let's make them realize that Eddington-limited in practice means fully non-conservative, and let's have them check with a higher beta instead what changes.

### Orbital tightening from L2 mass loss
L2 shrinkage! Implementation in run_binary_extras.f90

<div style="
  margin:1rem 0;
  padding:0.8rem 1rem;
  background:rgba(16,185,129,0.10);
  border-left:5px solid #10b981;
">

  <div style="font-weight:600; margin-bottom:0.5rem;">
    🧪 Task: Modify <code>run_binary_extras.f90</code>
  </div>

Let's make such that our binary will lose 35% of transferred material through the outer Lagrangian point L2. You will need to introduce two personalized routines: `my_jdot_ml` and `my_adjust_mdots`, and an `x_ctrl(1)` in `inlist1`. This is a difficult task, so **don't be scared and read all the hints**!
</div>

> [!WARNING]
> Don't forget to do `./clean` and `./mk` after modifying the `run_binary_extras.f90` file.

<div style="
  max-width: 600px;
  margin: 20px auto;
  border: 1px solid #4fa2d9;
  border-radius: 8px;
  background-color: #e8f6ff;
  overflow: hidden;
  color: black;
  font-family: sans-serif;
">

  <!-- Header -->
  <div style="
    background-color: #4fa2d9;
    color: black;
    font-weight: bold;
    text-align: center;
    padding: 8px;
  ">
    RUN 2 (7 minutes on 4 cores, 683 models)
  </div>

  <!-- Body -->
  <div style="
    padding: 15px;
    text-align: center;
  ">
    <p style="margin: 0;">
      Run your star + BH model with L2 outflow.<br>
      In case you need them, here are the complete inlists for this run:
      <a href="/thursday/lab3/stable_MT_L2_SOL.zip" download>
        <code>stable_MT_L2_SOL.zip</code>
      </a>
    </p>
  </div>

</div>

<!-- #### ➕ BONUS: CASE B comparison!
Only if they had the time in minilab1 to do caseB. -->


## 2. Common envelope evolution
Brief explanation of the energy formalism

### The unstable mass transfer rate
Here we will define and implement what is an unstable mass transfer rate. run_binary_extras.f90 with a factor 10xthermal timescale, or x_ctrl(1) with a fixed number? We also implement a stopping condition at CE onset.

### The binding energy of the envelope
Implementation in run_star_extras.f90

### A lower mass ratio favors instability!
Here we will tell them to change the q. We want to give them a number that we know the outcome of. Then they run the model.

<div style="
  max-width: 600px;
  margin: 20px auto;
  border: 1px solid #4fd99f;
  border-radius: 8px;
  background-color: #cdffea;
  overflow: hidden;
  color: black;
  font-family: sans-serif;
">

  <!-- Header -->
  <div style="
    background-color: #4fd99f;
    color: black;
    font-weight: bold;
    text-align: center;
    padding: 8px;
  ">
    RUN 3 (x minutes on 4 cores)
  </div>

  <!-- Body -->
  <div style="
    padding: 15px;
    text-align: center;
  ">
    <p style="margin: 0;">
      Run your common envelope model.<br>
      In case you're lost, complete inlists for this run:
      <a href="/thursday/lab3/common_envelope_SOL.zip" download>
        <code>common_envelope_SOL.zip</code>
      </a>
    </p>
  </div>

</div>

### The orbital shrinkage
Comparison with stable mass transfer. The idea is that they will use the energy formalism to get the post-CE orbital separation.

### The time delay and final mass ratio
In the CE case, compare with stable mass transfer.

<!-- #### ➕ BONUS1: CASE B comparison!
Only if they had the time in minilab1 to do caseA.

#### ➕➕ BONUS2: Delayed mass transfer instability
Have them look into the timescale of when instability develops, and the shift in properties (mass and orbital separation) from RLOF to CE onset -->


