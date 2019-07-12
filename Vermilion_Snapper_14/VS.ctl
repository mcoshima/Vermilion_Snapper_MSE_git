#V3.24AC
#_data_and_control_files: VS.dat // VS.ctl
#_SS-V3.24AC-safe;_04/13/2017;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_11.2x64
1  #_N_Growth_Patterns
1 #_N_Morphs_Within_GrowthPattern 
#_Cond 1 #_Morph_between/within_stdev_ratio (no read if N_morphs=1)
#_Cond  1 #vector_Morphdist_(-1_in_first_val_gives_normal_approx)
#
#_Cond 0  #  N recruitment designs goes here if N_GP*nseas*area>1
#_Cond 0  #  placeholder for recruitment interaction request
#_Cond 1 1 1  # example recruitment design element for GP=1, seas=1, area=1
#
#_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
1 #_Nblock_Patterns
 1 #_blocks_per_pattern 
# begin and end years of blocks
 2007 2014
#
0.5 #_fracfemale 
3 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
 #_Age_natmort_by gender x growthpattern
 0.234 0.342 0.287 0.257 0.239 0.228 0.22 0.215 0.212 0.209 0.207 0.206 0.205 0.204 0.204
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_speciific_K; 4=not implemented
0.5 #_Growth_Age_for_L1
999 #_Growth_Age_for_L2 (999 to use as Linf)
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
1 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
1 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity by GP; 4=read age-fecundity by GP; 5=read fec and wt from wtatage.ss; 6=read length-maturity by GP
#_placeholder for empirical age- or length- maturity by growth pattern (female only)
1 #_First_Mature_Age
2 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
2 #_env/block/dev_adjust_method (1=standard; 2=logistic transform keeps in base parm bounds; 3=standard w/ no bound check)
#
#_growth_parms
#_LO HI INIT PRIOR PR_type SD PHASE env-var use_dev dev_minyr dev_maxyr dev_stddev Block Block_Fxn
 0.0001 1e+006 11.83 11.83 -1 0 -1 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 0.0001 1e+006 34.4 34.4 -1 0 -1 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0 1e+006 0.3254 0.3254 -1 0 -1 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0 1e+006 0.2535 0.0001 -1 0 -1 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0 1e+006 0.2535 0.0001 -1 0 -1 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
 0 1e+006 2.19e-005 2.19e-005 -1 0 -1 0 0 0 0 0 0 0 # Wtlen_1_Fem
 0 1e+006 2.916 2.916 -1 0 -1 0 0 0 0 0 0 0 # Wtlen_2_Fem
 0 1e+006 14.087 14.087 -1 0 -1 0 0 0 0 0 0 0 # Mat50%_Fem
 0 1e+006 -0.574 -0.574 -1 0 -1 0 0 0 0 0 0 0 # Mat_slope_Fem
 0 1e+006 278.715 278.715 -1 0 -1 0 0 0 0 0 0 0 # Eggs_scalar_Fem
 0 1e+006 3.042 3.042 -1 0 -1 0 0 0 0 0 0 0 # Eggs_exp_len_Fem
 -4 4 0 0 -1 99 -4 0 0 0 0 0 0 0 # RecrDist_GP_1
 -4 4 1 1 -1 0.01 -4 0 0 0 0 0 0 0 # RecrDist_Area_1
 -4 4 1 1 -1 0.01 -4 0 0 0 0 0 0 0 # RecrDist_Seas_1
 1 1 1 1 -1 0 -4 0 0 0 0 0 0 0 # CohortGrowDev
#
#_Cond 0  #custom_MG-env_setup (0/1)
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no MG-environ parameters
#
#_Cond 0  #custom_MG-block_setup (0/1)
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no MG-block parameters
#_Cond No MG parm trends 
#
#_seasonal_effects_on_biology_parms
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
#_Cond -4 #_MGparm_Dev_Phase
#
#_Spawner-Recruitment
3 #_SR_function: 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepard_3Parm
#_LO HI INIT PRIOR PR_type SD PHASE
 0 13.82 13.82 6.91 -1 0 1 # SR_LN(R0)
 0.22 0.96 0.252303 0.6 -3 0.74 2 # SR_BH_steep
 0 2 0.381988 0.2 -1 0 3 # SR_sigmaR
 -5 5 0 0 -1 0 -3 # SR_envlink
 -5 5 0 0 -1 0 -3 # SR_R1_offset
 0 0.5 0 0 -1 0 -2 # SR_autocorr
0 #_SR_env_link
0 #_SR_env_target_0=none;1=devs;_2=R0;_3=steepness
1 #do_recdev:  0=none; 1=devvector; 2=simple deviations
1994 # first year of main recr_devs; early devs can preceed this era
2012 # last year of main recr_devs; forecast devs start in following year
3 #_recdev phase 
1 # (0/1) to read 13 advanced options
 0 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
 4 #_recdev_early_phase
 5 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
 1 #_lambda for Fcast_recr_like occurring before endyr+1
 1986.53 #_last_early_yr_nobias_adj_in_MPD
 1995.83 #_first_yr_fullbias_adj_in_MPD
 2010.72 #_last_yr_fullbias_adj_in_MPD
 2014.18 #_first_recent_yr_nobias_adj_in_MPD
 0.8538 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
 0 #_period of cycles in recruitment (N parms read below)
 -5 #min rec_dev
 5 #max rec_dev
 0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#
