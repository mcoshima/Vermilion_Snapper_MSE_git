#V3.24f																															
#_data_and_control_files:	data.ss	//	control.ss																												
#_SS-V3.24f-safe;_08/03/2012;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_10.1																															
1	#_N_Growth_Patterns																														
1	#_N_Morphs_Within_GrowthPattern																														
2	# N recruitment	designs	go here if N_GP*nseas*area>1 - Red Snapper is a 2 area model																							
0	# placeholder for recruitment interaction request																									
1 1 1	#_recruitment design element for GP=1, seas=1, area=1																						
1 1 2	#_recruitment design element for GP=1, seas=1, area=2																						
0	# N_movement_definitions goes here if N_areas >	1	
#ADD A BLOCK TO RECREATIONAL SELECTIVITY 2010-2013																						
5	#_Nblock_Patterns																														
4 4 1 1 2	#_blocks_per_pattern																											
# begin	and end	years of blocks																									
1985 1993 1994 1994 1995 2006 2007 2016	#BLOCK 1 used for commercial size limit, and <100% retention during IFQ period																						
1985 1993 1994 1994 1995 1999 2000 2016	#BLOCK 2 used for recreational size limit																							
2007 2016 #BLOCK 3 used for change in commercial selectivity with implementation of IFQ																														
2008 2016 #BLOCK 4 used for discard mortality 
2008 2010 2011 2016 #BLOCK 5 used for recreational selectivity change (implementation of circle hooks, etc)																														
#																															
0.5	#_fracfemale																														
3	#_natM_type:_0=1Parm;	1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate																													
#3	#_reference	age	for	Lorenzen	function																										
#_Age_natmort_by	gender	x	growthpattern																												
1	1.6	0.695	0.17	0.14	0.122	0.11	0.103	0.097	0.093	0.09	0.087	0.085	0.084	0.083	0.082	0.081	0.08	0.08	0.079	0.079											
1	#	GrowthModel:	1=vonBert	with	L1&L2;	2=Richards	with	L1&L2;	3=age_speciific_K;	4=not	implemented																				
0.75	#_Growth_Age_for_L1																														
999	#_Growth_Age_for_L2	(999	to	use	as	Linf)																									
0	#_SD_add_to_LAA	(set	to	0.1	for	SS2	V1.x	compatibility)
#UPDATE CV GROWTH - SHOULD BE 1 NOT 0																							
1	#_CV_Growth_Pattern:	0	CV=f(LAA);	1	CV=F(A);	2	SD=F(LAA);	3	SD=F(A);	4	logSD=F(A)																				
4	#_maturity_option:	1=length	logistic;	2=age	logistic;	3=read	age-maturity	matrix	by	growth_pattern;	4=read	age-fecundity;	5=read	fec	and	wt	from	wtatage.ss													
0	0	350000	2620000	9070000	20300000	34710000	49950000	64270000	76760000	87150000	95530000	102150000	107300000	111270000	114300000	116610000	118360000	119680000	120670000	123234591											
2	#_First_Mature_Age																														
3	#_fecundity	option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b;	(4)eggs=a+b*L;	(5)eggs=a+b*W																											
0	#_hermaphroditism	option:	0=none;	1=age-specific	fxn																										
1	#_parameter_offset_approach	(1=none,	2=	M,	G,	CV_G	as	offset	from	female-GP1,	3=like	SS2	V1.x)																		
2	#_env/block/dev_adjust_method	(1=standard;	2=logistic	transform	keeps	in	base	parm	bounds;	3=standard	w/	no	bound	check)																	
#																															
#	Prior	types	(-1	=	none,	0=normal,	1=symmetric	beta,	2=full	beta,	3=lognormal)																				
#_growth_parms																															
#_LO	HI	INIT	PRIOR	PR_type	SD	PHASE	env-var	use_dev	dev_minyr	dev_maxyr	dev_stddev	Block	Block_Fxn																		
#	0.2	0.5	0.38	0.4	0	1	-3	0	0	0	0	0	0	0	#	NatM_p_1_Fem_GP_1															
7	21	9.96	9.96	-1	1	-3	0	0	0	0	0	0	0	#	L_at_Amin_Fem_GP_1																
70	100	85.64	85.64	-1	1	-3	0	0	0	0	0	0	0	#	L_at_Amax_Fem_GP_1																
0.05	0.8	0.1919	0.1919	-1	1	-3	0	0	0	0	0	0	0	#	VonBert_K_Fem_GP_1																
0.01	0.5	0.1735	0.1735	-1	1	-5	0	0	0	0	0	0	0	#	CV_young_Fem_GP_1																
0.01	0.5	0.0715	0.0715	-1	1	-5	0	0	0	0	0	0	0	#	CV_old_Fem_GP_1																
0	1	0.00001673	0.00001673	-1	1	-3	0	0	0	0	0	0	0	#	Wtlen_1_Fem																
0	4	2.953	2.953	-1	1	-3	0	0	0	0	0	0	0	#	Wtlen_2_Fem																
50	1000	999	999	-1	1	-3	0	0	0	0	0	0	0	#	Mat50%_Fem																
-1	1000	999	999	-1	1	-3	0	0	0	0	0	0	0	#	Mat_slope_Fem																
0	1000	999	999	-1	1	-3	0	0	0	0	0	0	0	#	Eggs/kg_inter_Fem																
0	1000	999	999	-1	1	-3	0	0	0	0	0	0	0	#	Eggs/kg_slope_wt_Fem																
0	0	0	0	-1	0	-4	0	0	0	0	0	0	0	#	RecrDist_GP_1																
-4	4	-0.8	-0.8	-1	1	4	0	2	1972	2016	0.1	0	0	#	RecrDist_Area1																
-4	4	0	0	-1	1	-4	0	0	0	0	0	0	0	#	RecrDist_Area2																
0	0	0	0	-1	0	-4	0	0	0	0	0	0	0	#	RecrDist_Seas_1																
0	0	1	1	-1	0	-4	0	0	0	0	0	0	0	#	CohortGrowDev																
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
5	#_MGparm_Dev_Phase																														
#																															
#_Spawner-Recruitment																															
3	#_SR_function:	2=Ricker;	3=std_B-H;	4=SCAA;	5=Hockey;	6=B-H_flattop;	7=survival_3Parm																								
#_LO	HI	INIT	PRIOR	PR_type	SD	PHASE																									
	1	20	11.8	11.8	-1	1	1	#	SR_LN(R0)																						
	0.2	1	0.99	0.99	-1	1	-4	#	SR_BH_steep																						
	0	2	0.3	0.3	-1	1	-4	#	SR_sigmaR																						
	-5	5	0	0	-1	1	3	#	SR_envlink																						
	-5	5	0	0	-1	1	-4	#	SR_R1_offset																						
	0	0	0	0	-1	0	-99	#	SR_autocorr																						
