#V3.24f																															
#_data_and_control_files:	data.ss	//	control.ss																												
#_SS-V3.24f-safe;_08/03/2012;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_10.1																															
1	#_N_Growth_Patterns																														
1	#_N_Morphs_Within_GrowthPattern																														
#2	# N recruitment	designs	go here if N_GP*nseas*area>1 - Red Snapper is a 2 area model																							
#0	# placeholder for recruitment interaction request																									
#1 1 1	#_recruitment design element for GP=1, seas=1, area=1																						
#1 1 2	#_recruitment design element for GP=1, seas=1, area=2																						
#0	# N_movement_definitions goes here if N_areas >	1	
#ADD A BLOCK TO RECREATIONAL SELECTIVITY 2010-2013																						
1	#_Nblock_Patterns																														
1	#_blocks_per_pattern																											
# begin	and end	years of blocks																									
2007 2014	#BLOCK 1 used for commercial size limit, and <100% retention during IFQ period																						
#																															
0.5	#_fracfemale																														
3	#_natM_type:_0=1Parm;	1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate																													
#3	#_reference	age	for	Lorenzen	function																										
#_Age_natmort_by	gender	x	growthpattern																												
0.234 0.342 0.287 0.257 0.239 0.228 0.220 0.215 0.212 0.209 0.207 0.206 0.205 0.204 0.204										
1	#	GrowthModel:	1=vonBert	with	L1&L2;	2=Richards	with	L1&L2;	3=age_speciific_K;	4=not	implemented																				
.5	#_Growth_Age_for_L1																														
999	#_Growth_Age_for_L2	(999	to	use	as	Linf)																									
0	#_SD_add_to_LAA	(set	to	0.1	for	SS2	V1.x	compatibility)
#UPDATE CV GROWTH - SHOULD BE 1 NOT 0																							
1	#_CV_Growth_Pattern:	0	CV=f(LAA);	1	CV=F(A);	2	SD=F(LAA);	3	SD=F(A);	4	logSD=F(A)																				
1	#_maturity_option:	1=length	logistic;	2=age	logistic;	3=read	age-maturity	matrix	by	growth_pattern;	4=read	age-fecundity;	5=read	fec	and	wt	from	wtatage.ss													
#0 3.16E+6 3.33E+6  3.51E+6  3.69E+6  3.87E+6  4.05E+6  4.23E+6  4.41E+6  4.59E+6  4.77E+6  4.94E+6  5.12E+6  5.30E+6  5.48E+6                    
1	#_First_Mature_Age																														
2	#_fecundity	option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b;	(4)eggs=a+b*L;	(5)eggs=a+b*W																											
0	#_hermaphroditism	option:	0=none;	1=age-specific	fxn																										
1	#_parameter_offset_approach	(1=none,	2=	M,	G,	CV_G	as	offset	from	female-GP1,	3=like	SS2	V1.x)																		
2	#_env/block/dev_adjust_method	(1=standard;	2=logistic	transform	keeps	in	base	parm	bounds;	3=standard	w/	no	bound	check)																	
#																															
#	Prior	types	(-1	=	none,	0=normal,	1=symmetric	beta,	2=full	beta,	3=lognormal)																				
#_growth_parms																															
#_LO	HI	INIT	PRIOR	PR_type	SD	PHASE	env-var	use_dev	dev_minyr	dev_maxyr	dev_stddev	Block	Block_Fxn																		
#0.01    0.5     0.257     0.257    3       0.5     -1      0       0       0               0               0               0       0 #NatM_p_1_Fem_GP_1																			
0.0001  1000000 11.83    11.83  -1      0       -1      0       0       0               0               0               0       0 #L_at_Amin_Fem_GP_1																
0.0001  1000000 34.4     34.4   -1      0       -1      0       0       0               0               0               0       0 #L_at_Amax_Fem_GP_1																
0       1000000 0.3254   0.3254    -1      0       -1      0       0       0               0               0               0       0 #VonBert_K_Fem_GP_1																
0       1000000 0.2535   0.0001 -1      0       -1      0       0       0               0               0               0       0 #CV_young_Fem_GP_1																
0       1000000 0.2535   0.0001 -1      0       -1      0       0       0               0               0               0       0 #CV_old_Fem_GP_1																
0       1000000 0.0000219 0.0000219 -1  0       -1      0       0       0               0               0               0       0 #Wtlen_1_Fem																
0       1000000 2.916      2.916  -1      0       -1      0       0       0               0               0               0       0 #Wtlen_2_Fem																
0       1000000 14.087 14.087  -1     0       -1      0       0       0               0               0               0       0 #Mat50%_Fem																
0       1000000 -0.574 -0.574  -1     0       -1      0       0       0               0               0               0       0 #Mat_slope_Fem																
0       1000000 278.7146 278.7146 -1     0       -1      0       0       0               0               0               0       0 # Fec_1_Fem              
0       1000000 3.042  3.042 -1     0       -1      0       0       0               0               0               0       0 # Fec_2_Fem 															
-4      4       0         0      -1     99      -4      0       0       0               0               0               0       0 #RecrDist_GP_1																
-4      4       1         1      -1     0.01    -4      0       0       0               0               0               0       0 #RecrDist_Area1																
#-4	4	0	0	-1	1	-4	0	0	0	0	0	0	0	#RecrDist_Area2																
-4      4       1       1       -1      0.01    -4      0       0       0               0               0               0       0 #RecrDist_Seas_1																
1       1       1       1       -1      0       -4      0       0       0               0               0               0       0 #CohortGrowDev																
#																															
#_Cond	0	#custom_MG-env_setup	(0/1)																												
#_Cond	-2	2	0	0	-1	99	-2	#_placeholder	when	no	MG-environ	parameters																			
#																															
#_Cond	0	#custom_MG-block_setup	(0/1)																												
#_Cond	-2	2	0	0	-1	99	-2	#_placeholder	when	no	MG-block	parameters																			
#_Cond	No	MG	parm	trends																											
#																															
#_seasonal_effects_on_biology_parms																															
	0	0	0	0	0	0	0	0	0	0	#_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K																				