# all recruitment deviations
#DisplayOnly -0.651679 # Main_RecrDev_1994
#DisplayOnly -0.410959 # Main_RecrDev_1995
#DisplayOnly -0.377129 # Main_RecrDev_1996
#DisplayOnly -0.422357 # Main_RecrDev_1997
#DisplayOnly -0.43679 # Main_RecrDev_1998
#DisplayOnly 0.292365 # Main_RecrDev_1999
#DisplayOnly 0.120972 # Main_RecrDev_2000
#DisplayOnly 0.161312 # Main_RecrDev_2001
#DisplayOnly 0.183051 # Main_RecrDev_2002
#DisplayOnly 0.142437 # Main_RecrDev_2003
#DisplayOnly -0.106957 # Main_RecrDev_2004
#DisplayOnly 0.138846 # Main_RecrDev_2005
#DisplayOnly 0.520477 # Main_RecrDev_2006
#DisplayOnly 0.104015 # Main_RecrDev_2007
#DisplayOnly -0.0359333 # Main_RecrDev_2008
#DisplayOnly -0.151521 # Main_RecrDev_2009
#DisplayOnly 0.334308 # Main_RecrDev_2010
#DisplayOnly 0.32054 # Main_RecrDev_2011
#DisplayOnly 0.275002 # Main_RecrDev_2012
#DisplayOnly 0.292142 # Late_RecrDev_2013
#DisplayOnly -0.329817 # Late_RecrDev_2014
#DisplayOnly 0 # ForeRecr_2015
#DisplayOnly 0 # ForeRecr_2016
#DisplayOnly 0 # ForeRecr_2017
#DisplayOnly 0 # ForeRecr_2018
#DisplayOnly 0 # ForeRecr_2019
#DisplayOnly 0 # ForeRecr_2020
#DisplayOnly 0 # ForeRecr_2021
#DisplayOnly 0 # ForeRecr_2022
#DisplayOnly 0 # ForeRecr_2023
#DisplayOnly 0 # ForeRecr_2024
#DisplayOnly 0 # ForeRecr_2025
#DisplayOnly 0 # ForeRecr_2026
#DisplayOnly 0 # ForeRecr_2027
#DisplayOnly 0 # ForeRecr_2028
#DisplayOnly 0 # ForeRecr_2029
#DisplayOnly 0 # ForeRecr_2030
#DisplayOnly 0 # ForeRecr_2031
#DisplayOnly 0 # ForeRecr_2032
#DisplayOnly 0 # ForeRecr_2033
#DisplayOnly 0 # ForeRecr_2034
#DisplayOnly 0 # ForeRecr_2035
#DisplayOnly 0 # ForeRecr_2036
#DisplayOnly 0 # ForeRecr_2037
#DisplayOnly 0 # ForeRecr_2038
#DisplayOnly 0 # ForeRecr_2039
#DisplayOnly 0 # ForeRecr_2040
#DisplayOnly 0 # ForeRecr_2041
#DisplayOnly 0 # ForeRecr_2042
#DisplayOnly 0 # ForeRecr_2043
#DisplayOnly 0 # ForeRecr_2044
#DisplayOnly 0 # ForeRecr_2045
#DisplayOnly 0 # ForeRecr_2046
#DisplayOnly 0 # ForeRecr_2047
#DisplayOnly 0 # ForeRecr_2048
#DisplayOnly 0 # ForeRecr_2049
#DisplayOnly 0 # ForeRecr_2050
#DisplayOnly 0 # ForeRecr_2051
#DisplayOnly 0 # ForeRecr_2052
#DisplayOnly 0 # ForeRecr_2053
#DisplayOnly 0 # ForeRecr_2054
#DisplayOnly 0 # ForeRecr_2055
#DisplayOnly 0 # ForeRecr_2056
#DisplayOnly 0 # ForeRecr_2057
#DisplayOnly 0 # ForeRecr_2058
#DisplayOnly 0 # ForeRecr_2059
#DisplayOnly 0 # ForeRecr_2060
#DisplayOnly 0 # ForeRecr_2061
#DisplayOnly 0 # ForeRecr_2062
#DisplayOnly 0 # ForeRecr_2063
#DisplayOnly 0 # ForeRecr_2064
#DisplayOnly 0 # ForeRecr_2065
#DisplayOnly 0 # ForeRecr_2066
#DisplayOnly 0 # ForeRecr_2067
#DisplayOnly 0 # ForeRecr_2068
#DisplayOnly 0 # ForeRecr_2069
#DisplayOnly 0 # ForeRecr_2070
#DisplayOnly 0 # ForeRecr_2071
#DisplayOnly 0 # ForeRecr_2072
#DisplayOnly 0 # ForeRecr_2073
#DisplayOnly 0 # ForeRecr_2074
#DisplayOnly 0 # Impl_err_2015
#DisplayOnly 0 # Impl_err_2016
#DisplayOnly 0 # Impl_err_2017
#DisplayOnly 0 # Impl_err_2018
#DisplayOnly 0 # Impl_err_2019
#DisplayOnly 0 # Impl_err_2020
#DisplayOnly 0 # Impl_err_2021
#DisplayOnly 0 # Impl_err_2022
#DisplayOnly 0 # Impl_err_2023
#DisplayOnly 0 # Impl_err_2024
#DisplayOnly 0 # Impl_err_2025
#DisplayOnly 0 # Impl_err_2026
#DisplayOnly 0 # Impl_err_2027
#DisplayOnly 0 # Impl_err_2028
#DisplayOnly 0 # Impl_err_2029
#DisplayOnly 0 # Impl_err_2030
#DisplayOnly 0 # Impl_err_2031
#DisplayOnly 0 # Impl_err_2032
#DisplayOnly 0 # Impl_err_2033
#DisplayOnly 0 # Impl_err_2034
#DisplayOnly 0 # Impl_err_2035
#DisplayOnly 0 # Impl_err_2036
#DisplayOnly 0 # Impl_err_2037
#DisplayOnly 0 # Impl_err_2038
#DisplayOnly 0 # Impl_err_2039
#DisplayOnly 0 # Impl_err_2040
#DisplayOnly 0 # Impl_err_2041
#DisplayOnly 0 # Impl_err_2042
#DisplayOnly 0 # Impl_err_2043
#DisplayOnly 0 # Impl_err_2044
#DisplayOnly 0 # Impl_err_2045
#DisplayOnly 0 # Impl_err_2046
#DisplayOnly 0 # Impl_err_2047
#DisplayOnly 0 # Impl_err_2048
#DisplayOnly 0 # Impl_err_2049
#DisplayOnly 0 # Impl_err_2050
#DisplayOnly 0 # Impl_err_2051
#DisplayOnly 0 # Impl_err_2052
#DisplayOnly 0 # Impl_err_2053
#DisplayOnly 0 # Impl_err_2054
#DisplayOnly 0 # Impl_err_2055
#DisplayOnly 0 # Impl_err_2056
#DisplayOnly 0 # Impl_err_2057
#DisplayOnly 0 # Impl_err_2058
#DisplayOnly 0 # Impl_err_2059
#DisplayOnly 0 # Impl_err_2060
#DisplayOnly 0 # Impl_err_2061
#DisplayOnly 0 # Impl_err_2062
#DisplayOnly 0 # Impl_err_2063
#DisplayOnly 0 # Impl_err_2064
#DisplayOnly 0 # Impl_err_2065
#DisplayOnly 0 # Impl_err_2066
#DisplayOnly 0 # Impl_err_2067
#DisplayOnly 0 # Impl_err_2068
#DisplayOnly 0 # Impl_err_2069
#DisplayOnly 0 # Impl_err_2070
#DisplayOnly 0 # Impl_err_2071
#DisplayOnly 0 # Impl_err_2072
#DisplayOnly 0 # Impl_err_2073
#DisplayOnly 0 # Impl_err_2074
#
#Fishing Mortality info 
0.5 # F ballpark for annual F (=Z-M) for specified year
-2001 # F ballpark year (neg value to disable)
2 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
4 # max F or harvest rate, depends on F_Method
# no additional F input needed for Fmethod 1
# if Fmethod=2; read overall start F value; overall phase; N detailed inputs to read
# if Fmethod=3; read N iterations for tuning for Fmethod 3
 0.05 1 0 # overall start F value; overall phase; N detailed inputs to read