1	#_SR_env_link																														
2	#_SR_env_target_0=none;1=devs;_2=R0;_3=steepness																														
1	#do_recdev:	0=none;	1=devvector;	2=simple	deviations																										
1899	#	first	year	of	main	recr_devs;	early	devs	can	preceed	this	era																			
2016	#	last	year	of	main	recr_devs;	forecast	devs	start	in	following	year																			
4	#_recdev	phase																													
1	#	(0/1)	to	read	13	advanced	options																								
0	#_recdev_early_start	(0=none;	neg	value	makes	relative	to	recdev_start)																							
-5	#_recdev_early_phase																														
0	#_forecast_recruitment	phase	(incl.	late	recr)	(0	value	resets	to	maxphase+1)																					
1	#_lambda	for	Fcast_recr_like	occurring	before	endyr+1																									
1971.4   #_last_early_yr_nobias_adj_in_MPD 
1971.6   #_first_yr_fullbias_adj_in_MPD 
2015.9   #_last_yr_fullbias_adj_in_MPD 
2017.0   #_first_recent_yr_nobias_adj_in_MPD 
0.9229   #_max_bias_adj_in_MPD (1.0 to mimic pre-2009 models)   
0	#_period	of	cycles	in	recruitment	(N	parms	read	below)																						
-5	#min	rec_dev																													
5	#max	rec_dev																													
0	#_read_recdevs																														
#_end	of	advanced	SR	options																											
#																															
#Fishing	Mortality	info																													
0.3	#	F	ballpark	for	tuning	early	phases																								
-2001	#	F	ballpark	year	(neg	value	to	disable)																							
2	#	F_Method:	1=Pope;	2=instan.	F;	3=hybrid	(hybrid	is	recommended)																						
2.9	#	max	F	or	harvest	rate,	depends	on	F_Method																						
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
0	1	0	0.01	0	99	-1	#_HLE																								
0	1	0	0.01	0	99	-1	#_HL_W																								
0	1	0	0.01	0	99	-1	#_LL_E																								
0	1	0	0.01	0	99	-1	#_LL_W																								
0	1	0	0.01	0	99	-1	#_MRIP_E																								
0	1	0	0.01	0	99	-1	#_MRIP_W																								
0	1	0	0.01	0	99	-1	#_HBT_E																								
0	1	0	0.01	0	99	-1	#_HBT_W																								
0	1	0	0.01	0	99	-1	#_C_Clsd_E																								
0	1	0	0.01	0	99	-1	#_C_Clsd_W																								
0	1	0	0.01	0	99	-1	#_R_Clsd_E																								
0	1	0	0.01	0	99	-1	#_R_Clsd_W																								
0	1	0	0.01	0	99	-1	#_Shr_E																								
0	1	0	0.01	0	99	-1	#_Shr_W																								
#																															
#_Q_setup																															
#	Q_type	options:	<0=mirror,	0=float_nobiasadj,	1=float_biasadj,	2=parm_nobiasadj,	3=parm_w_random_dev,	4=parm_w_randwalk,	5=mean_unbiased_float_assign_to_parm																						
#_for_env-var:_enter_index_of_the_env-var_to_be_linked																															
#_Den-dep	env-var	extra_se	Q_type																												
0	0	0	0	#_HLE																											
0	0	0	0	#_HL_W																											
0	0	0	0	#_LL_E																											
0	0	0	0	#_LL_W																											
0	0	0	0	#_MRIP_E																											
0	0	0	0	#_MRIP_W																											
0	0	0	0	#_HBT_E																											
0	0	0	0	#_HBT_W																											
0	0	0	0	#_C_Clsd_E																											
0	0	0	0	#_C_Clsd_W																											
0	0	0	0	#_R_Clsd_E																											
0	0	0	0	#_R_Clsd_W																											
0	0	0	2	#_Shr_E																											
0	0	0	2	#_Shr_W																											
0	0	0	0	#_Video_E																											
0	0	0	0	#_Video_W																											
0	0	0	0	#_Larv_E																											
0	0	0	0	#_Larv_W																											
0	0	0	0	#_Sum_E																											
0	0	0	0	#_Sum_W																											
0	0	0	0	#_Fall_E																											
0	0	0	0	#_Fall_W																											
0	0	0	0	#_BLL_W																											
0	0	0	0	#_BLL_E																											
0	0	0	0	#_ROV_E																											
0	0	0	0	#_MRIP_Index_E																											
0	0	0	0	#_MRIP_Index_W																											
0	0	0	0	#_HBT_Index_E																											
0	0	0	0	#_HBT_Index_W																											
#																															
#_Cond	0	#_If	q	has	random	component,	then	0=read	one	parm	for	each	fleet	with	random	q;	1=read	a	parm	for	each	year	of	index							
#_Q_parms(if_any)																															
#	LO	HI	INIT	PRIOR	PR_type	SD	PHASE																								
	-10	20	1	1	-1	1	1	#_Shr_E																							
	-10	20	1	1	-1	1	1	#_Shr_W																							
