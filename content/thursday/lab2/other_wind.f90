subroutine other_wind(id, Lsurf, Msurf, Rsurf, Tsurf, X, Y, Z, w, ierr)
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

        ! He-poor thin winds{
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

        function get_g_switch(z_div_zsun) result(g_switch)
          real(dp), intent(in) :: z_div_zsun
          real(dp):: g_switch
          ! GH2008 G_switch corrected for
          ! kindly provided by Amedeo Romagnolo
          g_switch = 0.5d0 - 0.301d0*log10(z_div_zsun)-0.045d0*pow2(log10(z_div_zsun))
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

      end subroutine other_wind