#Fleet Year Seas F_value se phase (for detailed setup of F_Method=2)

#
#_initial_F_parms
#_LO HI INIT PRIOR PR_type SD PHASE
 0 1 0 0.01 0 99 -1 # InitF_1CM_E
 0 1 0 0.01 0 99 -1 # InitF_2CM_W
 0 1 0 0.01 0 99 -1 # InitF_3REC
 0 1 0 0.01 0 99 -1 # InitF_4SMP_BYC

# F rates for Fmethod=2
# 2.72523e-006 F_fleet_1_YR_1950_s_1
# 0 F_fleet_1_YR_1951_s_1
# 2.72534e-006 F_fleet_1_YR_1952_s_1
# 3.62784e-006 F_fleet_1_YR_1953_s_1
# 4.53964e-006 F_fleet_1_YR_1954_s_1
# 5.45162e-006 F_fleet_1_YR_1955_s_1
# 6.35468e-006 F_fleet_1_YR_1956_s_1
# 7.2671e-006 F_fleet_1_YR_1957_s_1
# 8.17983e-006 F_fleet_1_YR_1958_s_1
# 9.0838e-006 F_fleet_1_YR_1959_s_1
# 9.99727e-006 F_fleet_1_YR_1960_s_1
# 1.09019e-005 F_fleet_1_YR_1961_s_1
# 1.18158e-005 F_fleet_1_YR_1962_s_1
# 1.27297e-005 F_fleet_1_YR_1963_s_1
# 1.39267e-005 F_fleet_1_YR_1964_s_1
# 1.3828e-005 F_fleet_1_YR_1965_s_1
# 7.21157e-006 F_fleet_1_YR_1966_s_1
# 1.46167e-005 F_fleet_1_YR_1967_s_1
# 2.90551e-005 F_fleet_1_YR_1968_s_1
# 3.70143e-005 F_fleet_1_YR_1969_s_1
# 3.45362e-005 F_fleet_1_YR_1970_s_1
# 3.77214e-005 F_fleet_1_YR_1971_s_1
# 3.33053e-005 F_fleet_1_YR_1972_s_1
# 5.61861e-005 F_fleet_1_YR_1973_s_1
# 5.33366e-005 F_fleet_1_YR_1974_s_1
# 0.000116095 F_fleet_1_YR_1975_s_1
# 0.00010203 F_fleet_1_YR_1976_s_1
# 0.000138325 F_fleet_1_YR_1977_s_1
# 0.00011893 F_fleet_1_YR_1978_s_1
# 9.06816e-005 F_fleet_1_YR_1979_s_1
# 6.62977e-005 F_fleet_1_YR_1980_s_1
# 9.61637e-005 F_fleet_1_YR_1981_s_1
# 9.94463e-005 F_fleet_1_YR_1982_s_1
# 0.000156984 F_fleet_1_YR_1983_s_1
# 0.000221206 F_fleet_1_YR_1984_s_1
# 0.000279642 F_fleet_1_YR_1985_s_1
# 0.000287146 F_fleet_1_YR_1986_s_1
# 0.000222763 F_fleet_1_YR_1987_s_1
# 0.000204992 F_fleet_1_YR_1988_s_1
# 0.000199877 F_fleet_1_YR_1989_s_1
# 0.000476589 F_fleet_1_YR_1990_s_1
# 0.000388039 F_fleet_1_YR_1991_s_1
# 0.00049697 F_fleet_1_YR_1992_s_1
# 0.000686396 F_fleet_1_YR_1993_s_1
# 0.000658944 F_fleet_1_YR_1994_s_1
# 0.000628575 F_fleet_1_YR_1995_s_1
# 0.000495527 F_fleet_1_YR_1996_s_1
# 0.0004698 F_fleet_1_YR_1997_s_1
# 0.000384517 F_fleet_1_YR_1998_s_1
# 0.000461401 F_fleet_1_YR_1999_s_1
# 0.000368292 F_fleet_1_YR_2000_s_1
# 0.000433071 F_fleet_1_YR_2001_s_1
# 0.000526716 F_fleet_1_YR_2002_s_1
# 0.000599953 F_fleet_1_YR_2003_s_1
# 0.000472855 F_fleet_1_YR_2004_s_1
# 0.000489107 F_fleet_1_YR_2005_s_1
# 0.000552465 F_fleet_1_YR_2006_s_1
# 0.000580933 F_fleet_1_YR_2007_s_1
# 0.000863803 F_fleet_1_YR_2008_s_1
# 0.00128972 F_fleet_1_YR_2009_s_1
# 0.00060149 F_fleet_1_YR_2010_s_1
# 0.00111844 F_fleet_1_YR_2011_s_1
# 0.000732799 F_fleet_1_YR_2012_s_1
# 0.000407491 F_fleet_1_YR_2013_s_1
# 0.000327064 F_fleet_1_YR_2014_s_1
# 1.41027e-006 F_fleet_2_YR_1950_s_1
# 0 F_fleet_2_YR_1951_s_1
# 2.11547e-006 F_fleet_2_YR_1952_s_1
# 2.82072e-006 F_fleet_2_YR_1953_s_1
# 3.5261e-006 F_fleet_2_YR_1954_s_1
# 4.23163e-006 F_fleet_2_YR_1955_s_1
# 4.93731e-006 F_fleet_2_YR_1956_s_1
# 5.64317e-006 F_fleet_2_YR_1957_s_1
# 6.34926e-006 F_fleet_2_YR_1958_s_1
# 7.05562e-006 F_fleet_2_YR_1959_s_1
# 7.76229e-006 F_fleet_2_YR_1960_s_1
# 8.46922e-006 F_fleet_2_YR_1961_s_1
# 9.1763e-006 F_fleet_2_YR_1962_s_1
# 9.88337e-006 F_fleet_2_YR_1963_s_1
# 1.03198e-005 F_fleet_2_YR_1964_s_1
# 9.1119e-006 F_fleet_2_YR_1965_s_1
# 2.92158e-006 F_fleet_2_YR_1966_s_1
# 6.91788e-006 F_fleet_2_YR_1967_s_1
# 2.20728e-005 F_fleet_2_YR_1968_s_1
# 1.18948e-005 F_fleet_2_YR_1969_s_1
# 1.94956e-005 F_fleet_2_YR_1970_s_1
# 2.11063e-005 F_fleet_2_YR_1971_s_1
# 2.0432e-005 F_fleet_2_YR_1972_s_1
# 2.41354e-005 F_fleet_2_YR_1973_s_1
# 2.93618e-005 F_fleet_2_YR_1974_s_1
# 4.80498e-005 F_fleet_2_YR_1975_s_1
# 2.65943e-005 F_fleet_2_YR_1976_s_1
# 8.58035e-005 F_fleet_2_YR_1977_s_1
# 7.18062e-005 F_fleet_2_YR_1978_s_1
# 9.69859e-005 F_fleet_2_YR_1979_s_1
# 6.53329e-005 F_fleet_2_YR_1980_s_1
# 5.09082e-005 F_fleet_2_YR_1981_s_1
# 6.45053e-005 F_fleet_2_YR_1982_s_1
# 7.12477e-005 F_fleet_2_YR_1983_s_1
# 0.000373805 F_fleet_2_YR_1984_s_1
# 0.000325235 F_fleet_2_YR_1985_s_1
# 0.000414395 F_fleet_2_YR_1986_s_1
# 0.000443238 F_fleet_2_YR_1987_s_1
# 0.000438465 F_fleet_2_YR_1988_s_1
# 0.000443738 F_fleet_2_YR_1989_s_1
# 0.000425879 F_fleet_2_YR_1990_s_1
# 0.000358038 F_fleet_2_YR_1991_s_1
# 0.00046609 F_fleet_2_YR_1992_s_1
# 0.000453565 F_fleet_2_YR_1993_s_1
# 0.000462456 F_fleet_2_YR_1994_s_1
# 0.000291172 F_fleet_2_YR_1995_s_1
# 0.000292076 F_fleet_2_YR_1996_s_1
# 0.000504508 F_fleet_2_YR_1997_s_1
# 0.000445035 F_fleet_2_YR_1998_s_1
# 0.000574467 F_fleet_2_YR_1999_s_1
# 0.000418094 F_fleet_2_YR_2000_s_1
# 0.000521339 F_fleet_2_YR_2001_s_1
# 0.000567724 F_fleet_2_YR_2002_s_1
# 0.000699665 F_fleet_2_YR_2003_s_1
# 0.00066335 F_fleet_2_YR_2004_s_1
# 0.00047228 F_fleet_2_YR_2005_s_1
# 0.000333848 F_fleet_2_YR_2006_s_1
# 0.000669941 F_fleet_2_YR_2007_s_1
# 0.000558735 F_fleet_2_YR_2008_s_1
# 0.000520029 F_fleet_2_YR_2009_s_1
# 0.000399983 F_fleet_2_YR_2010_s_1
# 0.000368086 F_fleet_2_YR_2011_s_1
# 0.000419703 F_fleet_2_YR_2012_s_1
# 0.000254006 F_fleet_2_YR_2013_s_1
# 0.00029335 F_fleet_2_YR_2014_s_1
# 8.91657e-006 F_fleet_3_YR_1950_s_1
# 0 F_fleet_3_YR_1951_s_1
# 1.33832e-005 F_fleet_3_YR_1952_s_1
# 1.78426e-005 F_fleet_3_YR_1953_s_1
# 2.23113e-005 F_fleet_3_YR_1954_s_1
# 2.67735e-005 F_fleet_3_YR_1955_s_1
# 3.1237e-005 F_fleet_3_YR_1956_s_1
# 3.57017e-005 F_fleet_3_YR_1957_s_1
# 4.01759e-005 F_fleet_3_YR_1958_s_1
# 4.46448e-005 F_fleet_3_YR_1959_s_1
# 4.9116e-005 F_fleet_3_YR_1960_s_1
# 5.35956e-005 F_fleet_3_YR_1961_s_1
# 5.80663e-005 F_fleet_3_YR_1962_s_1
# 6.2535e-005 F_fleet_3_YR_1963_s_1
# 6.70124e-005 F_fleet_3_YR_1964_s_1
# 7.1485e-005 F_fleet_3_YR_1965_s_1
# 7.59592e-005 F_fleet_3_YR_1966_s_1
# 8.04355e-005 F_fleet_3_YR_1967_s_1
# 8.4922e-005 F_fleet_3_YR_1968_s_1
# 8.94039e-005 F_fleet_3_YR_1969_s_1
# 9.38875e-005 F_fleet_3_YR_1970_s_1
# 9.83807e-005 F_fleet_3_YR_1971_s_1
# 0.000102865 F_fleet_3_YR_1972_s_1
# 0.000107354 F_fleet_3_YR_1973_s_1
# 0.000111856 F_fleet_3_YR_1974_s_1
# 0.00011635 F_fleet_3_YR_1975_s_1
# 0.000120846 F_fleet_3_YR_1976_s_1
# 0.000125346 F_fleet_3_YR_1977_s_1
# 0.000129859 F_fleet_3_YR_1978_s_1
# 0.000134368 F_fleet_3_YR_1979_s_1
# 0.000138877 F_fleet_3_YR_1980_s_1
# 0.000144362 F_fleet_3_YR_1981_s_1
# 0.000439186 F_fleet_3_YR_1982_s_1
# 0.000126994 F_fleet_3_YR_1983_s_1
# 0.000178781 F_fleet_3_YR_1984_s_1
# 0.000308555 F_fleet_3_YR_1985_s_1
# 0.000738194 F_fleet_3_YR_1986_s_1
# 0.000769953 F_fleet_3_YR_1987_s_1
# 0.00103317 F_fleet_3_YR_1988_s_1
# 0.000646862 F_fleet_3_YR_1989_s_1
# 0.000869578 F_fleet_3_YR_1990_s_1
# 0.00085841 F_fleet_3_YR_1991_s_1
# 0.00102194 F_fleet_3_YR_1992_s_1
# 0.000897896 F_fleet_3_YR_1993_s_1
# 0.000737372 F_fleet_3_YR_1994_s_1
# 0.000915564 F_fleet_3_YR_1995_s_1
# 0.000453721 F_fleet_3_YR_1996_s_1
# 0.000553614 F_fleet_3_YR_1997_s_1
# 0.000307885 F_fleet_3_YR_1998_s_1
# 0.000454908 F_fleet_3_YR_1999_s_1
# 0.000385118 F_fleet_3_YR_2000_s_1
# 0.000734763 F_fleet_3_YR_2001_s_1
# 0.000518461 F_fleet_3_YR_2002_s_1
# 0.000562431 F_fleet_3_YR_2003_s_1
# 0.000725727 F_fleet_3_YR_2004_s_1
# 0.000524699 F_fleet_3_YR_2005_s_1
# 0.000454205 F_fleet_3_YR_2006_s_1
# 0.000432842 F_fleet_3_YR_2007_s_1
# 0.000430741 F_fleet_3_YR_2008_s_1
# 0.000532028 F_fleet_3_YR_2009_s_1
# 0.000323822 F_fleet_3_YR_2010_s_1
# 0.000890139 F_fleet_3_YR_2011_s_1
# 0.000511342 F_fleet_3_YR_2012_s_1
# 0.000817676 F_fleet_3_YR_2013_s_1
# 0.000776566 F_fleet_3_YR_2014_s_1
# 0.000183655 F_fleet_4_YR_1950_s_1
# 0 F_fleet_4_YR_1951_s_1
# 0.000296468 F_fleet_4_YR_1952_s_1
# 0.000311648 F_fleet_4_YR_1953_s_1
# 0.000404338 F_fleet_4_YR_1954_s_1
# 0.000421507 F_fleet_4_YR_1955_s_1
# 0.000539137 F_fleet_4_YR_1956_s_1
# 0.000617295 F_fleet_4_YR_1957_s_1
# 0.000756148 F_fleet_4_YR_1958_s_1
# 0.00081513 F_fleet_4_YR_1959_s_1
# 0.000814932 F_fleet_4_YR_1960_s_1
# 0.000617085 F_fleet_4_YR_1961_s_1
# 0.000594127 F_fleet_4_YR_1962_s_1
# 0.000677394 F_fleet_4_YR_1963_s_1
# 0.000715511 F_fleet_4_YR_1964_s_1
# 0.000794211 F_fleet_4_YR_1965_s_1
# 0.000781589 F_fleet_4_YR_1966_s_1
# 0.000851367 F_fleet_4_YR_1967_s_1
# 0.000865104 F_fleet_4_YR_1968_s_1
# 0.000983127 F_fleet_4_YR_1969_s_1
# 0.000926238 F_fleet_4_YR_1970_s_1
# 0.000883165 F_fleet_4_YR_1971_s_1
# 0.00117902 F_fleet_4_YR_1972_s_1
# 0.00100289 F_fleet_4_YR_1973_s_1
# 0.000997363 F_fleet_4_YR_1974_s_1
# 0.00100421 F_fleet_4_YR_1975_s_1
# 0.00104736 F_fleet_4_YR_1976_s_1
# 0.00116388 F_fleet_4_YR_1977_s_1
# 0.00124232 F_fleet_4_YR_1978_s_1
# 0.00131387 F_fleet_4_YR_1979_s_1
# 0.00135551 F_fleet_4_YR_1980_s_1
# 0.00128513 F_fleet_4_YR_1981_s_1
# 0.00116888 F_fleet_4_YR_1982_s_1
# 0.00123061 F_fleet_4_YR_1983_s_1
# 0.00144733 F_fleet_4_YR_1984_s_1
# 0.00135661 F_fleet_4_YR_1985_s_1
# 0.00162581 F_fleet_4_YR_1986_s_1
# 0.00143398 F_fleet_4_YR_1987_s_1
# 0.00120461 F_fleet_4_YR_1988_s_1
# 0.00123819 F_fleet_4_YR_1989_s_1
# 0.00112601 F_fleet_4_YR_1990_s_1
# 0.00117932 F_fleet_4_YR_1991_s_1
# 0.00151246 F_fleet_4_YR_1992_s_1
# 0.00119649 F_fleet_4_YR_1993_s_1
# 0.00127877 F_fleet_4_YR_1994_s_1
# 0.00136188 F_fleet_4_YR_1995_s_1
# 0.00167851 F_fleet_4_YR_1996_s_1
# 0.00167566 F_fleet_4_YR_1997_s_1
# 0.00214783 F_fleet_4_YR_1998_s_1
# 0.001219 F_fleet_4_YR_1999_s_1
# 0.00103403 F_fleet_4_YR_2000_s_1
# 0.00122217 F_fleet_4_YR_2001_s_1
# 0.00154663 F_fleet_4_YR_2002_s_1
# 0.0013057 F_fleet_4_YR_2003_s_1
# 0.00134358 F_fleet_4_YR_2004_s_1
# 0.00097382 F_fleet_4_YR_2005_s_1
# 0.00055838 F_fleet_4_YR_2006_s_1
# 0.000365939 F_fleet_4_YR_2007_s_1
# 0.000276504 F_fleet_4_YR_2008_s_1
# 0.000460535 F_fleet_4_YR_2009_s_1
# 0.000344449 F_fleet_4_YR_2010_s_1
# 0.00035968 F_fleet_4_YR_2011_s_1
# 0.00030509 F_fleet_4_YR_2012_s_1
# 0.000340482 F_fleet_4_YR_2013_s_1
# 0.0002634 F_fleet_4_YR_2014_s_1
#
#_Q_setup
 # Q_type options:  <0=mirror, 0=float_nobiasadj, 1=float_biasadj, 2=parm_nobiasadj, 3=parm_w_random_dev, 4=parm_w_randwalk, 5=mean_unbiased_float_assign_to_parm