#																															
#_size_selex_types																															
#discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead																															
#_Pattern	Discard	Male	Special																												
0	2	0	0	#_HLE																											
0	2	0	0	#_HL_W																											
0	2	0	0	#_LL_E																											
0	2	0	0	#_LL_W																											
0	2	0	0	#_MRIP_E																											
0	2	0	0	#_MRIP_W																											
0	2	0	0	#_HBT_E																											
0	2	0	0	#_HBT_W																											
0	2	0	0	#_C_Clsd_E																											
0	2	0	0	#_C_Clsd_W																											
0	2	0	0	#_R_Clsd_E																											
0	2	0	0	#_R_Clsd_W																											
0	3	0	0	#_Shr_E																											
0	3	0	0	#_Shr_W																											
0	0	0	0	#_Video_E																											
0	0	0	0	#_Video_W																											
30	0	0	0	#_Larv_E																											
30	0	0	0	#_Larv_W																											
0	0	0	0	#_Sum_E																											
0	0	0	0	#_Sum_W																											
0	0	0	0	#_Fall_E																											
0	0	0	0	#_Fall_W																											
0	0	0	0	#_BLL_W																											
0	0	0	0	#_BLL_E																											
0	0	0	0	#_ROV_E																											
0	0	0	0	#_MRIP_Index_E																											
0	0	0	0	#_MRIP_Index_W																											
0	0	0	0	#_HBT_Index_E																											
0	0	0	0	#_HBT_Index_W																											
#																															
#_age_selex_types																															
#_Pattern	___	Male	Special																												
20	0	0	0	#_HLE																											
20	0	0	0	#_HL_W																											
20	0	0	0	#_LL_E																											
20	0	0	0	#_LL_W																											
20	0	0	0	#_MRIP_E																											
20	0	0	0	#_MRIP_W																											
20	0	0	0	#_HBT_E																											
20	0	0	0	#_HBT_W																											
20	0	0	0	#_C_Clsd_E																											
20	0	0	0	#_C_Clsd_W																											
15	0	0	5	#_R_Clsd_E																											
15	0	0	6	#_R_Clsd_W																											
17	0	0	0	#_Shr_E																											
17	0	0	0	#_Shr_W																											
20	0	0	0	#_Video_E																											
20	0	0	0	#_Video_W																											
10	0	0	0	#_Larv_E																											
10	0	0	0	#_Larv_W																											
17	0	0	0	#_Sum_E																											
17	0	0	0	#_Sum_W																											
17	0	0	0	#_Fall_E																											
17	0	0	0	#_Fall_W																											
12	0	0	0	#_BLL_W																											
12	0	0	0	#_BLL_E																											
20	0	0	0	#_ROV_E																											
15	0	0	5	#_MRIP_Index_E																											
15	0	0	6	#_MRIP_Index_W																											
15	0	0	7	#_HBT_Index_E																											
15	0	0	8	#_HBT_Index_W																											
#_LO	HI	INIT	PRIOR	PR_type	SD	PHASE	env-var	use_dev	dev_minyr	dev_maxyr	dev_std	block	block_fxn	
 10 100 15.24 15.24 -1 1 -3 0 0 0 0 0 1 2 # Retain_1P_1_HL_E
 -1 20 1 1 -1 1 -3 0 0 0 0 0 1 2 # Retain_1P_2_HL_E
 0 1 1 1 -1 1 -2 0 0 0 0 0 1 2 # Retain_1P_3_HL_E
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # Retain_1P_4_HL_E
 -10 10 -5 -5 -1 1 -2 0 0 0 0 0 0 0 # DiscMort_1P_1_HL_E
 -1 2 1 1 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_1P_2_HL_E
 -1 2 0.75 0.75 -1 1 -2 0 0 0 0 0 4 2 # DiscMort_1P_3_HL_E
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_1P_4_HL_E
 10 100 15.24 15.24 -1 1 -3 0 0 0 0 0 1 2 # Retain_2P_1_HL_W
 -1 20 1 1 -1 1 -3 0 0 0 0 0 1 2 # Retain_2P_2_HL_W
 0 1 1 1 -1 1 -2 0 0 0 0 0 1 2 # Retain_2P_3_HL_W
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # Retain_2P_4_HL_W
 -10 10 -5 -5 -1 1 -2 0 0 0 0 0 0 0 # DiscMort_2P_1_HL_W
 -1 2 1 1 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_2P_2_HL_W
 -1 2 0.78 0.78 -1 1 -2 0 0 0 0 0 4 2 # DiscMort_2P_3_HL_W
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_2P_4_HL_W
 10 100 15.24 15.24 -1 1 -3 0 0 0 0 0 1 2 # Retain_3P_1_LL_E
 -1 20 1 1 -1 1 -3 0 0 0 0 0 1 2 # Retain_3P_2_LL_E
 0 1 1 1 -1 1 -2 0 0 0 0 0 1 2 # Retain_3P_3_LL_E
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # Retain_3P_4_LL_E
 -10 10 -5 -5 -1 1 -2 0 0 0 0 0 0 0 # DiscMort_3P_1_LL_E
 -1 2 1 1 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_3P_2_LL_E
 -1 2 0.81 0.81 -1 1 -2 0 0 0 0 0 4 2 # DiscMort_3P_3_LL_E
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_3P_4_LL_E
 10 100 15.24 15.24 -1 1 -3 0 0 0 0 0 1 2 # Retain_4P_1_LL_W
 -1 20 1 1 -1 1 -3 0 0 0 0 0 1 2 # Retain_4P_2_LL_W
 0 1 1 1 -1 1 -2 0 0 0 0 0 1 2 # Retain_4P_3_LL_W
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # Retain_4P_4_LL_W
 -10 10 -5 -5 -1 1 -2 0 0 0 0 0 0 0 # DiscMort_4P_1_LL_W
 -1 2 1 1 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_4P_2_LL_W
 -1 2 0.91 0.91 -1 1 -2 0 0 0 0 0 4 2 # DiscMort_4P_3_LL_W
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_4P_4_LL_W
 10 100 15.24 15.24 -1 1 -3 0 0 0 0 0 2 2 # Retain_5P_1_MRIP_E
 -1 20 1 1 -1 1 -3 0 0 0 0 0 2 2 # Retain_5P_2_MRIP_E
 0 1 1 1 -1 1 -2 0 0 0 0 0 0 0 # Retain_5P_3_MRIP_E
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # Retain_5P_4_MRIP_E
 -10 10 -5 -5 -1 1 -2 0 0 0 0 0 0 0 # DiscMort_5P_1_MRIP_E
 -1 2 1 1 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_5P_2_MRIP_E
 -1 2 0.21 0.21 -1 1 -2 0 0 0 0 0 4 2 # DiscMort_5P_3_MRIP_E
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_5P_4_MRIP_E
 10 100 15.24 15.24 -1 1 -3 0 0 0 0 0 2 2 # Retain_6P_1_MRIP_W
 -1 20 1 1 -1 1 -3 0 0 0 0 0 2 2 # Retain_6P_2_MRIP_W
 0 1 1 1 -1 1 -2 0 0 0 0 0 0 0 # Retain_6P_3_MRIP_W
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # Retain_6P_4_MRIP_W
 -10 10 -5 -5 -1 1 -2 0 0 0 0 0 0 0 # DiscMort_6P_1_MRIP_W
 -1 2 1 1 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_6P_2_MRIP_W
 -1 2 0.22 0.22 -1 1 -2 0 0 0 0 0 4 2 # DiscMort_6P_3_MRIP_W
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_6P_4_MRIP_W
 10 100 15.24 15.24 -1 1 -3 0 0 0 0 0 2 2 # Retain_7P_1_HBT_E
 -1 20 1 1 -1 1 -3 0 0 0 0 0 2 2 # Retain_7P_2_HBT_E
 0 1 1 1 -1 1 -2 0 0 0 0 0 2 2 # Retain_7P_3_HBT_E
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # Retain_7P_4_HBT_E
 -10 10 -5 -5 -1 1 -2 0 0 0 0 0 0 0 # DiscMort_7P_1_HBT_E
 -1 2 1 1 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_7P_2_HBT_E
 -1 2 0.21 0.21 -1 1 -2 0 0 0 0 0 4 2 # DiscMort_7P_3_HBT_E
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_7P_4_HBT_E
 10 100 15.24 15.24 -1 1 -3 0 0 0 0 0 2 2 # Retain_8P_1_HBT_W
 -1 20 1 1 -1 1 -3 0 0 0 0 0 2 2 # Retain_8P_2_HBT_W
 0 1 1 1 -1 1 -2 0 0 0 0 0 0 0 # Retain_8P_3_HBT_W
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # Retain_8P_4_HBT_W
 -10 10 -5 -5 -1 1 -2 0 0 0 0 0 0 0 # DiscMort_8P_1_HBT_W
 -1 2 1 1 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_8P_2_HBT_W
 -1 2 0.22 0.22 -1 1 -2 0 0 0 0 0 4 2 # DiscMort_8P_3_HBT_W
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_8P_4_HBT_W
 10 100 10 10 -1 1 -3 0 0 0 0 0 0 0 # Retain_9P_1_C_Clsd_E
 -1 20 1 1 -1 1 -3 0 0 0 0 0 0 0 # Retain_9P_2_C_Clsd_E
 0 1 0 0 -1 1 -2 0 0 0 0 0 0 0 # Retain_9P_3_C_Clsd_E
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # Retain_9P_4_C_Clsd_E
 -10 10 -5 -5 -1 1 -2 0 0 0 0 0 0 0 # DiscMort_9P_1_C_Clsd_E
 -1 2 1 1 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_9P_2_C_Clsd_E
 -1 2 0.74 0.74 -1 1 -2 0 0 0 0 0 4 2 # DiscMort_9P_3_C_Clsd_E
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_9P_4_C_Clsd_E
 10 100 10 10 -1 1 -3 0 0 0 0 0 0 0 # Retain_10P_1_C_Clsd_W
 -1 20 1 1 -1 1 -3 0 0 0 0 0 0 0 # Retain_10P_2_C_Clsd_W
 0 1 0 0 -1 1 -2 0 0 0 0 0 0 0 # Retain_10P_3_C_Clsd_W
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # Retain_10P_4_C_Clsd_W
 -10 10 -5 -5 -1 1 -2 0 0 0 0 0 0 0 # DiscMort_10P_1_C_Clsd_W
 -1 2 1 1 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_10P_2_C_Clsd_W
 -1 2 0.87 0.87 -1 1 -2 0 0 0 0 0 4 2 # DiscMort_10P_3_C_Clsd_W
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_10P_4_C_Clsd_W
 10 100 10 10 -1 1 -3 0 0 0 0 0 0 0 # Retain_11P_1_R_Clsd_E
 -1 20 1 1 -1 1 -3 0 0 0 0 0 0 0 # Retain_11P_2_R_Clsd_E
 0 1 0 0 -1 1 -2 0 0 0 0 0 0 0 # Retain_11P_3_R_Clsd_E
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # Retain_11P_4_R_Clsd_E
 -10 10 -5 -5 -1 1 -2 0 0 0 0 0 0 0 # DiscMort_11P_1_R_Clsd_E
 -1 2 1 1 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_11P_2_R_Clsd_E
 -1 2 0.21 0.21 -1 1 -2 0 0 0 0 0 4 2 # DiscMort_11P_3_R_Clsd_E
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_11P_4_R_Clsd_E
 10 100 10 10 -1 1 -3 0 0 0 0 0 0 0 # Retain_12P_1_R_Clsd_W
 -1 20 1 1 -1 1 -3 0 0 0 0 0 0 0 # Retain_12P_2_R_Clsd_W
 0 1 0 0 -1 1 -2 0 0 0 0 0 0 0 # Retain_12P_3_R_Clsd_W
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # Retain_12P_4_R_Clsd_W
 -10 10 -5 -5 -1 1 -2 0 0 0 0 0 0 0 # DiscMort_12P_1_R_Clsd_W
 -1 2 1 1 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_12P_2_R_Clsd_W
 -1 2 0.22 0.22 -1 1 -2 0 0 0 0 0 4 2 # DiscMort_12P_3_R_Clsd_W
 -1 2 0 0 -1 1 -4 0 0 0 0 0 0 0 # DiscMort_12P_4_R_Clsd_W
 0 19.8 2.76027 5.4 1 0.05 2 0 0 0 0 0.5 3 2 # AgeSel_1P_1_HL_E
 -5 3 -2.01383 -2.3 1 0.05 3 0 0 0 0 0.5 3 2 # AgeSel_1P_2_HL_E
 -4 12 -0.336177 1.6 1 0.05 3 0 0 0 0 0.5 3 2 # AgeSel_1P_3_HL_E
 -2 6 2.70056 1.7 1 0.05 3 0 0 0 0 0.5 3 2 # AgeSel_1P_4_HL_E
 -15 5 -11.8786 -8.3 1 0.05 2 0 0 0 0 0.5 3 2 # AgeSel_1P_5_HL_E
 -5 5 -3.1569 -1.8 1 0.05 2 0 0 0 0 0.5 3 2 # AgeSel_1P_6_HL_E
 0 19.8 3.23407 5.4 1 0.05 2 0 0 0 0 0.5 3 2 # AgeSel_2P_1_HL_W
 -8 3 -4.95775 -2.3 1 0.05 3 0 0 0 0 0.5 3 2 # AgeSel_2P_2_HL_W
 -4 12 0.232107 1.6 1 0.05 3 0 0 0 0 0.5 3 2 # AgeSel_2P_3_HL_W
 -2 6 2.32277 1.7 1 0.05 3 0 0 0 0 0.5 3 2 # AgeSel_2P_4_HL_W
 -15 5 -4.94275 -8.3 1 0.05 2 0 0 0 0 0.5 3 2 # AgeSel_2P_5_HL_W
 -5 5 -3.45417 -1.8 1 0.05 2 0 0 0 0 0.5 3 2 # AgeSel_2P_6_HL_W
 0 19.8 5.83175 7.5 1 0.05 2 0 0 0 0 0.5 3 2 # AgeSel_3P_1_LL_E
 -5 3 0.511092 3 1 0.05 3 0 0 0 0 0.5 3 2 # AgeSel_3P_2_LL_E
 -4 12 1.25141 2.2 1 0.05 3 0 0 0 0 0.5 3 2 # AgeSel_3P_3_LL_E
 -2 6 0.0202586 2.1 1 0.05 3 0 0 0 0 0.5 3 2 # AgeSel_3P_4_LL_E
 -15 5 -4.42574 -14.1 1 0.05 2 0 0 0 0 0.5 3 2 # AgeSel_3P_5_LL_E
 -5 8 4.47157 5 1 0.05 2 0 0 0 0 0.5 3 2 # AgeSel_3P_6_LL_E
 0 19.8 8.18689 7.5 1 0.05 2 0 0 0 0 0.5 3 2 # AgeSel_4P_1_LL_W
 -5 3 -3.81036 3 1 0.05 3 0 0 0 0 0.5 3 2 # AgeSel_4P_2_LL_W
 -4 12 2.46406 2.2 1 0.05 3 0 0 0 0 0.5 3 2 # AgeSel_4P_3_LL_W
 -2 6 4.22005 2.1 1 0.05 3 0 0 0 0 0.5 3 2 # AgeSel_4P_4_LL_W
 -15 5 -7.20927 -14.1 1 0.05 2 0 0 0 0 0.5 3 2 # AgeSel_4P_5_LL_W
 -5 5 0.835389 5 1 0.05 2 0 0 0 0 0.5 3 2 # AgeSel_4P_6_LL_W
 0 19.8 1.51966 5.4 1 0.05 2 0 0 0 0 0.5 5 2 # AgeSel_5P_1_MRIP_E
 -6 3 -4.71687 -2.3 1 0.05 3 0 0 0 0 0.5 5 2 # AgeSel_5P_2_MRIP_E
 -4 12 -2.48095 1.6 1 0.05 3 0 0 0 0 0.5 5 2 # AgeSel_5P_3_MRIP_E
 -2 6 2.6846 1.7 1 0.05 3 0 0 0 0 0.5 5 2 # AgeSel_5P_4_MRIP_E
 -15 5 -7.17778 -8.3 1 0.05 2 0 0 0 0 0.5 5 2 # AgeSel_5P_5_MRIP_E
 -8 5 -4.97544 -1.8 1 0.05 2 0 0 0 0 0.5 5 2 # AgeSel_5P_6_MRIP_E
 0 19.8 1.30659 5.4 1 0.05 2 0 0 0 0 0.5 5 2 # AgeSel_6P_1_MRIP_W
 -8 3 -4.98823 -2.3 1 0.05 3 0 0 0 0 0.5 5 2 # AgeSel_6P_2_MRIP_W
 -8 12 -3.98592 1.6 1 0.05 3 0 0 0 0 0.5 5 2 # AgeSel_6P_3_MRIP_W
 -2 6 1.48241 1.7 1 0.05 3 0 0 0 0 0.5 5 2 # AgeSel_6P_4_MRIP_W
 -16 5 -13.4869 -8.3 1 0.05 2 0 0 0 0 0.5 5 2 # AgeSel_6P_5_MRIP_W
 -5 5 -3.00108 -1.8 1 0.05 2 0 0 0 0 0.5 5 2 # AgeSel_6P_6_MRIP_W
 0 19.8 2.70596 5.4 1 0.05 2 0 0 0 0 0.5 5 2 # AgeSel_7P_1_HBT_E
 -5 3 -0.713446 -2.3 1 0.05 3 0 0 0 0 0.5 5 2 # AgeSel_7P_2_HBT_E
 -4 12 -0.320467 1.6 1 0.05 3 0 0 0 0 0.5 5 2 # AgeSel_7P_3_HBT_E
 -2 6 -0.21241 1.7 1 0.05 3 0 0 0 0 0.5 5 2 # AgeSel_7P_4_HBT_E
 -15 5 -12.6354 -8.3 1 0.05 2 0 0 0 0 0.5 5 2 # AgeSel_7P_5_HBT_E
 -8 5 -4.88947 -1.8 1 0.05 2 0 0 0 0 0.5 5 2 # AgeSel_7P_6_HBT_E
 0 19.8 1.3869 5.4 1 0.05 2 0 0 0 0 0.5 5 2 # AgeSel_8P_1_HBT_W
 -8 3 -4.94962 -2.3 1 0.05 3 0 0 0 0 0.5 5 2 # AgeSel_8P_2_HBT_W
 -6 12 -3.9063 1.6 1 0.05 3 0 0 0 0 0.5 5 2 # AgeSel_8P_3_HBT_W
 -2 6 2.29813 1.7 1 0.05 3 0 0 0 0 0.5 5 2 # AgeSel_8P_4_HBT_W
 -15 5 -12.4808 -8.3 1 0.05 2 0 0 0 0 0.5 5 2 # AgeSel_8P_5_HBT_W
 -5 5 -3.66149 -1.8 1 0.05 2 0 0 0 0 0.5 5 2 # AgeSel_8P_6_HBT_W
 0 19.8 3.31523 5.4 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_9P_1_C_Clsd_E
 -5 3 -2.83709 -2.3 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_9P_2_C_Clsd_E
 -4 12 0.218445 1.6 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_9P_3_C_Clsd_E
 -2 6 3.02543 1.7 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_9P_4_C_Clsd_E
 -15 5 -11.2423 -8.3 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_9P_5_C_Clsd_E
 -5 5 -3.64179 -1.8 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_9P_6_C_Clsd_E
 0 19.8 3.67602 5.4 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_10P_1_C_Clsd_W
 -6 3 -4.85037 -2.3 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_10P_2_C_Clsd_W
 -4 12 0.242077 1.6 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_10P_3_C_Clsd_W
 -2 6 1.1784 1.7 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_10P_4_C_Clsd_W
 -15 5 -11.6075 -8.3 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_10P_5_C_Clsd_W
 -5 5 -2.39319 -1.8 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_10P_6_C_Clsd_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_1_Shr_E
 -20 20 -3.14268 -0.1 0 1 2 0 0 0 0 0 0 0 # AgeSel_13P_2_Shr_E
 -20 20 -1.07972 -0.1 0 1 2 0 0 0 0 0 0 0 # AgeSel_13P_3_Shr_E
 -50 0 -20 -20 0 1 2 0 0 0 0 0 0 0 # AgeSel_13P_4_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_5_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_6_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_7_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_8_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_9_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_10_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_11_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_12_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_13_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_14_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_15_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_16_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_17_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_18_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_19_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_20_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_13P_21_Shr_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_1_Shr_W
 -20 20 -2.73058 -0.1 0 1 2 0 0 0 0 0 0 0 # AgeSel_14P_2_Shr_W
 -20 20 -1.29559 -0.1 0 1 2 0 0 0 0 0 0 0 # AgeSel_14P_3_Shr_W
 -50 0 -20 -20 0 1 2 0 0 0 0 0 0 0 # AgeSel_14P_4_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_5_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_6_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_7_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_8_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_9_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_10_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_11_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_12_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_13_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_14_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_15_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_16_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_17_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_18_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_19_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_20_Shr_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_14P_21_Shr_W
 0 19.8 3.49016 5.4 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_15P_1_Video_E
 -5 3 -1.14063 -2.3 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_15P_2_Video_E
 -4 12 0.356396 1.6 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_15P_3_Video_E
 -2 6 0.964759 1.7 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_15P_4_Video_E
 -15 5 -3.6871 -8.3 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_15P_5_Video_E
 -5 5 -0.667166 -1.8 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_15P_6_Video_E
 0 19.8 2.84346 5.4 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_16P_1_Video_W
 -5 3 -3.82022 -2.3 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_16P_2_Video_W
 -4 12 -0.447196 1.6 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_16P_3_Video_W
 -2 6 2.19099 1.7 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_16P_4_Video_W
 -15 5 -10.3848 -8.3 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_16P_5_Video_W
 -5 5 -1.55472 -1.8 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_16P_6_Video_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_1_Sum_E
 -20 20 1.16508 -0.1 0 1 2 0 0 0 0 0 0 0 # AgeSel_19P_2_Sum_E
 -20 20 0.0735348 -0.1 0 1 2 0 0 0 0 0 0 0 # AgeSel_19P_3_Sum_E
 -50 0 -10.0298 -10 0 1 2 0 0 0 0 0 0 0 # AgeSel_19P_4_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_5_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_6_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_7_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_8_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_9_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_10_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_11_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_12_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_13_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_14_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_15_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_16_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_17_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_18_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_19_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_20_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_19P_21_Sum_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_1_Sum_W
 -20 20 1.15544 -0.1 0 1 2 0 0 0 0 0 0 0 # AgeSel_20P_2_Sum_W
 -20 20 -0.935845 -0.1 0 1 2 0 0 0 0 0 0 0 # AgeSel_20P_3_Sum_W
 -50 0 -10.0252 -10 0 1 2 0 0 0 0 0 0 0 # AgeSel_20P_4_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_5_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_6_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_7_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_8_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_9_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_10_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_11_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_12_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_13_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_14_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_15_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_16_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_17_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_18_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_19_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_20_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_20P_21_Sum_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_1_Fall_E
 -20 20 -3.72655 -0.1 0 1 2 0 0 0 0 0 0 0 # AgeSel_21P_2_Fall_E
 -20 20 0.684902 -0.1 0 1 2 0 0 0 0 0 0 0 # AgeSel_21P_3_Fall_E
 -50 0 -20 -20 0 1 2 0 0 0 0 0 0 0 # AgeSel_21P_4_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_5_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_6_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_7_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_8_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_9_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_10_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_11_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_12_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_13_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_14_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_15_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_16_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_17_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_18_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_19_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_20_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_21P_21_Fall_E
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_1_Fall_W
 -20 20 -3.47213 -0.1 0 1 2 0 0 0 0 0 0 0 # AgeSel_22P_2_Fall_W
 -20 20 -0.769867 -0.1 0 1 2 0 0 0 0 0 0 0 # AgeSel_22P_3_Fall_W
 -50 0 -20 -20 0 1 2 0 0 0 0 0 0 0 # AgeSel_22P_4_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_5_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_6_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_7_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_8_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_9_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_10_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_11_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_12_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_13_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_14_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_15_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_16_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_17_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_18_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_19_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_20_Fall_W
 -20 20 0 0 0 1 -1 0 0 0 0 0 0 0 # AgeSel_22P_21_Fall_W
 4 18 6.58345 12 -1 1 2 0 0 0 0 0 0 0 # AgeSel_23P_1_BLL_W
 -5 5 2.15511 2 0 1 2 0 0 0 0 0 0 0 # AgeSel_23P_2_BLL_W
 4 18 6.58345 12 -1 1 2 0 0 0 0 0 0 0 # AgeSel_24P_1_BLL_E
 -5 5 2.15511 2 0 1 2 0 0 0 0 0 0 0 # AgeSel_24P_2_BLL_E
 0 19.8 2.29632 5.4 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_25P_1_ROV_E
 -5 3 -2.33268 -2.3 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_25P_2_ROV_E
 -4 12 -1.9357 1.6 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_25P_3_ROV_E
 -2 6 -1.20939 1.7 1 0.05 3 0 0 0 0 0.5 0 0 # AgeSel_25P_4_ROV_E
 -15 5 -11.2341 -8.3 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_25P_5_ROV_E
 -5 5 0.216479 -1.8 1 0.05 2 0 0 0 0 0.5 0 0 # AgeSel_25P_6_ROV_E
