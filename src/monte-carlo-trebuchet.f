c	MonteCarloTreb1.f
c
c   From http://www.algobeautytreb.com/fortmontecarlo.html.
c   SAMPLE OUTPUT ON THAT PAGE.
c
c	Calculates the range of a trebuchet with a free sling
c	and a hinged counterweight.  Assumes random input parameters
c	for a monte-carlo exploration of the possible designs.
c	Does stage 1 of the manuscript, 5 or so throws per second.
c
c	D. B. Siano             dimona@home.net       July 9, 1998
c	Documentation is at http://www.members.home.com/dimona
c	
c	Written for Absoft Fortran 77
c 	Calculates the second derivatives of the angles using
c	expressions derived from a Mathematica program.
c	Uses fourth-order Runge Kutta for second order DE
c	formula 25.5.20 in Abromowitz's "Handbook of Mathemtical
c	Functions" NBS, reprinted by Dover (1968).
c	Utilizes a variable stepsize (set by an accuracy tolerance, eps)
	Real*8 l1,l2,l3,l4,l5,m1,m2,mb,g,r,vx,vy
	Real*8 frth,tmax,thmax,phimax,psimax,rmax,rmaxth
	Real*8 ths,phis,psis,thds,phids,psids,hz,h1,eps
	Real*8 psiz,thz,phiz,thdz,phidz,psidz,delth
	Real*8 hstep,phist2,phidst2,psist2,psidst2
	Real*8 thst,thst2,thdst2,phist,phidst,psist,psidst
	Real*8 der1,der2,der3,thdst,h,psizdeg
	Real*8 a,b,rat,pecw,keproj,eneff,vxmax,vymax,thgo,effmax
	COMMON l1,l2,l3,l4,m1,m2,mb,g
		
c	Input the data here--uses ft, pounds
	l1=1.33
	l2=5.59
	l3=5.59
	l4=2.49
	l5=4.84
	m1=100.
	m2=1.
	mb=5.

c	write out the input data
	write(*,904)
904	Format(' free sling, hinged cw model')
	write(*,907)
907	Format(' MonteCarloTreb1.f')

c	acceleration of gravity
	g=32.
c	tolerance factor:  increase this for greater speed, less accuracy
	eps=1.d-7
	
	write(*,908)