#_for_env-var:_enter_index_of_the_env-var_to_be_linked
#_Den-dep  env-var  extra_se  Q_type
 0 0 0 0 # 1 CM_E
 0 0 0 0 # 2 CM_W
 0 0 0 0 # 3 REC
 0 0 0 2 # 4 SMP_BYC
 0 0 0 0 # 5 HB_E
 0 0 0 0 # 6 HB_W
 0 0 0 0 # 7 CM_E_IFQ
 0 0 0 0 # 8 CM_W_IFQ
 0 0 0 0 # 9 LARVAL
 0 0 0 0 # 10 VIDEO
 0 0 0 0 # 11 SEAMAP
#
#_Cond 0 #_If q has random component, then 0=read one parm for each fleet with random q; 1=read a parm for each year of index
#_Q_parms(if_any);Qunits_are_ln(q)
# LO HI INIT PRIOR PR_type SD PHASE
 -10 20 1 1 -1 1 1 # LnQ_base_4_SMP_BYC
#
#_size_selex_types
#discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead
#_Pattern Discard Male Special
 0 0 0 0 # 1 CM_E
 0 0 0 0 # 2 CM_W
 0 0 0 0 # 3 REC
 0 3 0 0 # 4 SMP_BYC
 0 0 0 0 # 5 HB_E
 0 0 0 0 # 6 HB_W
 0 0 0 0 # 7 CM_E_IFQ
 0 0 0 0 # 8 CM_W_IFQ
 30 0 0 0 # 9 LARVAL
 24 0 0 0 # 10 VIDEO
 24 0 0 0 # 11 SEAMAP