#_Cond 0 #_custom_sel-env_setup (0/1) 
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no enviro fxns
1 #_custom_sel-blk_setup (0/1) 
 10 100 33.02 33.02 -1 1 -4 # Retain_1P_1_HL_E_BLK1repl_1985
 10 100 35.56 35.56 -1 1 -4 # Retain_1P_1_HL_E_BLK1repl_1994
 10 100 38.1 38.1 -1 1 -4 # Retain_1P_1_HL_E_BLK1repl_1995
 10 100 33.02 33.02 -1 1 -6 # Retain_1P_1_HL_E_BLK1repl_2007
 -1 20 1 1 -1 1 -4 # Retain_1P_2_HL_E_BLK1repl_1985
 -1 20 1 1 -1 1 -4 # Retain_1P_2_HL_E_BLK1repl_1994
 -1 20 1 1 -1 1 -4 # Retain_1P_2_HL_E_BLK1repl_1995
 -1 20 1 1 -1 1 -4 # Retain_1P_2_HL_E_BLK1repl_2007
 0 1 1 1 -1 1 -4 # Retain_1P_3_HL_E_BLK1repl_1985
 0 1 1 1 -1 1 -4 # Retain_1P_3_HL_E_BLK1repl_1994
 0 1 1 1 -1 1 -4 # Retain_1P_3_HL_E_BLK1repl_1995
 0 1 0.81148 0.5 -1 1 6 # Retain_1P_3_HL_E_BLK1repl_2007
 -1 2 0.56 0.56 -1 1 -4 # DiscMort_1P_3_HL_E_BLK4repl_2008
 10 100 33.02 33.02 -1 1 -4 # Retain_2P_1_HL_W_BLK1repl_1985
 10 100 35.56 35.56 -1 1 -4 # Retain_2P_1_HL_W_BLK1repl_1994
 10 100 38.1 38.1 -1 1 -4 # Retain_2P_1_HL_W_BLK1repl_1995
 10 100 33.02 33.02 -1 1 -6 # Retain_2P_1_HL_W_BLK1repl_2007
 -1 20 1 1 -1 1 -4 # Retain_2P_2_HL_W_BLK1repl_1985
 -1 20 1 1 -1 1 -4 # Retain_2P_2_HL_W_BLK1repl_1994
 -1 20 1 1 -1 1 -4 # Retain_2P_2_HL_W_BLK1repl_1995
 -1 20 1 1 -1 1 -4 # Retain_2P_2_HL_W_BLK1repl_2007
 0 1 1 1 -1 1 -4 # Retain_2P_3_HL_W_BLK1repl_1985
 0 1 1 1 -1 1 -4 # Retain_2P_3_HL_W_BLK1repl_1994
 0 1 1 1 -1 1 -4 # Retain_2P_3_HL_W_BLK1repl_1995
 0 1 0.961804 0.5 -1 1 6 # Retain_2P_3_HL_W_BLK1repl_2007
 -1 2 0.6 0.6 -1 1 -4 # DiscMort_2P_3_HL_W_BLK4repl_2008
 6 100 33.02 33.02 -1 1 -4 # Retain_3P_1_LL_E_BLK1repl_1985
 6 100 35.56 35.56 -1 1 -4 # Retain_3P_1_LL_E_BLK1repl_1994
 6 100 38.1 38.1 -1 1 -4 # Retain_3P_1_LL_E_BLK1repl_1995
 6 100 33.02 33.02 -1 1 -6 # Retain_3P_1_LL_E_BLK1repl_2007
 -1 20 1 1 -1 1 -4 # Retain_3P_2_LL_E_BLK1repl_1985
 -1 20 1 1 -1 1 -4 # Retain_3P_2_LL_E_BLK1repl_1994
 -1 20 1 1 -1 1 -4 # Retain_3P_2_LL_E_BLK1repl_1995
 -1 20 1 1 -1 1 -4 # Retain_3P_2_LL_E_BLK1repl_2007
 0 1 1 1 -1 1 -4 # Retain_3P_3_LL_E_BLK1repl_1985
 0 1 1 1 -1 1 -4 # Retain_3P_3_LL_E_BLK1repl_1994
 0 1 1 1 -1 1 -4 # Retain_3P_3_LL_E_BLK1repl_1995
 0 1 0.53786 0.5 -1 1 6 # Retain_3P_3_LL_E_BLK1repl_2007
 -1 2 0.64 0.64 -1 1 -4 # DiscMort_3P_3_LL_E_BLK4repl_2008
 10 100 33.02 33.02 -1 1 -4 # Retain_4P_1_LL_W_BLK1repl_1985
 10 100 35.56 35.56 -1 1 -4 # Retain_4P_1_LL_W_BLK1repl_1994
 10 100 38.1 38.1 -1 1 -4 # Retain_4P_1_LL_W_BLK1repl_1995
 10 100 33.02 33.02 -1 1 -6 # Retain_4P_1_LL_W_BLK1repl_2007
 -1 20 1 1 -1 1 -4 # Retain_4P_2_LL_W_BLK1repl_1985
 -1 20 1 1 -1 1 -4 # Retain_4P_2_LL_W_BLK1repl_1994
 -1 20 1 1 -1 1 -4 # Retain_4P_2_LL_W_BLK1repl_1995
 -1 20 1 1 -1 1 -4 # Retain_4P_2_LL_W_BLK1repl_2007
 0 1 1 1 -1 1 -4 # Retain_4P_3_LL_W_BLK1repl_1985
 0 1 1 1 -1 1 -4 # Retain_4P_3_LL_W_BLK1repl_1994
 0 1 1 1 -1 1 -4 # Retain_4P_3_LL_W_BLK1repl_1995
 0 1 0.946892 0.5 -1 1 6 # Retain_4P_3_LL_W_BLK1repl_2007
 -1 2 0.81 0.81 -1 1 -4 # DiscMort_4P_3_LL_W_BLK4repl_2008
 10 100 33.02 33.02 -1 1 -4 # Retain_5P_1_MRIP_E_BLK2repl_1985
 10 100 35.56 35.56 -1 1 -4 # Retain_5P_1_MRIP_E_BLK2repl_1994
 10 100 38.1 38.1 -1 1 -4 # Retain_5P_1_MRIP_E_BLK2repl_1995
 10 100 40.64 40.64 -1 1 -4 # Retain_5P_1_MRIP_E_BLK2repl_2000
 -1 20 1 1 -1 1 -4 # Retain_5P_2_MRIP_E_BLK2repl_1985
 -1 20 1 1 -1 1 -4 # Retain_5P_2_MRIP_E_BLK2repl_1994
 -1 20 1 1 -1 1 -4 # Retain_5P_2_MRIP_E_BLK2repl_1995
 -1 20 1 1 -1 1 -4 # Retain_5P_2_MRIP_E_BLK2repl_2000
 -1 2 0.118 0.118 -1 1 -4 # DiscMort_5P_3_MRIP_E_BLK4repl_2008
 10 100 33.02 33.02 -1 1 -4 # Retain_6P_1_MRIP_W_BLK2repl_1985
 10 100 35.56 35.56 -1 1 -4 # Retain_6P_1_MRIP_W_BLK2repl_1994
 10 100 38.1 38.1 -1 1 -4 # Retain_6P_1_MRIP_W_BLK2repl_1995
 10 100 40.64 40.64 -1 1 -4 # Retain_6P_1_MRIP_W_BLK2repl_2000
 -1 20 1 1 -1 1 -4 # Retain_6P_2_MRIP_W_BLK2repl_1985
 -1 20 1 1 -1 1 -4 # Retain_6P_2_MRIP_W_BLK2repl_1994
 -1 20 1 1 -1 1 -4 # Retain_6P_2_MRIP_W_BLK2repl_1995
 -1 20 1 1 -1 1 -4 # Retain_6P_2_MRIP_W_BLK2repl_2000
 -1 2 0.118 0.118 -1 1 -4 # DiscMort_6P_3_MRIP_W_BLK4repl_2008
 10 100 33.02 33.02 -1 1 -4 # Retain_7P_1_HBT_E_BLK2repl_1985
 10 100 35.56 35.56 -1 1 -4 # Retain_7P_1_HBT_E_BLK2repl_1994
 10 100 38.1 38.1 -1 1 -4 # Retain_7P_1_HBT_E_BLK2repl_1995
 10 100 40.64 40.64 -1 1 -6 # Retain_7P_1_HBT_E_BLK2repl_2000
 -1 20 1 1 -1 1 -4 # Retain_7P_2_HBT_E_BLK2repl_1985
 -1 20 1 1 -1 1 -4 # Retain_7P_2_HBT_E_BLK2repl_1994
 -1 20 1 1 -1 1 -4 # Retain_7P_2_HBT_E_BLK2repl_1995
 -1 20 1 1 -1 1 -4 # Retain_7P_2_HBT_E_BLK2repl_2000
 0 1 1 1 -1 1 -4 # Retain_7P_3_HBT_E_BLK2repl_1985
 0 1 1 1 -1 1 -4 # Retain_7P_3_HBT_E_BLK2repl_1994
 0 1 1 1 -1 1 -4 # Retain_7P_3_HBT_E_BLK2repl_1995
 0 1 1 1 -1 1 -6 # Retain_7P_3_HBT_E_BLK2repl_2000
 -1 2 0.118 0.118 -1 1 -4 # DiscMort_7P_3_HBT_E_BLK4repl_2008
 10 100 33.02 33.02 -1 1 -4 # Retain_8P_1_HBT_W_BLK2repl_1985
 10 100 35.56 35.56 -1 1 -4 # Retain_8P_1_HBT_W_BLK2repl_1994
 10 100 38.1 38.1 -1 1 -4 # Retain_8P_1_HBT_W_BLK2repl_1995
 10 100 40.64 40.64 -1 1 -4 # Retain_8P_1_HBT_W_BLK2repl_2000
 -1 20 1 1 -1 1 -4 # Retain_8P_2_HBT_W_BLK2repl_1985
 -1 20 1 1 -1 1 -4 # Retain_8P_2_HBT_W_BLK2repl_1994
 -1 20 1 1 -1 1 -4 # Retain_8P_2_HBT_W_BLK2repl_1995
 -1 20 1 1 -1 1 -4 # Retain_8P_2_HBT_W_BLK2repl_2000
 -1 2 0.118 0.118 -1 1 -4 # DiscMort_8P_3_HBT_W_BLK4repl_2008
 -1 2 0.55 0.55 -1 1 -4 # DiscMort_9P_3_C_Clsd_E_BLK4repl_2008
 -1 2 0.74 0.74 -1 1 -4 # DiscMort_10P_3_C_Clsd_W_BLK4repl_2008
 -1 2 0.118 0.118 -1 1 -4 # DiscMort_11P_3_R_Clsd_E_BLK4repl_2008
 -1 2 0.118 0.118 -1 1 -4 # DiscMort_12P_3_R_Clsd_W_BLK4repl_2008
 0 19.8 3.27537 5.4 1 0.05 2 # AgeSel_1P_1_HL_E_BLK3repl_2007
 -5 3 -4.91435 -2.3 1 0.05 3 # AgeSel_1P_2_HL_E_BLK3repl_2007
 -4 12 0.284437 1.6 1 0.05 3 # AgeSel_1P_3_HL_E_BLK3repl_2007
 -2 6 2.88143 1.7 1 0.05 3 # AgeSel_1P_4_HL_E_BLK3repl_2007
 -15 5 -12.4119 -8.3 1 0.05 2 # AgeSel_1P_5_HL_E_BLK3repl_2007
 -5 5 -2.83744 -1.8 1 0.05 2 # AgeSel_1P_6_HL_E_BLK3repl_2007
 0 19.8 3.56392 5.4 1 0.05 2 # AgeSel_2P_1_HL_W_BLK3repl_2007
 -5 3 -4.77442 -2.3 1 0.05 3 # AgeSel_2P_2_HL_W_BLK3repl_2007
 -4 12 0.0108765 1.6 1 0.05 3 # AgeSel_2P_3_HL_W_BLK3repl_2007
 -2 6 2.21512 1.7 1 0.05 3 # AgeSel_2P_4_HL_W_BLK3repl_2007
 -15 5 -13.6732 -8.3 1 0.05 2 # AgeSel_2P_5_HL_W_BLK3repl_2007
 -5 5 -2.21992 -1.8 1 0.05 2 # AgeSel_2P_6_HL_W_BLK3repl_2007
 0 19.8 5.27164 7.5 1 0.05 2 # AgeSel_3P_1_LL_E_BLK3repl_2007
 -5 3 -4.17678 3 1 0.05 3 # AgeSel_3P_2_LL_E_BLK3repl_2007
 -4 12 1.10671 2.2 1 0.05 3 # AgeSel_3P_3_LL_E_BLK3repl_2007
 -2 6 2.31498 2.1 1 0.05 3 # AgeSel_3P_4_LL_E_BLK3repl_2007
 -15 5 -12.375 -14.1 1 0.05 2 # AgeSel_3P_5_LL_E_BLK3repl_2007
 -5 5 -1.52989 5 1 0.05 2 # AgeSel_3P_6_LL_E_BLK3repl_2007
 0 19.8 8.6368 7.5 1 0.05 2 # AgeSel_4P_1_LL_W_BLK3repl_2007
 -5 3 -4.33596 3 1 0.05 3 # AgeSel_4P_2_LL_W_BLK3repl_2007
 -4 12 2.244 2.2 1 0.05 3 # AgeSel_4P_3_LL_W_BLK3repl_2007
 -2 6 3.76335 2.1 1 0.05 3 # AgeSel_4P_4_LL_W_BLK3repl_2007
 -15 5 -13.1074 -14.1 1 0.05 2 # AgeSel_4P_5_LL_W_BLK3repl_2007
 -5 5 -0.338798 5 1 0.05 2 # AgeSel_4P_6_LL_W_BLK3repl_2007
 0 19.8 3.54153 5.4 1 0.05 2 # AgeSel_5P_1_MRIP_E_BLK5repl_2008
 0 19.8 2.23249 5.4 1 0.05 2 # AgeSel_5P_1_MRIP_E_BLK5repl_2011
 -5 3 -4.79047 -2.3 1 0.05 3 # AgeSel_5P_2_MRIP_E_BLK5repl_2008
 -5 3 -1.18931 -2.3 1 0.05 3 # AgeSel_5P_2_MRIP_E_BLK5repl_2011
 -4 12 1.78536 1.6 1 0.05 3 # AgeSel_5P_3_MRIP_E_BLK5repl_2008
 -4 12 -1.90776 1.6 1 0.05 3 # AgeSel_5P_3_MRIP_E_BLK5repl_2011
 -2 6 1.97388 1.7 1 0.05 3 # AgeSel_5P_4_MRIP_E_BLK5repl_2008
 -2 6 2.14102 1.7 1 0.05 3 # AgeSel_5P_4_MRIP_E_BLK5repl_2011
 -15 5 -8.92309 -8.3 1 0.05 2 # AgeSel_5P_5_MRIP_E_BLK5repl_2008
 -15 5 -10.6909 -8.3 1 0.05 2 # AgeSel_5P_5_MRIP_E_BLK5repl_2011
 -5 5 -3.88496 -1.8 1 0.05 2 # AgeSel_5P_6_MRIP_E_BLK5repl_2008
 -5 5 -3.13483 -1.8 1 0.05 2 # AgeSel_5P_6_MRIP_E_BLK5repl_2011
 0 19.8 2.27802 5.4 1 0.05 2 # AgeSel_6P_1_MRIP_W_BLK5repl_2008
 0 19.8 3.59744 5.4 1 0.05 2 # AgeSel_6P_1_MRIP_W_BLK5repl_2011
 -5 3 -2.01573 -2.3 1 0.05 3 # AgeSel_6P_2_MRIP_W_BLK5repl_2008
 -5 3 -3.94328 -2.3 1 0.05 3 # AgeSel_6P_2_MRIP_W_BLK5repl_2011
 -4 12 -1.59533 1.6 1 0.05 3 # AgeSel_6P_3_MRIP_W_BLK5repl_2008
 -4 12 0.942638 1.6 1 0.05 3 # AgeSel_6P_3_MRIP_W_BLK5repl_2011
 -2 6 0.737643 1.7 1 0.05 3 # AgeSel_6P_4_MRIP_W_BLK5repl_2008
 -2 6 2.79947 1.7 1 0.05 3 # AgeSel_6P_4_MRIP_W_BLK5repl_2011
 -15 5 -3.00789 -8.3 1 0.05 2 # AgeSel_6P_5_MRIP_W_BLK5repl_2008
 -15 5 -10.8227 -8.3 1 0.05 2 # AgeSel_6P_5_MRIP_W_BLK5repl_2011
 -5 5 -3.66989 -1.8 1 0.05 2 # AgeSel_6P_6_MRIP_W_BLK5repl_2008
 -5 5 -3.14159 -1.8 1 0.05 2 # AgeSel_6P_6_MRIP_W_BLK5repl_2011
 0 19.8 3.06417 5.4 1 0.05 2 # AgeSel_7P_1_HBT_E_BLK5repl_2008
 0 19.8 3.78383 5.4 1 0.05 2 # AgeSel_7P_1_HBT_E_BLK5repl_2011
 -5 3 -4.79854 -2.3 1 0.05 3 # AgeSel_7P_2_HBT_E_BLK5repl_2008
 -5 3 -4.84726 -2.3 1 0.05 3 # AgeSel_7P_2_HBT_E_BLK5repl_2011
 -4 12 -0.0955082 1.6 1 0.05 3 # AgeSel_7P_3_HBT_E_BLK5repl_2008
 -4 12 0.315724 1.6 1 0.05 3 # AgeSel_7P_3_HBT_E_BLK5repl_2011
 -2 6 2.54663 1.7 1 0.05 3 # AgeSel_7P_4_HBT_E_BLK5repl_2008
 -2 6 2.90763 1.7 1 0.05 3 # AgeSel_7P_4_HBT_E_BLK5repl_2011
 -15 5 -10.4343 -8.3 1 0.05 2 # AgeSel_7P_5_HBT_E_BLK5repl_2008
 -15 5 -11.5411 -8.3 1 0.05 2 # AgeSel_7P_5_HBT_E_BLK5repl_2011
 -5 5 -4.54451 -1.8 1 0.05 2 # AgeSel_7P_6_HBT_E_BLK5repl_2008
 -5 5 -3.72947 -1.8 1 0.05 2 # AgeSel_7P_6_HBT_E_BLK5repl_2011
 0 19.8 3.46153 5.4 1 0.05 2 # AgeSel_8P_1_HBT_W_BLK5repl_2008
 0 19.8 4.61047 5.4 1 0.05 2 # AgeSel_8P_1_HBT_W_BLK5repl_2011
 -5 3 -3.52564 -2.3 1 0.05 3 # AgeSel_8P_2_HBT_W_BLK5repl_2008
 -5 3 -4.94778 -2.3 1 0.05 3 # AgeSel_8P_2_HBT_W_BLK5repl_2011
 -4 12 -1.52657 1.6 1 0.05 3 # AgeSel_8P_3_HBT_W_BLK5repl_2008
 -4 12 0.369315 1.6 1 0.05 3 # AgeSel_8P_3_HBT_W_BLK5repl_2011
 -2 6 1.62573 1.7 1 0.05 3 # AgeSel_8P_4_HBT_W_BLK5repl_2008
 -2 6 1.29668 1.7 1 0.05 3 # AgeSel_8P_4_HBT_W_BLK5repl_2011
 -15 5 -10.4078 -8.3 1 0.05 2 # AgeSel_8P_5_HBT_W_BLK5repl_2008
 -15 5 -11.5248 -8.3 1 0.05 2 # AgeSel_8P_5_HBT_W_BLK5repl_2011
 -5 5 -2.82795 -1.8 1 0.05 2 # AgeSel_8P_6_HBT_W_BLK5repl_2008
 -5 5 -3.23967 -1.8 1 0.05 2 # AgeSel_8P_6_HBT_W_BLK5repl_2011
 #_Cond	No	selex	parm	trends																											
#_Cond	-4	#	placeholder	for	selparm_Dev_Phase																										
3	#_env/block/dev_adjust_method	(1=standard;	2=logistic	trans	to	keep	in	base	parm	bounds;	3=standard	w/	no	bound	check)																
#																															
#	Tag	loss	and	Tag	reporting	parameters	go	next																							
0	#	TG_custom:	0=no	read;	1=read	if	tags	exist																							
#_Cond	-6	6	1	1	2	0.01	-4	0	0	0	0	0	0	0	#_placeholder	if	no	parameters													
#																															
1	#_Variance_adjustments_to_input_values																														
#_fleet:	1	2	3	4	5	6	7	8	9	10	11	12	13	14	survey:	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	#_add_to_survey_CV		
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	#_add_to_discard_stddev		
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	#_add_to_bodywt_CV		
1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	#_mult_by_lencomp_N		
1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	#_mult_by_agecomp_N		
1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	#_mult_by_size-at-age_N		
#																															
7	#_maxlambdaphase																														
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