#Control file for red snapper
#Stock Synthesis Version 3.24j
rsnapper.dat
rsnapper.ctl
1 # 0=use init values in control file; 1=use ss3.par
1 # run display detail (0,1,2)
1 # detailed age-structured reports in REPORT.SSO (0,1)
0 # write detailed checkup.sso file (0,1)
0 # write parm values to ParmTrace.sso
0 # report level in CUMREPORT.SSO (0,1,2)
1 # Include prior_like for non-estimated parameters (0,1)
1 # Use Soft Boundaries to aid convergence
1 # Number of bootstrap datafiles to produce
10 # Turn off estimation for parameters entering after this phase
1000 # MCMC burn interval
100  # MCMC thin interval
0  # jitter initial parm value by this fraction
-1 # min yr for sdreport outputs (-1 for styr)
-2 # max yr for sdreport outputs (-1 for endyr; -2 for endyr+Nforecastyrs
0 # N individual STD years
0.0001 # final convergence criteria
0 # retrospective year relative to end year
0 # min age for calc of summary biomass
1 # Depletion basis:  denom is: 0=skip; 1=rel X*B0; 2=rel X*Bmsy; 3=rel X*B_styr
1 # Fraction (X) for Depletion denominator
4 # (1-SPR)_reporting:  0=skip; 1=rel(1-SPR); 2=rel(1-SPR_MSY); 3=rel(1-SPR_Btarget); 4=notrel
2 # F_std reporting: 0=skip; 1=exploit(Bio); 2=exploit(Num); 3=sum(frates)
0 # F_report_basis: 0=raw; 1=rel Fspr; 2=rel Fmsy ; 3=rel Fbtgt
999