#_Cond	-2	2	0	0	-1	99	-2	#_placeholder	when	no	seasonal	MG	parameters																		
#																															
#5	#_MGparm_Dev_Phase only if phase to any of the MG_parm																														
#																															
#_Spawner-Recruitment																															
3	#_SR_function:	2=Ricker;	3=std_B-H;	4=SCAA;	5=Hockey;	6=B-H_flattop;	7=survival_3Parm																								
#_LO	HI	INIT	PRIOR	PR_type	SD	PHASE																									
0.0     13.82   6.91    6.91    -1      0       1 #SR_LN(R0)	1	20	11.8	11.8	-1	1	1																							
0.22    0.96    0.6     0.6     -3       0.74    2 #SR_BH_steep    0.2	1	0.99	0.99	-1	1	-4																							
0       2     0.4     0.2     -1      0       3 #SR_sigmaR	0	2	0.3	0.3	-1	1	-4																							
-5      5       0       0       -1      0       -3 #SR_envlink	-5	5	0	0	-1	1	3																							
-5      5       0       0       -1      0       -3 #SR_R1_offset	-5	5	0	0	-1	1	-4																							
0       0.5     0       0       -1      0       -2 #SR_autocorr	0	0	0	0	-1	0	-99																							
0	#_SR_env_link																														
0	#_SR_env_target_0=none;1=devs;_2=R0;_3=steepness																														
1	#do_recdev:	0=none;	1=devvector;	2=simple	deviations																										
1994	#	first	year	of	main	recr_devs;	early	devs	can	preceed	this	era																			
2012	#	last	year	of	main	recr_devs;	forecast	devs	start	in	following	year																			
3	#_recdev	phase

1	#	(0/1)	to	read	13	advanced	options																								
0	#_recdev_early_start	(0=none;	neg	value	makes	relative	to	recdev_start)																							
4	#_recdev_early_phase																														
5 #0	#_forecast_recruitment	phase	(incl.	late	recr)	(0	value	resets	to	maxphase+1)																					
1	#_lambda	for	Fcast_recr_like	occurring	before	endyr+1	
# Bias adjustment from R4SS output from 4.Video Survey Run																								
 1986.5277 #_last_early_yr_nobias_adj_in_MPD                   
 1995.8285 #_first_yr_fullbias_adj_in_MPD                      
 2010.7167 #_last_yr_fullbias_adj_in_MPD                       
 2014.1802 #_first_recent_yr_nobias_adj_in_MPD                 
    0.8538 #_max_bias_adj_in_MPD (1.0 to mimic pre-2009 models)											
