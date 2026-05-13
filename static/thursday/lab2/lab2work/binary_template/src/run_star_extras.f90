! ***********************************************************************
!
!   Copyright (C) 2012  Bill Paxton
!
!   this file is part of mesa.
!
!   mesa is free software; you can redistribute it and/or modify
!   it under the terms of the gnu general library public license as published
!   by the free software foundation; either version 2 of the license, or
!   (at your option) any later version.
!
!   mesa is distributed in the hope that it will be useful, 
!   but without any warranty; without even the implied warranty of
!   merchantability or fitness for a particular purpose.  see the
!   gnu library general public license for more details.
!
!   you should have received a copy of the gnu library general public license
!   along with this software; if not, write to the free software
!   foundation, inc., 59 temple place, suite 330, boston, ma 02111-1307 usa
!
! ***********************************************************************
 
      module run_star_extras 

      use star_lib
      use star_def
      use const_def
      use math_lib
      use chem_def
      use num_lib
      use binary_def
      
      implicit none

      integer :: time0, time1, clock_rate
      real(dp), parameter :: expected_runtime = 15 ! min

      integer, parameter :: restart_info_alloc = 1
      integer, parameter :: restart_info_get = 2
      integer, parameter :: restart_info_put = 3

      ! these routines are called by the standard run_star check_model
      contains
      
      subroutine extras_controls(id, ierr)
         integer, intent(in) :: id
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         
         ! this is the place to set any procedure pointers you want to change
         ! e.g., other_wind, other_mixing, other_energy  (see star_data.inc)


         ! the extras functions in this file will not be called
         ! unless you set their function pointers as done below.
         ! otherwise we use a null_ version which does nothing (except warn).

         s% extras_startup => extras_startup
         s% extras_start_step => extras_start_step
         s% extras_check_model => extras_check_model
         s% extras_finish_step => extras_finish_step
         s% extras_after_evolve => extras_after_evolve
         s% how_many_extra_history_columns => how_many_extra_history_columns
         s% data_for_extra_history_columns => data_for_extra_history_columns
         s% how_many_extra_profile_columns => how_many_extra_profile_columns
         s% data_for_extra_profile_columns => data_for_extra_profile_columns  

         s% how_many_extra_history_header_items => how_many_extra_history_header_items
         s% data_for_extra_history_header_items => data_for_extra_history_header_items
         s% how_many_extra_profile_header_items => how_many_extra_profile_header_items
         s% data_for_extra_profile_header_items => data_for_extra_profile_header_items

         s% other_wind => wyoming_wind
         s% other_am_mixing => TSF_Fuller_Lu22

      end subroutine extras_controls
      
      
      subroutine extras_startup(id, restart, ierr)
         integer, intent(in) :: id
         logical, intent(in) :: restart
         integer, intent(out) :: ierr
         integer :: restart_time, prev_time_used
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         if (.not. restart) then
            call system_clock(time0,clock_rate)
            call alloc_restart_info(s)
         else
            call unpack_restart_info(s)
            call system_clock(restart_time,clock_rate)
            prev_time_used = time1 - time0
            time1 = restart_time
            time0 = time1 - prev_time_used
         end if
      end subroutine extras_startup
      

      integer function extras_start_step(id)
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         extras_start_step = 0
      end function extras_start_step


      ! returns either keep_going, retry, or terminate.
      integer function extras_check_model(id)
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         extras_check_model = keep_going         
         if (.false. .and. s% star_mass_h1 < 0.35d0) then
            ! stop when star hydrogen mass drops to specified level
            extras_check_model = terminate
            write(*, *) 'have reached desired hydrogen mass'
            return
         end if


         ! if you want to check multiple conditions, it can be useful
         ! to set a different termination code depending on which
         ! condition was triggered.  MESA provides 9 customizeable
         ! termination codes, named t_xtra1 .. t_xtra9.  You can
         ! customize the messages that will be printed upon exit by
         ! setting the corresponding termination_code_str value.
         ! termination_code_str(t_xtra1) = 'my termination condition'

         ! by default, indicate where (in the code) MESA terminated
         if (extras_check_model == terminate) s% termination_code = t_extras_check_model
      end function extras_check_model


      integer function how_many_extra_history_columns(id)
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         how_many_extra_history_columns = 1
      end function how_many_extra_history_columns
      
      
      subroutine data_for_extra_history_columns(id, n, names, vals, ierr)
         integer, intent(in) :: id, n
         character (len=maxlen_history_column_name) :: names(n)
         real(dp) :: vals(n)
         integer, intent(out) :: ierr
         real(dp) :: dt
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

      end subroutine data_for_extra_history_columns

      
      integer function how_many_extra_profile_columns(id)
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         how_many_extra_profile_columns = 0
      end function how_many_extra_profile_columns
      
      
      subroutine data_for_extra_profile_columns(id, n, nz, names, vals, ierr)
         integer, intent(in) :: id, n, nz
         character (len=maxlen_profile_column_name) :: names(n)
         real(dp) :: vals(nz,n)
         integer, intent(out) :: ierr
         type (star_info), pointer :: s
         integer :: k
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         
         ! note: do NOT add the extra names to profile_columns.list
         ! the profile_columns.list is only for the built-in profile column options.
         ! it must not include the new column names you are adding here.

         ! here is an example for adding a profile column
         !if (n /= 1) stop 'data_for_extra_profile_columns'
         !names(1) = 'beta'
         !do k = 1, nz
         !   vals(k,1) = s% Pgas(k)/s% P(k)
         !end do
         
      end subroutine data_for_extra_profile_columns


      integer function how_many_extra_history_header_items(id)
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         how_many_extra_history_header_items = 0
      end function how_many_extra_history_header_items


      subroutine data_for_extra_history_header_items(id, n, names, vals, ierr)
         integer, intent(in) :: id, n
         character (len=maxlen_history_column_name) :: names(n)
         real(dp) :: vals(n)
         type(star_info), pointer :: s
         integer, intent(out) :: ierr
         ierr = 0
         call star_ptr(id,s,ierr)
         if(ierr/=0) return

         ! here is an example for adding an extra history header item
         ! also set how_many_extra_history_header_items
         ! names(1) = 'mixing_length_alpha'
         ! vals(1) = s% mixing_length_alpha

      end subroutine data_for_extra_history_header_items


      integer function how_many_extra_profile_header_items(id)
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         how_many_extra_profile_header_items = 0
      end function how_many_extra_profile_header_items


      subroutine data_for_extra_profile_header_items(id, n, names, vals, ierr)
         integer, intent(in) :: id, n
         character (len=maxlen_profile_column_name) :: names(n)
         real(dp) :: vals(n)
         type(star_info), pointer :: s
         integer, intent(out) :: ierr
         ierr = 0
         call star_ptr(id,s,ierr)
         if(ierr/=0) return

         ! here is an example for adding an extra profile header item
         ! also set how_many_extra_profile_header_items
         ! names(1) = 'mixing_length_alpha'
         ! vals(1) = s% mixing_length_alpha

      end subroutine data_for_extra_profile_header_items


      ! returns either keep_going or terminate.
      ! note: cannot request retry; extras_check_model can do that.
      integer function extras_finish_step(id)
         integer, intent(in) :: id
         integer :: ierr
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         extras_finish_step = keep_going

         ! to save a profile, 
            ! s% need_to_save_profiles_now = .true.
         ! to update the star log,
            ! s% need_to_update_history_now = .true.

         if (s% model_number > 1 .and. s% dt/secyer > 0.1) then
            if( abs( s% xtra_old(30) - s% v_div_v_crit_avg_surf) > 0.025) then
               write(*,*) "reducing dt due to large change in v_div_v_crit"
               s% dt_next = min(s% dt_next, s% dt * s% min_timestep_factor)
            end if
         end if
         s% xtra(30) = s% v_div_v_crit_avg_surf

         call system_clock(time1,clock_rate)
         call store_restart_info(s)

         ! see extras_check_model for information about custom termination codes
         ! by default, indicate where (in the code) MESA terminated
         if (extras_finish_step == terminate) s% termination_code = t_extras_finish_step
      end function extras_finish_step
      
      
      subroutine extras_after_evolve(id, ierr)
         integer, intent(in) :: id
         integer, intent(out) :: ierr
         real(dp) :: dt
         type (star_info), pointer :: s
         ierr = 0
         call star_ptr(id, s, ierr)
         if (ierr /= 0) return
         dt = dble(time1 - time0) / clock_rate / 60
         if (dt > 10*expected_runtime) then
            write(*,'(/,a30,2f18.6,a,/)') '>>>>>>> EXCESSIVE runtime', &
               dt, expected_runtime, '   <<<<<<<<<  ERROR'
         else
            write(*,'(/,a50,2f18.6,99i10/)') 'runtime, retries, steps', &
               dt, expected_runtime, s% num_retries, s% model_number
         end if
      end subroutine extras_after_evolve

      ! routines for saving and restoring data so can do restarts

      
      subroutine alloc_restart_info(s)
         type (star_info), pointer :: s
         call move_restart_info(s,restart_info_alloc)
      end subroutine alloc_restart_info
      
      
      subroutine unpack_restart_info(s)
         type (star_info), pointer :: s
         call move_restart_info(s,restart_info_get)
      end subroutine unpack_restart_info
      
      
      subroutine store_restart_info(s)
         type (star_info), pointer :: s
         call move_restart_info(s,restart_info_put)
      end subroutine store_restart_info
      
      
      subroutine move_restart_info(s,op)
         type (star_info), pointer :: s
         integer, intent(in) :: op
         
         integer :: i, j, num_ints, num_dbls, ierr
         
         i = 0
         ! call move_int or move_flg 
         call move_int(time0)
         call move_int(time1)
         
         num_ints = i
         
         i = 0
         ! call move_dbl 
         
         num_dbls = i
         
         if (op /= restart_info_alloc) return
         if (num_ints == 0 .and. num_dbls == 0) return
         
         ierr = 0
         call star_alloc_extras(s% id, num_ints, num_dbls, ierr)
         if (ierr /= 0) then
            write(*,*) 'failed in star_alloc_extras'
            write(*,*) 'alloc_extras num_ints', num_ints
            write(*,*) 'alloc_extras num_dbls', num_dbls
            stop 1
         end if
         
         contains
         
         subroutine move_dbl(dbl)
            real(dp) :: dbl
            i = i+1
            select case (op)
            case (restart_info_get)
               dbl = s% extra_work(i)
            case (restart_info_put)
               s% extra_work(i) = dbl
            end select
         end subroutine move_dbl
         
         subroutine move_int(int)
            integer :: int
            include 'formats'
            i = i+1
            select case (op)
            case (restart_info_get)
               !write(*,3) 'restore int', i, s% extra_iwork(i)
               int = s% extra_iwork(i)
            case (restart_info_put)
               !write(*,3) 'save int', i, int
               s% extra_iwork(i) = int
            end select
         end subroutine move_int
         
         subroutine move_flg(flg)
            logical :: flg
            i = i+1
            select case (op)
            case (restart_info_get)
               flg = (s% extra_iwork(i) /= 0)
            case (restart_info_put)
               if (flg) then
                  s% extra_iwork(i) = 1
               else
                  s% extra_iwork(i) = 0
               end if
            end select
         end subroutine move_flg
      end subroutine move_restart_info

      subroutine wyoming_wind(id, Lsurf, Msurf, Rsurf, Tsurf, X, Y, Z, w, ierr)
        use star_def
        include 'formats'
        type (star_info), pointer :: s
        integer, intent(in) :: id
        real(dp), intent(in) :: Lsurf, Msurf, Rsurf, Tsurf, X, Y, Z ! surface values (cgs)
        ! NOTE: surface is outermost cell. not necessarily at photosphere.
        ! NOTE: don't assume that vars are set at this point.
        ! so if you want values other than those given as args,
        ! you should use values from s% xh(:,:) and s% xa(:,:) only.
        ! rather than things like s% Teff or s% lnT(:) which have not been set yet.
        real(dp), intent(out) :: w ! wind in units of Msun/year (value is >= 0)
        integer, intent(out) :: ierr
        
        real(dp) :: X0, dX, &
                    Z_div_Zsun, vink2001_w, vink2011_w, &
                    vink2017_w, sander2020_w, sander2023_w, &
                    he_poor_w, he_rich_w, &
                    he_poor_a, &
                    g_switch, g_e
        real(dp), parameter :: Zsun = 0.017d0

        logical, parameter :: dbg = .false.
        
        ierr = 0
        call star_ptr(id, s, ierr)
        if (ierr /= 0) return

        X0 = 0.7d0
        dX = 0.4d0
        Z_div_Zsun = Z/Zsun
        g_e = pow(10d0, -4.813d0) * (1 + X) * Lsurf/Lsun / (Msurf/Msun)

        ! baseline model will be only V01 + S20 + S17 with Y06 transition
        ! extra exercise will be to implement S23
        vink2001_w = 0d0
        vink2011_w = 0d0
        vink2017_w = 0d0
        sander2020_w = 0d0
        sander2023_w = 0d0
        w = 0d0 

        ! He-poor thin winds
        g_switch = get_g_switch(Z_div_Zsun)
        call eval_Vink2001_wind(vink2001_w)
        if ((g_e >= g_switch) .and. (s% lxtra(1) .eqv. .false.)) then
           s% lxtra(1) = .true. ! have crossed wind g_switch
           s% xtra(1) = vink2001_w ! w at g_switch
           s% xtra(2) = Msurf ! M at g_switch
        end if
        call eval_Vink2011_wind(vink2011_w)
        
        if (g_e >= g_switch) then
          he_poor_w = vink2011_w
        else
          he_poor_w = vink2001_w
        end if
        
        ! He-rich winds
        call eval_Vink2017_wind(vink2017_w) ! low-mass He star winds
        call eval_Sander2020_wind(sander2020_w) ! WR winds
        he_rich_w = max(vink2017_w, sander2020_w)
            
        ! linearly interpolate between MS and He star winds 
        ! between X=0.3 and X=0.7
        if (X > X0) then
          he_poor_a = 1d0
        else if (X > X0 - dX) then
          he_poor_a = (X - (X0 - dX)) / dX
        else
          he_poor_a = 0d0
        end if
      
        w = he_poor_a * he_poor_w + (1d0-he_poor_a) * he_rich_w

        ! total winds
        if (dbg) then
          write(*,*) '  winds (Msun/yr):'
          write(*,*) '  Vink2001 (He-poor)', vink2001_w
          write(*,*) '  Vink2017 (He-rich)', vink2017_w
          write(*,*) '  Sander2020 (He-rich)', sander2020_w
          write(*,*) '  Final mdot', w
          write(*,*) '  X0, dX, X, He-poor weight', X0, dX, X, he_poor_a
        end if
        
        ierr = 0
        
        contains

        function get_g_switch(Z_div_Zsun) result(g_switch)
          real(dp), intent(in) :: Z_div_Zsun
          real(dp):: g_switch
          ! GH2008 G_switch corrected for
          ! kindly provided by Amedeo Romagnolo
          g_switch = 0.5d0 - 0.301d0*log10(Z_div_Zsun)-0.045d0*pow2(log10(Z_div_Zsun))
        end function get_g_switch

        subroutine eval_Vink2001_wind(w)
          ! Vink, de Koter & Lamers (2001)
          ! Winds for MS O/B stars
          real(dp), intent(inout) :: w
          real(dp) :: a, dT, Teff_jump, vinf_div_vesc, log_mdot, mdot1, mdot2

          ! use Vink et al 2001, eqns 14 and 15 to set "jump" temperature
          Teff_jump = 1d3*(61.2d0 + 2.59d0*(-13.636d0 + 0.889d0*log10(Z_div_Zsun)))
          
          if (Tsurf > 27.5d3) then
            a = 1d0
          else if (Tsurf < 22.5d3) then
            a = 0d0
          else
            ! the dT parameter sets the rate at which the winds transition
            ! from the cool to the hot regime around the bi-stability jump
            dT = 100d0
            if (Tsurf > Teff_jump + dT) then
              a = 1d0
            else if (Tsurf < Teff_jump - dT) then
              a = 0d0
            else
              a = (Tsurf - (Teff_jump-dT)) / (2*dT)
            end if
          end if

          if (a > 0) then ! eval hot side wind (eq 24)
            vinf_div_vesc = 2.6d0 ! Galactic value
            ! metallicity rescaling based on Leitherer+92
            vinf_div_vesc = vinf_div_vesc * pow(Z_div_Zsun, 0.13d0)
            log_mdot = - 6.697d0 &
                      + 2.194d0 * log10(Lsurf/Lsun/1d5) &
                      - 1.313d0 * log10(Msurf/Msun/3d1) & 
                      - 1.226d0 * log10(vinf_div_vesc/2d0) &
                      + 0.933d0 * log10(Tsurf/4d4) &
                      - 10.92d0 * pow2(log10(Tsurf/4d4)) &
                      + 0.85d0 * log10(Z/Zsun)
            mdot1 = exp10(log_mdot)
          else
            mdot1 = 0d0
          end if

          if (a < 1) then ! eval cool side wind (eq 25)
            vinf_div_vesc = 1.3d0 ! Galactic value
            ! metallicity rescaling based on Leitherer+92
            vinf_div_vesc = vinf_div_vesc * pow(Z_div_Zsun, 0.13d0)
            log_mdot = - 6.688d0 &
                      + 2.210d0 * log10(Lsurf/Lsun/1d5) &
                      - 1.339d0 * log10(Msurf/Msun/3d1) &
                      - 1.601d0 * log10(vinf_div_vesc/2) &
                      + 1.07d0 * log10(Tsurf/2d4) &
                      + 0.85d0 * log10(Z/Zsun)
            mdot2 = exp10(log_mdot)
          else
            mdot2 = 0d0
          end if

          w = a*mdot1 + (1 - a)*mdot2   
        end subroutine eval_Vink2001_wind

        subroutine eval_Vink2011_wind(w)
          real(dp), intent(inout) :: w
          real(dp) :: w_switch, m_switch, g_switch

          g_switch = get_g_switch(Z_div_Zsun)
          w_switch = s% xtra(1)
          m_switch = s% xtra(2)

          w = w_switch * pow(Msurf/m_switch, 0.78d0) * pow(g_e/g_switch, 2.2d0)

        end subroutine eval_Vink2011_wind

        subroutine eval_Sander2020_wind(w)
          ! Sanders & Vink (2020) (base)
          real(dp), intent(inout) :: w
          real(dp) :: logz, alpha, l_0, mdot_10, log_w, log_power_term
          ! winds for Teff = 141 kK from Sanders & Vink (2020)
          ! recipe: eq 14
          ! parameters: eqs 18-20

          logz = log10(Z/Zsun)
          alpha = 0.32d0*logz + 1.4d0
          l_0 = exp10(-0.87d0*logz + 5.06d0)  ! Lsun
          mdot_10 = exp10(-0.75d0*logz - 4.06d0)  ! Msun yr-1

          if (Lsurf/Lsun .lt. l_0) then
            log_power_term = 0d0
          else
            log_power_term = pow(log10(Lsurf/Lsun/l_0), alpha)
          end if

          w = mdot_10 * log_power_term * pow(Lsurf/Lsun/l_0/10d0, 0.75d0)
        end subroutine eval_Sander2020_wind

        subroutine eval_Vink2017_wind(w)
          ! Vink (2017)
          ! Winds for stripped stars, i.e., "lower-mass He stars"
          ! Thin winds; not adequate for classical WR thick winds
          real(dp), intent(inout) :: w
          real(dp) :: log_mdot

          ! equation 1
          log_mdot = - 13.3d0 &
                    + 1.36d0 * log10(Lsurf/Lsun) &
                    + 0.61d0 * log10(Z/Zsun)
          w = exp10(log_mdot)

        end subroutine eval_Vink2017_wind

      end subroutine wyoming_wind

      subroutine TSF_Fuller_Lu22(id, ierr)
        ! original from https://zenodo.org/records/5778001
        ! from Fuller & Lu 2022, https://ui.adsabs.harvard.edu/abs/2022MNRAS.511.3951F/abstract
        integer, intent(in) :: id
        integer, intent(out) :: ierr
        type (star_info), pointer :: s
        integer :: k,j,op_err,nsmooth,nsmootham
        real(dp) :: alpha,shearsmooth,nu_tsf,nu_tsf_t,omegac,omegag,omegaa,omegat,difft,diffm,brunts,bruntsn2

        call star_ptr(id,s,ierr)
        if (ierr /= 0) return

        nsmooth=1!
        nsmootham=1
        shearsmooth=1d-30
        op_err = 0
        alpha = 2.5d-1

        !Calculate shear at each zone, then calculate TSF torque
        do k=nsmooth+1,s% nz-(nsmooth+1)

          nu_tsf=1d-30
          nu_tsf_t=1d-30
          !Calculate smoothed shear, q= dlnOmega/dlnr
          shearsmooth = s% omega_shear(k)/(2.*nsmooth+1.)
          do j=1,nsmooth
              shearsmooth = shearsmooth + (1./(2.*nsmooth+1.))*( s% omega_shear(k-j) + s% omega_shear(k+j) )
          end do

          diffm =  diffmag(s% rho(k),s% T(k),s% abar(k),s% zbar(k),op_err, id) !Magnetic diffusivity
          difft = 16d0*5.67d-5*(s% T(k))**3/(3d0*s% opacity(k)*(s% rho(k))**2*s% Cp(k)) !Thermal diffusivity
          omegaa = s% omega(k)*(shearsmooth*s% omega(k)/sqrt(abs(s% brunt_N2(k))))**(1./3.) !Alfven frequency at saturation, assuming adiabatic instability
          omegat = difft*pow2(sqrt(abs(s% brunt_N2(k)))/(omegaa*s% r(k))) !Thermal damping rate assuming adiabatic instability
          brunts = sqrt(abs( s% brunt_N2_composition_term(k)+(s% brunt_N2(k)-s% brunt_N2_composition_term(k))/(1d0 + omegat/omegaa) )) !Suppress thermal part of brunt
          bruntsn2 = sqrt(abs( s% brunt_N2_composition_term(k)+(s% brunt_N2(k)-s% brunt_N2_composition_term(k))*min(1d0,diffm/difft) )) !Effective brunt for isothermal instability
          brunts = max(brunts,bruntsn2) !Choose max between suppressed brunt and isothermal brunt
          brunts = max(s% omega(k),brunts) !Don't let Brunt be smaller than omega
          omegaa = s% omega(k)*abs(shearsmooth*s% omega(k)/brunts)**(1./3.) !Recalculate omegaa

          ! Calculate nu_TSF
          if (s% brunt_N2(k) > 0.) then
              if (pow2(brunts) > 2.*pow2(shearsmooth)*pow2(s% omega(k))) then
                omegac = 1d0*s% omega(k)*((brunts/s% omega(k))**0.5)*(diffm/(pow2(s% r(k))*s% omega(k)))**0.25  !Critical field strength
                !nu_tsf = 5d-1+5d-1*tanh(10d0*log(alpha*omegaa/omegac)) !Suppress AM transport if omega_a<omega_c
                !nu_tsf = nu_tsf*alpha**3*s% omega(k)*pow2(s% r(k))*(s% omega(k)/brunts)**2 !nu_omega for revised Tayler instability
                nu_tsf = alpha**3*pow2(s% r(k))*s% omega(k)*(s% omega(k)/brunts)**2 !nu_omega for revised Tayler instability

              end if
              ! Add TSF enabled by thermal diffusion
              if (pow2(brunts) < 2.*pow2(shearsmooth)*pow2(s% omega(k))) then
                nu_tsf_t = alpha*abs(shearsmooth)*s% omega(k)*pow2(s% r(k))
              end if
              s% am_nu_omega(k) = s% am_nu_omega(k) + max(nu_tsf,nu_tsf_t) + 1d-1
          end if
        end do
      end subroutine TSF_Fuller_Lu22


      real(dp) function diffmag(rho, T, abar, zbar, ierr, id)
        ! Written by S.-C. Yoon, Oct. 10, 2003
        ! Electrical conductivity according to Spitzer 1962
        ! See also Wendell et al. 1987, ApJ 313:284
        integer, intent(in) :: id
        real(dp), intent(in) :: rho, T, abar, zbar
        integer, intent(out) :: ierr
        real(dp) :: xmagfmu, xmagft, xmagfdif, xmagfnu, &
            xkap, xgamma, xlg, xsig1, xsig2, xsig3, xxx, ffff, xsig, &
            xeta
        ! initialize
        diffmag = 0.0d0
        if (ierr /= 0) return

        xgamma = 0.2275d0*zbar*zbar*pow(rho*1d-6/abar,1d0/3d0)*1d8/T
        xlg = log10(xgamma)
        if (xlg < -1.5d0) then
          xsig1 = sige1(zbar,T,xgamma)
          xsig = xsig1
        else if (xlg >= -1.5d0 .and. xlg <= 0d0) then
          xxx = (xlg + 0.75d0)*4d0/3d0
          ffff = 0.25d0*(2d0-3d0*xxx + xxx*xxx*xxx)
          xsig1 = sige1(zbar,T,xgamma)

          xsig2 = sige2(T,rho,zbar,ierr, id)
          if (ierr /= 0) return

          xsig = (1d0-ffff)*xsig2 + ffff*xsig1
        else if (xlg > 0d0 .and. xlg < 0.5d0) then
          xsig2 = sige2(T,rho,zbar,ierr, id)
          if (ierr /= 0) return

          xsig = xsig2
        else if (xlg >= 0.5d0 .and. xlg < 1d0) then
          xxx = (xlg-0.75d0)*4d0
          ffff = 0.25d0*(2d0-3d0*xxx + xxx*xxx*xxx)
          xsig2 = sige2(T,rho,zbar,ierr, id)
          if (ierr /= 0) return

          xsig3 = sige3(zbar,T,xgamma)
          xsig = (1d0-ffff)*xsig3 + ffff*xsig2
        else
          xsig3 = sige3(zbar,T,xgamma)
          xsig = xsig3
        endif

        diffmag = 7.1520663d19/xsig ! magnetic diffusivity

      end function diffmag


      ! Helper functions

      real(dp) function sige1(z,t,xgamma)
        ! Written by S.-C. Yoon, Oct. 10, 2003
        ! Electrical conductivity according to Spitzer 1962
        ! See also Wendell et al. 1987, ApJ 313:284
        real(dp), intent(in) :: z, t, xgamma
        real(dp) :: etan, xlambda,f
        if (t >= 4.2d5) then
          f = sqrt(4.2d5/t)
        else
          f = 1d0
        end if
        xlambda = sqrt(3d0*z*z*z)*pow(xgamma,-1.5d0)*f + 1d0
        etan = 3d11*z*log(xlambda)*pow(t,-1.5d0)             ! magnetic diffusivity
        etan = etan/(1d0-1.20487d0*exp(-1.0576d0*pow(z,0.347044d0))) ! correction: gammae
        sige1 = clight*clight/(4d0*pi*etan)                    ! sigma = c^2/(4pi*eta)
      end function sige1


      real(dp) function sige2(T, rho, zbar, ierr, id)
        ! written by S.-C. YOON Oct. 10, 2003
        ! electrical conductivity using conductive opacity
        ! see Wendell et al. 1987 ApJ 313:284
        use kap_lib, only: kap_get_elect_cond_opacity
        integer, intent(in) :: id
        real(dp), intent(in) :: t,rho,zbar
        integer, intent(out) :: ierr
        real(dp) :: kap, dlnkap_dlnRho, dlnkap_dlnT
        type (star_info), pointer :: s
        call star_ptr(id, s, ierr)

        call kap_get_elect_cond_opacity( &
            s% kap_handle, &
            zbar, log10(rho), log10(T),  &
            kap, dlnkap_dlnRho, dlnkap_dlnT, ierr)
        sige2 = 1.11d9*T*T/(rho*kap)
      end function sige2

      real(dp) function sige3(z, t, xgamma)
        ! written by S.-C. YOON Oct. 10, 2003
        ! electrical conductivity in degenerate matter,
        ! according to Nandkumar & Pethick (1984)
        real(dp), intent(in) :: z, t, xgamma
        real(dp) :: rme, rm23, ctmp, xi
        rme = 8.5646d-23*t*t*t*xgamma*xgamma*xgamma/pow5(z)  ! rme = rho6/mue
        rm23 = pow(rme,2d0/3d0)
        ctmp = 1d0 + 1.018d0*rm23
        xi= sqrt(3.14159d0/3d0)*log(z)/3d0 + 2d0*log(1.32d0+2.33d0/sqrt(xgamma))/3d0-0.484d0*rm23/ctmp
        sige3 = 8.630d21*rme/(z*ctmp*xi)
      end function sige3

end module run_star_extras
      
