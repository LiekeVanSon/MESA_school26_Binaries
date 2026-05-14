---
title: "Bonus Exercises lab 1"
author: Matthias Fabry (lead), Annachiara Picco, Lucas de Sá, Lieke Van Son
weight: 2
math: true
toc: true
---
---
title: "Lab 1 Bonus Exercises"

If you have extra time, take a look at the below exercises to enhance your skills working with `MESA/binary`.

### Extra history columns

`MESA/binary` produces a separate history file, appropriately named `binary_history.data`, which contains information on the state of the binary.
For this exercise, implement the "observational mass ratio" as an extra binary history column (for any of the runs you did in the main lab).
This is the ratio of the less massive to the more massive star.
As an observer measuring masses of stars, you have no a priori information of what the "primary" is, and so it is customary to *define* $q \equiv M_{\rm low} / M_{\rm high} < 1$, rather than $q=M_2/M_1$, which can flip from below one to above as the binary evolves.

{{< details title="Hint" closed="true" >}}
This is very similar to how you would add a custom column to the `star` history in `run_star_extras.f90`. Take a look at the routines in `run_binary_extras.f90`, and see if you can continue from there.

{{< details title="Solution" closed="true" >}}

```fortran
integer function how_many_extra_binary_history_columns(binary_id)
    use binary_def, only: binary_info
    integer, intent(in) :: binary_id
    how_many_extra_binary_history_columns = 1
end function how_many_extra_binary_history_columns

subroutine data_for_extra_binary_history_columns(binary_id, n, names, vals, ierr)
    use const_def, only: dp
    type (binary_info), pointer :: b
    integer, intent(in) :: binary_id
    integer, intent(in) :: n
    character (len=maxlen_binary_history_column_name) :: names(n)
    real(dp) :: vals(n)
    integer, intent(out) :: ierr
    real(dp) :: beta
    ierr = 0
    call binary_ptr(binary_id, b, ierr)
    if (ierr /= 0) then
        write(*,*) 'failed in binary_ptr'
        return
    end if
    names(1) = 'obs_mass_ratio'
    if (b% m(1) > b% m(2)) then
        vals(1) = b% m(2) / b% m(1)
    else
        vals(1) = b% m(1) / b% m(2)
    end if

end subroutine data_for_extra_binary_history_columns
```

{{< /details >}}
{{< /details >}}

### Modeling the sdO binary $\phi$ Persei

$\phi$ Persei is a lower mass binary containing a subdwarf (sdO) and a B2 main-sequence star. From its orbital period, we infer it must have undergone case B mass transfer when the now-subdwarf star overflowed its Roche Lobe.
While not being a binary black-hole progenitor (it'll likely evolve to a type-Ia supernova when the now-B2 star starts dumping matter on the subdwarf), its evolution is still very interesting to model.
In this exercise, you'll try to recreate the history of $\phi$ Per using MESA.

![phi-per](phi-per.png)
Image of $\phi$ Persei. *Credit: David Ritter, license: CC BY-SA 4.0.*

$\phi$ Persei's observed properties are:
$$M_1 = 1.14 M_\odot$$
$$M_2 = 9.6 M_\odot$$
$$p = 127 {\rm d}$$

First, try to figure out what stellar masses you want to start with.
From observation we know that the sdO is essentially the helium core of a star that lost its entire hydrogen envelope.
Knowing that this core is formed from roughly 20% of the initial mass of the star at ZAMS, you can get an estimate of what $M_{1,\rm init}$ has to be.

You then also know what amount of mass will be lost, and this is available to transfer to the secondary.
Calculate the amount of mass accepted by the accretor assuming an efficiency $\epsilon = 1-\beta$.
Of course, after the mass-transfer event, we should end up with $M_2 = 9.6 M_\odot$ of mass, so choose appropriate values for $M_{2, \rm init}$ and $\beta$ to make the math work.
Remember that $M_{2, \rm init} < M_{1, \rm init}$ because otherwise the secondary starts mass transferring first!

Settings to change from the Run 3 setup:

- Disable the step overshoot we use for (very) massive stars. The remaining exponential overshoot is plenty for this example.
- Set the appropriate ZAMS models. Download [this grid](/thursday/lab1/zams_z142m2_y2703.data) as the set of starting models, and move it to `$MESA_DIR/data/star_data/zams_models/`. Don't use the `load_saved_model` functionality, but instead set:

```fortran
zams_filename = 'z0.0142_y0.2703.data'
initial_z = 0.0142d0
initial_y = 0.2703d0
```

in `&controls`, and set the initial masses in `&binary_controls`.

See if you can get both masses to within $0.1 M_\odot$ and the final period to within 5% of the observed values.
If you'd like, share your solution to the [Google Sheet](https://docs.google.com/spreadsheets/d/1a5gx9o0_MCAnP_3dU2xA3I60lQkIN1NhjYG9Ea-OxSw/edit?usp=sharing) in the right-most tab.

Things to consider after this exercise:

- Convince yourself that the mass transfer in this system can't have been very non-conservative.
- What would've had to be different about the observed properties for a non-conservative scenario to work?
- If you really want to nail down the sdO mass, but you couldn't change the initial mass, what parameter(s) would you change? Try it!

{{< details title="Solution" closed="true" >}}
We get the primary initial mass as roughly:
$$M_{1, \rm init} \approx 1.14 M_\odot / 0.2 \approx 6 M_\odot.$$

The amount of accreted mass is then:
$$M_{\rm acc} \approx 0.8(1-\beta)M_{1, \rm init},$$
and so
$$M_{2, \rm final} = M_{2, \rm init} + 0.8(1-\beta)M_{1, \rm init} \approx 9.6 M_\odot.$$

Because $M_{2, \rm init} < M_{1, \rm init}$, this equation tells us that $\beta < 1/4$.
Conversely, since $\beta \geq 0$, the mininum mass of the secondary is $4.8 M_\odot$.

Of course, these numbers are very approximate, and the precise final results depend on the detailed physics (in particular overshooting which will change the helium core mass independent of the initial mass, tides (which we assumed were super effective), etc...)
{{< /details >}}