0	#_period	of	cycles	in	recruitment	(N	parms	read	below)																						
-5	#min	rec_dev																													
5	#max	rec_dev																													
0	#_read_recdevs																														
#_end	of	advanced	SR	options																											
#																															
#Fishing	Mortality	info																													
0.5	#	F	ballpark	for	tuning	early	phases																								
-2001	#	F	ballpark	year	(neg	value	to	disable)																							
2	#	F_Method:	1=Pope;	2=instan.	F;	3=hybrid	(hybrid	is	recommended)																						
4	#	max	F	or	harvest	rate,	depends	on	F_Method																						
#	no	additional	F	input	needed	for	Fmethod	1																							
#	if	Fmethod=2;	read	overall	start	F	value;	overall	phase;	N	detailed	inputs	to	read																	
#	5	#	if	Fmethod=3;	read	N	iterations	for	tuning	for	Fmethod	3																			
0.05	1	0	#	overall	start	F	value;	overall	phase;	N	detailed	inputs	to	read																	
#Fleet	Year	Seas	F_value	se	phase	(for	detailed	setup	of	F_Method=2)																					
#1	1872	1	0.05	0.05	1																										
#2	1880	1	0.05	0.05	1																										
#3	1980	1	0.05	0.05	1																										
#4	1976	1	0.05	0.05	1																										
#5	1950	1	0.05	0.05	1																										
#6	1950	1	0.05	0.05	1																										
#7	1950	1	0.05	0.05	1																										
#8	1950	1	0.05	0.05	1																										
#9	1991	1	0.05	0.05	1																										
#10	1991	1	0.05	0.05	1																										
#11	1997	1	0.05	0.05	1																										
#12	1997	1	0.05	0.05	1																										
#13	1950	1	0.05	0.05	1																										
#14	1946	1	0.05	0.05	1																										
#																															
#_initial_F_parms																															
#_LO	HI	INIT	PRIOR	PR_type	SD	PHASE																									
0	1	0	0.01	0	99	-1	#_CME																								
0	1	0	0.01	0	99	-1	#_CMW																							
0	1	0	0.01	0	99	-1	#_Rec																																															
0	1	0	0.01	0	99	-1	#_Shr																																														
#																															
#_Q_setup																															
#	Q_type	options:	<0=mirror,	0=float_nobiasadj,	1=float_biasadj,	2=parm_nobiasadj,	3=parm_w_random_dev,	4=parm_w_randwalk,	5=mean_unbiased_float_assign_to_parm																						
#_for_env-var:_enter_index_of_the_env-var_to_be_linked																															
#_Den-dep	env-var	extra_se	Q_type																												
0 0 0 0 # CM-E *NEW*                     
0 0 0 0 # CM-W *NEW*                      
0 0 0 0 # REC *NEW*                      
0 0 0 2 # SMP-BYC *NEW*                     
0 0 0 0 # HB-E *NEW*
0 0 0 0 # HB-W *NEW*  	
0 0 0 0 # CM-E-IFQ *NEW*
0 0 0 0 # CM-W-IFQ *NEW*
0 0 0 0 # LARVAL	
0 0 0 0 # VIDEO	
0 0 0 0 #SEAMAP																							
#																															
#_Cond	0	#_If	q	has	random	component,	then	0=read	one	parm	for	each	fleet	with	random	q;	1=read	a	parm	for	each	year	of	index							
#_Q_parms(if_any)																															
#LO	HI	INIT	PRIOR	PR_type	SD	PHASE																								
-10      20      1         1    -1      1       1 # SMP-BYC
#																															
#_size_selex_types
#discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead																															
#_Pattern	Discard	Male	Special																												
0 0 0 0 # CM_E                        
0 0 0 0 # CM_W                        
0 0 0 0 # REC                        
0 3 0 0 # SMP_BYC                        
0 0 0 0 # HB-E
0 0 0 0 # HB-W																									
0 0 0 0 # CM-E-IFQ
0 0 0 0 # CM-W-IFQ	
30 0 0 0 #LARVAL
24 0 0 0 # VIDEO
24 0 0 0 # SEAMAP
#_age_selex_types																															
#_Pattern	_Discard__	Male	Special
12 0 0 0 # CM_E  12=logistic                        
12 0 0 0 # CM_W                        
20 0 0 0 # REC                        
19 0 0 0 # SMP_BYC  19=double logistic                      
15 0 0 3 # HB-E
15 0 0 3 # HB-W  15=mirror, special=fleet to mirror
15 0 0 1 # CM-E-IFQ
15 0 0 2 # CM-W-IFQ 
10 0 0 0 # LARVAL
11 0 0 0 # VIDEO
11 0 0 0 # SEAMAP
#_LO             HI        INIT       PRIOR     PR_type  SD    PHASE   env-var   use_dev dev_minyr dev_maxyr dev_stddev Block Block_Fxn   
7.5	52.5 42.7	42.7	-1	0.05	2	0	0	0	0	0.5	0	0	#	PEAK
-10.0	3.0	-0.4	-0.4	-1	0.05	3	0	0	0	0	0.5	0	0	#	TOP
-6.0	12.0	5.5	5.5	-1	0.05	3	0	0	0	0	0.5	0	0	#	WIDTH
-4.0	6.0	5.1	5.1	-1	0.05	3	0	0	0	0	0.5	0	0	#	WIDTH
-15.0	5.0	-4.2	-4.2	-1	0.05	2	0	0	0	0	0.5	0	0	#	INIT
-8.0	5.0	0.4	0.4	-1	0.05	2	0	0	0	0	0.5	0	0	#	FINAL
7.5	52.5	13.0	13.0	-1	0.05	2	0	0	0	0	0.5	0	0	#	PEAK
-10.0	3.0	-1.1	-1.1	-1	0.05	3	0	0	0	0	0.5	0	0	#	TOP
-6.0	12.0	3.1	3.1	-1	0.05	3	0	0	0	0	0.5	0	0	#	WIDTH
-4.0	6.0	5.0	5.0	-1	0.05	3	0	0	0	0	0.5	0	0	#	WIDTH
-15.0	5.0	-4.5	-4.5	-1	0.05	2	0	0	0	0	0.5	0	0	#	INIT
-8.0	5.0	0.1	0.1	-1	0.05	2	0	0	0	0	0.5	0	0	#	FINAL
0.5              14       2.66       2.66      -1       0     3       0         0 0 0 0 1 2 #CM_E_AgeSel_p1 size at inflection
0.5              14      7.2774     7.2774    -1       0     1       0         0 0 0 0 1 2 #CM_E_AgeSel_p2 width of 95% selection
0.5              14        2.66      2.66      -1       0     3       0         0 0 0 0 1 2 #CM_W_AgeSel_p1
0.5              14       7.2774    7.2774    -1       0     1       0         0 0 0 0 1 2 #CM_W_AgeSel_p2
1	10	4.3	4.3	-1	0.05	2	0	0	0	0	0.5	0	0	#	PEAK	value
-10.0	3.0	-4.6	-4.6	-1	0.05	3	0	0	0	0	0.5	0	0	#	TOP	logistic
-6.0	12.0	0.7	0.7	-1	0.05	3	0	0	0	0	0.5	0	0	#	WIDTH	exp
-4.0	6.0	2.7	2.7	-1	0.05	3	0	0	0	0	0.5	0	0	#	WIDTH	exp
-15.0	5.0	-11.2	-11.2	-1	0.05	2	0	0	0	0	0.5	0	0	#	INIT	logistic
-8.0	5.0	-3.3	-3.3	-1	0.05	2	0	0	0	0	0.5	0	0	#	FINAL	logistic
0.0000001        2.0        0.5       0.5       -1       0     -4       0        0 0 0 0 0 0 #SMP_BYC_AgeSel_p1
0.5              10000000.0 100.0     100.0     -1       0     -4       0        0 0 0 0 0 0 #SMP_BYC_AgeSel_p2
0.3              3.0        1.5       1.5       -1       0     -4       0        0 0 0 0 0 0 #SMP_BYC_AgeSel_p3
0.5              10000000.0 2.4096    2.4096    -1       0     -4       0        0 0 0 0 0 0 #SMP_BYC_AgeSel_p4
-1               1          0         0         -1       0     -4       0        0 0 0 0 0 0 #SMP_BYC_AgeSel_p5
-1                1         0         0         -1       0     -4       0        0 0 0 0 0 0 #SMP_BYC_AgeSel_p6 
0             15       0.1      2.66       -1       0     -1       0  0 0 0 0 0 0 #VIDEO_AGESel_p1
0             15       14       7.2774     -1       0     -1       0  0 0 0 0 0 0 #VIDEO_AGESel_p2  
0             15       0.1      2.66       -1       0     -1       0  0 0 0 0 0 0 #SEAMAP_AGESel_p1
0             15       14       7.2774     -1       0     -1       0  0 0 0 0 0 0 #SEAMAP_AGESel_p2  
#_Cond 0 #_custom_sel-env_setup (0/1) 
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no enviro fxns
1 #_custom_sel-blk_setup (0/1) 
0.5     14       2.66       2.66      -1       0     3      #CM_E_AgeSel_p1
0.5    14      7.2774     7.2774    -1       0     1       #CM_E_AgeSel_p2
0.5     14       2.66      2.66      -1       0     3       #CM_W_AgeSel_p1
0.5    14      7.2774     7.2774    -1       0     1       #CM_W_AgeSel_p2
 #_Cond	No	selex	parm	trends																											