908	Format(' j,l1,l2,l3,l4,l5,m1,m2,mb,rmax,eff,eneff,thgo,
     - vymax,vxmax,thmaxdeg,phimaxdeg,psimaxdeg,ncount,tmax,h,psizdeg')
	effmax=0.
	
	psiz=dasin(l5/l2)
c	set mone=1 to do a single throw, using the input values above
c	set mone=2 to do multiple random throws, using the input values
c	calculated below
	mone=2
	if(mone.eq.2) go to 51
	If(mone.eq.1) go to 50
	
51	continue
c	set the upper and lower limits on the values of psiz that are to be
c	used for the random variation here
	a=3.1415926/6
	b=3.1415926/3
	
c	set the number of throws here	
	Do 101 j=1,200


c	choose psiz between 30 and 60¡
	k=5*j
	psiz=(b-a)*RAN2(k)+a
	
c	assume cw falls two ft
	l1=2./(1.+dsin(psiz))
	
c	assume l2/l1 is between 3 and 5
	l=j
	rat=(5.-3.)*RAN2(l)+3.
	l2=rat*l1
	l5=l2*dsin(psiz)


c	assume sling length is between .5*l2 and 1.5*l2
	m=7*j
	l3=((1.5-.5)*RAN2(m)+.5 )*l2
	
c	choose l4 to be between .5*l1 and 1.*l1
	mm=9*j
	l4=((1.-.5)*RAN2(mm)+.5)*l1
	
50	continue


c	the starting angles: cw hangs, sling is horizontal
	thz=psiz+3.1415926/2.
	phiz=(3.1415926/2)-psiz
	
c	the angles start with zero rate of change
c	the "d" means first derivative, "dd" means the second derivative
	thdz=0.
	phidz=0.
	psidz=0.
	
c	Calculate pts from t=0 to t=hz seconds	
c	with a starting assumed step size of hz/hstep
c	you may need to adjust hz for weird cases
	hz=2.*dsqrt(2.*l2/g)
	hstep=600.
	h1=hz/hstep
	
c	write(*,988) hz, eps
988	format(' assumed max time for throw =',F8.2,', eps=',E8.1)
c	write(*,909) thz,phiz,psiz
909	format(' strt angles=',3d14.4)

c	der1,2,3 are used for checking correctness of dd functions
	der1=thdd(thz,thdz,phiz,phidz,psiz,psidz)
	der2=phidd(thz,thdz,phiz,phidz,psiz,psidz)
	der3=psidd(thz,thdz,phiz,phidz,psiz,psidz)
c	write(*,906) der1,der2,der3
906	format('der1,2,3=',3d14.4)

	rmax=0
c	the theoretical maximum range
	rmaxth=2*m1*(1.+dsin(psiz))*l1/m2
	tim=0.
c	save start vals
	ths=thz
	phis=phiz
	psis=psiz
	thds=thdz
	phids=phidz
	psids=psidz
	
c	counts the number of steps taken
	ncount=0
	
c	Primary loop:
c	get the maximum range for this set of parameters
c	use ncount to avoid infinite loops
c	the runge-kutta variable step size algorithm
	do while(tim < hz.AND.ncount < 4000)
		ncount=ncount+1
		tim=tim+2*h1
c		1 step of size 2*h1:	
	Call thstep(2*h1,ths,thds,phis,phids,psis,psids,thst2,thdst2)
	Call phistep(2*h1,ths,thds,phis,phids,psis,psids,phist2,phidst2)
	Call psistep(2*h1,ths,thds,phis,phids,psis,psids,psist2,psidst2)

c	now do 2 steps of size h1:
	do 100 k=1,2
	  Call thstep(h1,ths,thds,phis,phids,psis,psids,thst,thdst)	
	  Call phistep(h1,ths,thds,phis,phids,psis,psids,phist,phidst)
	  Call psistep(h1,ths,thds,phis,phids,psis,psids,psist,psidst)
	  
	  ths=thst
	  thds=thdst
	  phis=phist
	  phids=phidst
	  psis=psist
	  psids=psidst
	  delth=thst2-thst
	  frth=delth/thst
100	continue

c	Only consider the first rotation of the beam till it is
c	45 deg past vertical
	If(thst < -.707) goto 888
c	Only consider solutions with psimaxdeg<270:no twirling
	If(psist > 4.71) goto 888
	
c	Compare the two results and adjust the stepsize accordingly	
	if(dabs(frth).LT.eps)  then
	h1=h1*2
	else 
	h1=h1/2
	endif
	
c	calculate the range assuming release now
	vx=-(l3*(psidst-thdst)*dcos(psist-thst))-l2*thdst*dcos(thst)
    	vy= l3*(psidst-thdst)*dsin(psist-thst)-l2*thdst*dsin(thst)
     	r=2*vx*vy/g
	
     	if(r > rmax) then
	
68	format(' range=',2d14.4)
		rmax=r
		tmax=tim
		thmax=thst2
		phimax=phist2
		psimax=psist2
		vxmax=vx
		vymax=vy
	endif

	end do
888	continue
c	calculate the energetics, other characteristics of the throw
	keproj=m2*(vxmax*vxmax+vymax*vymax)/2.
	pecw=m1*g*l1*(1.+Sin(psiz))
	eneff=keproj/pecw
	thmaxdeg=thmax*57.29578
	phimaxdeg=phimax*57.29578
	psimaxdeg=psimax*57.29578
	eff=rmax/rmaxth
	vyy=vymax
	yxx=vxmax
	thgo=57.29578*datan(vymax/vxmax)
c	make the distance of cw fall, h, a constant
	h=l1*(1.+ sin(psiz))
	
c	look only for efficient trebs
	if(eff > 0) then
	effmax=eff
	psizdeg=psiz*57.29578
	write(*,900) j,l1,l2,l3,l4,l5,m1,m2,mb,rmax,eff,eneff,thgo,
     - vymax,vxmax,thmaxdeg,phimaxdeg,psimaxdeg,ncount,tmax,h,psizdeg
	endif
	
900	Format(I4,5(F6.2),F6.1,2(F5.1),f7.1,2f6.3,3(f6.1),3(f6.0),
     -	I5,f6.3,2(f6.1))
903	Format(' start angles =',3F8.3,' rad')
902	Format(//,'input paras l,m=',5F7.2,3F7.1)		
c	8	continue
c	9	Continue
101	continue
	pause
	stop
	end
	
c-----------------------------------------------------------------
c	random number generator	
         FUNCTION RAN2(IDUM)
         PARAMETER (M=714025,IA=1366,IC=150889,RM=1.4005112E-6)
         DIMENSION IR(97)
         DATA IFF /0/
         IF(IDUM.LT.0.OR.IFF.EQ.0)THEN
         IFF=1
         IDUM=MOD(IC-IDUM,M)
         DO 11 J=1,97
           IDUM=MOD(IA*IDUM+IC,M)
           IR(J)=IDUM
11       CONTINUE
         IDUM=MOD(IA*IDUM+IC,M)
         IY=IDUM
         ENDIF
         J=1+(97*IY)/M
         IF(J.GT.97.OR.J.LT.1)PAUSE
         IY=IR(J)
         RAN2=IY*RM
         IDUM=MOD(IA*IDUM+IC,M)
         IR(J)=IDUM
         RETURN
         END
c-------------------------------------------------------------------
c	the three second derivatives of the angles as functions	     
	function thdd(th,thd,phi,phid,psi,psid)
	Real*8 l1,l2,l3,l4,m1,m2,mb,th,thd,phi,phid,psi,psid,g
	Real*8 thdd
	common l1,l2,l3,l4,m1,m2,mb,g
	dsphi=dsin(phi)
	dcphi=dcos(phi)
	dspsi=dsin(psi)
	dcpsi=dcos(psi)
	dsth=dsin(th)
	dcth=dcos(th)
            thdd=(-3*(-2*l1*l4*m1*phid**2*dsphi - 
     -      4*l1*l4*m1*phid*thd*dsphi - 
     -      2*l1*l4*m1*thd**2*dsphi + 
     -      2*l1**2*m1*thd**2*dcphi*dsphi + 
     -      2*l2*l3*m2*psid**2*dspsi - 
     -      4*l2*l3*m2*psid*thd*dspsi + 
     -      2*l2*l3*m2*thd**2*dspsi - 
     -      2*l2**2*m2*thd**2*dcpsi*dspsi + 
     -      2*g*l2*m2*dcpsi*(dspsi*dcth-dcpsi*dsth) - 
     -      2*g*l1*m1*dsth + 2*g*l2*m2*dsth - 
     -      g*l1*mb*dsth + g*l2*mb*dsth + 
     -      2*g*l1*m1*dcphi*(dsphi*dcth+
     -      dcphi*dsth)))/
     -  (2.*(-3*l1**2*m1 - 3*l2**2*m2 - l1**2*mb + 
     -      l1*l2*mb - l2**2*mb + 3*l1**2*m1*dcphi**2 + 
     -      3*l2**2*m2*dcpsi**2))
  	 return
  	 end
	 
   	function phidd(th,thd,phi,phid,psi,psid)
   	Real*8 l1,l2,l3,l4,m1,m2,mb,th,thd,phi,phid,psi,psid,g
	Real*8 phidd
   	common l1,l2,l3,l4,m1,m2,mb,g
   	dsphi=dsin(phi)
	dcphi=dcos(phi)
	dspsi=dsin(psi)
	dcpsi=dcos(psi)
	dsth=dsin(th)
	dcth=dcos(th)
         phidd=-((-(l1*thd**2*dsphi) - g*(dsphi*dcth
     -    +dcphi*dsth))/l4) + 
     -  (3*(l4 - l1*dcphi)*
     -     (-2*l1*l4*m1*phid**2*dsphi - 
     -       4*l1*l4*m1*phid*thd*dsphi - 
     -       2*l1*l4*m1*thd**2*dsphi + 
     -       2*l1**2*m1*thd**2*dcphi*dsphi + 
     -       2*l2*l3*m2*psid**2*dspsi - 
     -       4*l2*l3*m2*psid*thd*dspsi + 
     -       2*l2*l3*m2*thd**2*dspsi - 
     -       2*l2**2*m2*thd**2*dcpsi*dspsi + 
     -       2*g*l2*m2*dcpsi*(dspsi*dcth-dcpsi*dsth) - 
     -       2*g*l1*m1*dsth + 2*g*l2*m2*dsth - 
     -       g*l1*mb*dsth + g*l2*mb*dsth + 
     -       2*g*l1*m1*dcphi*(dsphi*dcth+
     -       dcphi*dsth)))/
     -   (2.*l4*(-3*l1**2*m1 - 3*l2**2*m2 - l1**2*mb + 
     -       l1*l2*mb - l2**2*mb + 3*l1**2*m1*dcphi**2 + 
     -       3*l2**2*m2*dcpsi**2))
   	return
   	end
   	
   	function psidd(th,thd,phi,phid,psi,psid)
   	Real*8 l1,l2,l3,l4,m1,m2,mb,th,thd,phi,phid,psi,psid,g
	Real*8 psiddtop,psiddbot,psidd
   	common l1,l2,l3,l4,m1,m2,mb,g
   	dsphi=dsin(phi)
	dcphi=dcos(phi)
	dspsi=dsin(psi)
	dcpsi=dcos(psi)
	dsth=dsin(th)
	dcth=dcos(th)
         psiddtop=
     -   l3*m2*(-(l4*m1*(l4 - l1*dcphi)*(l4**2*m1 - 
     -    l1*l4*m1*dcphi)) + 
     -     l4**2*m1*(l1**2*m1 + l4**2*m1 + l2**2*m2 + l3**2*m2 +
     -   (l1**2*mb)/3.
     -       - (l1*l2*mb)/3.+(l2**2*mb)/3.-2*l1*l4*m1*dcphi- 
     -    2*l2*l3*m2*dcpsi))*
     -   (-(l2*thd**2*dspsi) + g*(dspsi*dcth-dcpsi*dsth)) - 
     -  l3*m2*(-l3 + l2*dcpsi)*(-(l4*m1*(l4**2*m1 - 
     -   l1*l4*m1*dcphi)*
     -        (-(l1*thd**2*dsphi) - g*(dsphi*dcth+
     -    dcphi*dsth))) + 
     -     l4**2*m1*(l1*l4*m1*phid**2*dsphi + 
     -    2*l1*l4*m1*phid*thd*dsphi
     -        -l2*l3*m2*psid**2*dspsi +
     -    2*l2*l3*m2*psid*thd*dspsi - 
     -        g*l3*m2*(dspsi*dcth-dcpsi*dsth) + g*l1*m1*dsth 
     -   - g*l2*m2*dsth + 
     -        (g*l1*mb*dsth)/2. - (g*l2*mb*dsth)/2. -
     -      g*l4*m1*(dsth*dcphi+dcth*dsphi)))
     
        psiddbot=-(l1**2*l3**2*l4**2*m1**2*m2) -
     -   l2**2*l3**2*l4**2*m1*m2**2 - 
     -  (l1**2*l3**2*l4**2*m1*m2*mb)/3. + 
     -    (l1*l2*l3**2*l4**2*m1*m2*mb)/3. - 
     -  (l2**2*l3**2*l4**2*m1*m2*mb)/3. + 
     -   l1**2*l3**2*l4**2*m1**2*m2*dcphi**2 + 
     -  l2**2*l3**2*l4**2*m1*m2**2*dcpsi**2
         psidd=psiddtop/psiddbot
         return
         end
	 
c	The Runge-Kutta formulas as functions

        Subroutine thstep(h,th,thd,phi,phid,psi,psid,thst,thdst)
	Real*8 k1,k2,k3,k4,h,th,thd,phi,phid,psi,psid,thst,thdst
        k1=h*thdd(th,thd,phi,phid,psi,psid)
        k2=h*thdd(th+h/2*thd+h*k1/8,thd+k1/2,phi,phid,psi,psid)
        k3=h*thdd(th+h/2*thd+h*k1/8,thd+k2/2,phi,phid,psi,psid)
        k4=h*thdd(th+h*thd+h*k3/2,thd+k3,phi,phid,psi,psid)
	thst=th+h*(thd+(k1+k2+k3)/6)
        thdst=thd+(k1+2*k2+2*k3+k4)/6
        return
        end
      
	Subroutine phistep(h,th,thd,phi,phid,psi,psid,phist,phidst)
	Real*8 k1,k2,k3,k4,h,th,thd,phi,phid,psi,psid,phist,phidst
        k1=h*phidd(th,thd,phi,phid,psi,psid)	
	k2=h*phidd(th,thd,phi+h/2*phid+h*k1/8,phid+k1/2,psi,psid)
	k3=h*phidd(th,thd,phi+h/2*phid+h*k1/8,phid+k2/2,psi,psid)
	k4=h*phidd(th,thd,phi+h*phid+h*k3/2,phid+k3,psi,psid)
	phist=phi+h*(phid+(k1+k2+k3)/6)
	phidst=phid+(k1+2*k2+2*k3+k4)/6
        return
        end

	Subroutine psistep(h,th,thd,phi,phid,psi,psid,psist,psidst)
	Real*8 k1,k2,k3,k4,h,th,thd,phi,phid,psi,psid,psist,psidst
	k1=h*psidd(th,thd,phi,phid,psi,psid)	
	k2=h*psidd(th,thd,phi,phid,psi+h/2*psid+h*k1/8,psid+k1/2)
    	k3=h*psidd(th,thd,phi,phid,psi+h/2*psid+h*k1/8,psid+k2/2)
	k4=h*psidd(th,thd,phi,phid,psi+h*psid+h*k3/2,psid+k3)
	psist=psi+h*(psid+(k1+k2+k3)/6)
	psidst=psid+(k1+2*k2+2*k3+k4)/6
        return
        end
