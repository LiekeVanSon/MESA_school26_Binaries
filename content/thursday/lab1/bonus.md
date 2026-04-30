---
title: "Bonus Exercises"
author: Matthias Fabry (lead), Annachiara Picco, Lucas de Sá, Lieke Van Son
weight: 2
math: true
toc: true
---

## Overview

If you have extra time, take a look at the below exercises to enhance your experience working with `MESA/binary`.

### Extra history columns

`MESA/binary` produces a separate history file, appropriately named `binary_history.data`, which contains information on the state of the binary.
For this exercise, implement the "observational mass ratio" as an extra binary history column (for any of the runs you did in the main lab).
This is the ratio of the less massive to the more massive star.
As an observer measuring masses of stars, you have no a priori information of what the "primary" is, and so it is customary to _define_ $q = M_{\rm low} / M_{\rm high} < 1$, rather than $q=M_2/M_1$, which can flip from below one to above as the binary evolves.

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
{{< /details >}}
{{< /details >}}
```

### Vary $\beta$ to a target mass

The mass-transfer efficiency parameters are poorly constrained.
However, if one finds a particular binary system (that we assume is a post-mass transfer) and measures its components' masses and period, one can do the exercise to try to set initial conditions and a $\beta$ that arrives at those measured parameters.