#_Cond	-4	#	placeholder	for	selparm_Dev_Phase																										
3	#_env/block/dev_adjust_method	(1=standard;	2=logistic	trans	to	keep	in	base	parm	bounds;	3=standard	w/	no	bound	check)																
#																															
#	Tag	loss	and	Tag	reporting	parameters	go	next																							
0	#	TG_custom:	0=no	read;	1=read	if	tags	exist																							
#_Cond	-6	6	1	1	2	0.01	-4	0	0	0	0	0	0	0	#_placeholder	if	no	parameters													
#																															
1	#_Variance_adjustments_to_input_values																														
#fleet_1 2 3 4 5 6 7 8 9 10 11                 
0 0 0 0 0 0 0 0 0 0 0 #_add_to_survey_CV                      
0 0 0 0 0 0 0 0 0 0 0 #_add_to_discard_stddev                      
0 0 0 0 0 0 0 0 0 0 0 #_add_to_bodywt_CV                      
1 1 1 1 1 1 1 1 1 1 1 #_mult_by_lencomp_N                      
1 1 1 1 1 1 1 1 1 1 1 #_mult_by_agecomp_N                      
1 1 1 1 1 1 1 1 1 1 1 #_mult_by_size-at-age_N                      
# 30 #_DF_for_discard_like *NEW* commented out                           
# 30 #_DF_for_meanbodywt_like *NEW* commented out      																														
4	#_maxlambdaphase																														
1	#_sd_offset																														
#																															
0	#	number	of	changes	to	make	to	default	Lambdas	(default	value	is	1.0)																		
#	Like_comp	codes:	1=surv;	2=disc;	3=mnwt;	4=length;	5=age;	6=SizeFreq;	7=sizeage;	8=catch;																					
#	9=init_equ_catch;	10=recrdev;	11=parm_prior;	12=parm_dev;	13=CrashPen;	14=Morphcomp;	15=Tag-comp;	16=Tag-negbin																							
#like_comp	fleet/survey	phase	value	sizefreq_method																											
#	2	7	1	0.6	1																										
#	2	8	1	0.6	1																										
#																															
#	lambdas	(for	info	only;	columns	are	phases)																								
#	0	#_CPUE/survey:_1																													
#	1	#_CPUE/survey:_2																													
#	1	#_CPUE/survey:_3																													
#	1	#_CPUE/survey:_4																													
#	1	#_discard:_1																													
#	1	#_discard:_2																													
#	1	#_discard:_3																													
#	0	#_discard:_4																													
#	1	#_lencomp:_1																													
#	1	#_lencomp:_2																													
#	1	#_lencomp:_3																													
#	0	#_lencomp:_4																													
#	0	#_agecomp:_1																													
#	1	#_agecomp:_2																													
#	0	#_agecomp:_3																													
#	0	#_agecomp:_4																													
#	1	#_init_equ_catch																													
#	1	#_recruitments																													
#	1	#_parameter-priors																													
#	1	#_parameter-dev-vectors																													
#	1	#_crashPenLambda																													
0	#	(0/1)	read	specs	for	more	stddev	reporting																							
#	0	1	-1	5	1	5	1	-1	5	#	placeholder	for	selex	type,	len/age,	year,	N	selex	bins,	Growth	pattern,	N	growth	ages,	NatAge_area(-1	for	all),	NatAge_yr,	N	Natages
#	placeholder	for	vector	of	selex	bins	to	be	reported																					
#	placeholder	for	vector	of	growth	ages	to	be	reported																					
#	placeholder	for	vector	of	NatAges	ages	to	be	reported																					
999																															
