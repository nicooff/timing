c-----------------------------------------------------------------------
c   
c   Lid-driven cavity
c
c-----------------------------------------------------------------------
      subroutine uservp (ix,iy,iz,ieg)
      implicit none

      include 'SIZE_DEF'
      include 'SIZE'
      include 'NEKUSE_DEF'
      include 'NEKUSE' ! utrans, udiff

      integer ix, iy, iz, ieg

      utrans = 0.0
      udiff = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userf  (ix,iy,iz,ieg)
      implicit none

      include 'SIZE_DEF'
      include 'SIZE'
      include 'NEKUSE_DEF'
      include 'NEKUSE' ! ffx, ffy, ffz

      integer ix, iy, iz, ieg

      ffx = 0.0
      ffy = 0.0
      ffz = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userq  (ix,iy,iz,ieg)
      implicit none

      include 'SIZE_DEF'
      include 'SIZE'
      include 'NEKUSE_DEF'
      include 'NEKUSE' ! QVOL

      integer ix, iy, iz, ieg

      qvol = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userchk
      implicit none

      include 'SIZE_DEF'
      include 'SIZE'  
      include 'TSTEP_DEF'
      include 'TSTEP'   ! istep
      include 'PARALLEL_DEF'
      include 'PARALLEL' ! np
      include 'CTIMER_DEF'
      include 'CTIMER'  ! tcrsl

      real tcrsl_min, tcrsl_max, tcrsl_avg, w_min, 
     $ w_max, w_avg

c     Print timing for the coarse grid solver 
c     (min, max and avg over all processes)
      tcrsl_min = tcrsl
      call gop(tcrsl_min,w_min,'m  ',1)

      tcrsl_max = tcrsl
      call gop(tcrsl_max,w_max,'M  ',1)

      tcrsl_avg = tcrsl
      call gop(tcrsl_avg,w_avg,'+  ',1)
      tcrsl_avg = tcrsl_avg/np

      if (nid .eq. 0) then
         write(6,*) istep, ' tcrsl_min: ', tcrsl_min
         write(6,*) istep, ' tcrsl_max: ', tcrsl_max
         write(6,*) istep, ' tcrsl_avg: ', tcrsl_avg
      endif

      return
      end
c-----------------------------------------------------------------------
      subroutine userbc (ix,iy,iz,iside,ieg)
C     Set boundary conditions
      implicit none

      include 'SIZE_DEF'
      include 'SIZE'
      include 'NEKUSE_DEF'
      include 'NEKUSE' ! UX, UY, UZ, TEMP, X, Y

c     Smoothing function for the velocity along the lid in order to avoid a
c     gap in the x-velocity at the corners:

c     ux = 0 if x <= delta0 or x >= 1-delta0
c     ux is smoothed if delta0 < x < delsmo or 1-delsmo < x < 1-delta0
c     ux=1 if delsmo <= x <= 1-delsmo

      integer ix, iy, iz, iside, ieg
      real delta0, delsmo, arg
      
      delta0 = 0.001 
      delsmo = 0.1

      if (X.le.delta0) then
         UX= 0.0
      elseif(X.lt.delsmo) then
         arg = X/delsmo
         UX=1./(1.+exp(1./(arg-1.)+1./arg))
      elseif (X.le.1.0-delsmo) then
         UX=1.0
      elseif (X.lt.(1-delta0)) then
         arg = (1.0-X)/delsmo
         UX= 1./(1.+exp(1./(arg-1.)+1./arg))
      else
         UX=0.0
      endif
      UY = 0.0
      UZ = 0.0

      temp = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine useric (ix,iy,iz,ieg)
C     Set initial conditions
      implicit none

      include 'SIZE_DEF'
      include 'SIZE'
      include 'NEKUSE_DEF'
      include 'NEKUSE'          ! UX, UY, UZ, TEMP

      integer ix, iy, iz, ieg

      ux   = 0.0
      uy   = 0.0
      uz   = 0.0

      temp = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat
      implicit none

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat2
      implicit none

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat3
      implicit none

      return
      end