#
#_age_selex_types
#_Pattern ___ Male Special
 12 0 0 0 # 1 CM_E
 12 0 0 0 # 2 CM_W
 20 0 0 0 # 3 REC
 19 0 0 0 # 4 SMP_BYC
 15 0 0 3 # 5 HB_E
 15 0 0 3 # 6 HB_W
 15 0 0 1 # 7 CM_E_IFQ
 15 0 0 2 # 8 CM_W_IFQ
 10 0 0 0 # 9 LARVAL
 11 0 0 0 # 10 VIDEO
 11 0 0 0 # 11 SEAMAP
#_LO HI INIT PRIOR PR_type SD PHASE env-var use_dev dev_minyr dev_maxyr dev_stddev Block Block_Fxn
 7.5 52.5 25.5979 42.7 -1 0.05 2 0 0 0 0 0.5 0 0 # SizeSel_10P_1_VIDEO
 -10 3 -6.94981 -0.4 -1 0.05 3 0 0 0 0 0.5 0 0 # SizeSel_10P_2_VIDEO
 -6 12 4.06525 5.5 -1 0.05 3 0 0 0 0 0.5 0 0 # SizeSel_10P_3_VIDEO
 -4 6 1.70944 5.1 -1 0.05 3 0 0 0 0 0.5 0 0 # SizeSel_10P_4_VIDEO
 -15 5 -4.85443 -4.2 -1 0.05 2 0 0 0 0 0.5 0 0 # SizeSel_10P_5_VIDEO
 -8 5 -0.253632 0.4 -1 0.05 2 0 0 0 0 0.5 0 0 # SizeSel_10P_6_VIDEO
 7.5 52.5 12.686 13 -1 0.05 2 0 0 0 0 0.5 0 0 # SizeSel_11P_1_SEAMAP
 -10 3 -6.33286 -1.1 -1 0.05 3 0 0 0 0 0.5 0 0 # SizeSel_11P_2_SEAMAP
 -6 12 -2.20435 3.1 -1 0.05 3 0 0 0 0 0.5 0 0 # SizeSel_11P_3_SEAMAP
 -4 6 3.58341 5 -1 0.05 3 0 0 0 0 0.5 0 0 # SizeSel_11P_4_SEAMAP
 -15 5 -0.224954 -4.5 -1 0.05 2 0 0 0 0 0.5 0 0 # SizeSel_11P_5_SEAMAP
 -8 5 -6.66513 0.1 -1 0.05 2 0 0 0 0 0.5 0 0 # SizeSel_11P_6_SEAMAP
 0.5 14 2.097 2.66 -1 0 3 0 0 0 0 0 1 2 # AgeSel_1P_1_CM_E
 0.5 14 0.633029 7.2774 -1 0 1 0 0 0 0 0 1 2 # AgeSel_1P_2_CM_E
 0.5 14 2.63998 2.66 -1 0 3 0 0 0 0 0 1 2 # AgeSel_2P_1_CM_W
 0.5 14 0.902715 7.2774 -1 0 1 0 0 0 0 0 1 2 # AgeSel_2P_2_CM_W
 1 10 2.78556 4.3 -1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_3P_1_REC
 -10 3 -3.06541 -4.6 -1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_3P_2_REC
 -6 12 -0.931782 0.7 -1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_3P_3_REC
 -4 6 2.90828 2.7 -1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_3P_4_REC
 -15 5 -6.54032 -11.2 -1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_3P_5_REC
 -8 5 -4.94275 -3.3 -1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_3P_6_REC
 1e-007 2 0.5 0.5 -1 0 -4 0 0 0 0 0 0 0 # AgeSel_4P_1_SMP_BYC
 0.5 1e+007 100 100 -1 0 -4 0 0 0 0 0 0 0 # AgeSel_4P_2_SMP_BYC
 0.3 3 1.5 1.5 -1 0 -4 0 0 0 0 0 0 0 # AgeSel_4P_3_SMP_BYC
 0.5 1e+007 2.4096 2.4096 -1 0 -4 0 0 0 0 0 0 0 # AgeSel_4P_4_SMP_BYC
 -1 1 0 0 -1 0 -4 0 0 0 0 0 0 0 # AgeSel_4P_5_SMP_BYC
 -1 1 0 0 -1 0 -4 0 0 0 0 0 0 0 # AgeSel_4P_6_SMP_BYC
 0 15 0.1 2.66 -1 0 -1 0 0 0 0 0 0 0 # AgeSel_10P_1_VIDEO
 0 15 14 7.2774 -1 0 -1 0 0 0 0 0 0 0 # AgeSel_10P_2_VIDEO
 0 15 0.1 2.66 -1 0 -1 0 0 0 0 0 0 0 # AgeSel_11P_1_SEAMAP
 0 15 14 7.2774 -1 0 -1 0 0 0 0 0 0 0 # AgeSel_11P_2_SEAMAP
#_Cond 0 #_custom_sel-env_setup (0/1) 
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no enviro fxns
1 #_custom_sel-blk_setup (0/1) 
 0.5 14 2.1288 2.66 -1 0 3 # AgeSel_1P_1_CM_E_BLK1repl_2007
 0.5 14 0.607951 7.2774 -1 0 1 # AgeSel_1P_2_CM_E_BLK1repl_2007
 0.5 14 3.06244 2.66 -1 0 3 # AgeSel_2P_1_CM_W_BLK1repl_2007
 0.5 14 1.07741 7.2774 -1 0 1 # AgeSel_2P_2_CM_W_BLK1repl_2007
#_Cond No selex parm trends 
#_Cond -4 # placeholder for selparm_Dev_Phase
3 #_env/block/dev_adjust_method (1=standard; 2=logistic trans to keep in base parm bounds; 3=standard w/ no bound check)
#
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
1 #_Variance_adjustments_to_input_values
#_fleet: 1 2 3 4 5 6 7 8 9 10 11 
  0 0 0 0 0 0 0 0 0 0 0 #_add_to_survey_CV
  0 0 0 0 0 0 0 0 0 0 0 #_add_to_discard_stddev
  0 0 0 0 0 0 0 0 0 0 0 #_add_to_bodywt_CV
  1 1 1 1 1 1 1 1 1 1 1 #_mult_by_lencomp_N
  1 1 1 1 1 1 1 1 1 1 1 #_mult_by_agecomp_N
  1 1 1 1 1 1 1 1 1 1 1 #_mult_by_size-at-age_N
#
4 #_maxlambdaphase
1 #_sd_offset
#
0 # number of changes to make to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch; 
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark
#like_comp fleet/survey  phase  value  sizefreq_method
#
# lambdas (for info only; columns are phases)
#  1 1 1 1 #_CPUE/survey:_1
#  1 1 1 1 #_CPUE/survey:_2
#  1 1 1 1 #_CPUE/survey:_3
#  1 1 1 1 #_CPUE/survey:_4
#  1 1 1 1 #_CPUE/survey:_5
#  1 1 1 1 #_CPUE/survey:_6
#  1 1 1 1 #_CPUE/survey:_7
#  1 1 1 1 #_CPUE/survey:_8
#  1 1 1 1 #_CPUE/survey:_9
#  1 1 1 1 #_CPUE/survey:_10
#  1 1 1 1 #_CPUE/survey:_11
#  0 0 0 0 #_discard:_1
#  0 0 0 0 #_discard:_2
#  0 0 0 0 #_discard:_3
#  1 1 1 1 #_discard:_4
#  0 0 0 0 #_discard:_5
#  0 0 0 0 #_discard:_6
#  0 0 0 0 #_discard:_7
#  0 0 0 0 #_discard:_8
#  0 0 0 0 #_discard:_9
#  0 0 0 0 #_discard:_10
#  0 0 0 0 #_discard:_11
#  0 0 0 0 #_lencomp:_1
#  0 0 0 0 #_lencomp:_2
#  0 0 0 0 #_lencomp:_3
#  0 0 0 0 #_lencomp:_4
#  0 0 0 0 #_lencomp:_5
#  0 0 0 0 #_lencomp:_6
#  0 0 0 0 #_lencomp:_7
#  0 0 0 0 #_lencomp:_8
#  0 0 0 0 #_lencomp:_9
#  1 1 1 1 #_lencomp:_10
#  1 1 1 1 #_lencomp:_11
#  1 1 1 1 #_agecomp:_1
#  1 1 1 1 #_agecomp:_2
#  1 1 1 1 #_agecomp:_3
#  0 0 0 0 #_agecomp:_4
#  0 0 0 0 #_agecomp:_5
#  0 0 0 0 #_agecomp:_6
#  0 0 0 0 #_agecomp:_7
#  0 0 0 0 #_agecomp:_8
#  0 0 0 0 #_agecomp:_9
#  0 0 0 0 #_agecomp:_10
#  0 0 0 0 #_agecomp:_11
#  1 1 1 1 #_init_equ_catch
#  1 1 1 1 #_recruitments
#  1 1 1 1 #_parameter-priors
#  1 1 1 1 #_parameter-dev-vectors
#  1 1 1 1 #_crashPenLambda
#  0 0 0 0 # F_ballpark_lambda
0 # (0/1) read specs for more stddev reporting 
 # 0 1 -1 5 1 5 1 -1 5 # placeholder for selex type, len/age, year, N selex bins, Growth pattern, N growth ages, NatAge_area(-1 for all), NatAge_yr, N Natages
 # placeholder for vector of selex bins to be reported
 # placeholder for vector of growth ages to be reported
 # placeholder for vector of NatAges ages to be reported
999

