#C generic forecast file
#V3.20b
# for all year entries except rebuilder; enter either: actual year, -999 for styr, 0 for endyr, neg number for rel.endyr
1 # Benchmarks: 0=skip; 1=calc F_spr,F_btgt,F_msy
#it calculates targets at MSY, SPR, and biomass targets all independently during model run
2 # MSY: 1= set to F(SPR); 2=calc F(MSY); 3=set to F(Btgt); 4=set to F(endyr)
0.32 # SPR target (e.g. 0.40)
0.3 # Biomass target (e.g. 0.40)  
-1 -1 -1 -1 2012 2014 #_Bmark_years: beg_bio, end_bio, beg_selex, end_selex, beg_relF, end_relF (enter actual year, or values of 0 or -integer to be rel. endyr) - use range of year where there was not change in any time varying processies, i.e. time varying change in selectivity, chagne in R0, etc.
1 #Bmark_relF_Basis: 1 = use year range; 2 = set relF same as forecast below
1 # Forecast: 0=none; 1=F(SPR); 2=F(MSY) 3=F(Btgt); 4=Ave F (uses first-last relF yrs); 5=input annual F scalar
60 # N forecast years
0.2 # F scalar (only used for Do_Forecast==5)
-1 -1 2012 2014 #_Fcast_years: beg_selex, end_selex, beg_relF, end_relF (enter actual year, or values of 0 or -integer to be rel.endyr) # the last years to use F - typically use the last three years! 
2 # Control rule method (1=catch=f(SSB) west coast; 2=F=f(SSB) )   # leave alone 
0.01 # Control rule Biomass level for constant F (as frac of Bzero, e.g. 0.40) - leave this alone, this is west coast thing
0.001 # Control rule Biomass level for no F (as frac of Bzero, e.g. 0.10)   - leave this alone, this is west coast thing
.75 # Control rule target as fraction of Flimit (e.g. 0.75)   # this is to do the F at OY - i.e. the 75 percent of Fmsy
2 #_N forecast loops (1-3) (fixed at 3 for now)   # leave alone 
3 #_First forecast loop with stochastic recruitment        # leave alone 
0 #_Forecast loop control #3 (reserved for future bells&whistles)     # leave alone 
0 #_Forecast loop control #4 (reserved for future bells&whistles)     # leave alone 
0 #_Forecast loop control #5 (reserved for future bells&whistles)    # leave alone 
#get final 2012 landings info from data:  commecial get from IFQ page, recreation may not be final and may have to do some hole filling - get with Vivian on this.
2074 #FirstYear for caps and allocations (should be after years with fixed inputs)  # thsi is the year when to start the projections - remember triggefish, when we added the landings from the last year sicne they wanted manamagement advice from current year
0 # stddev of log(realized catch/target catch) in forecast (set value>0.0 to cause active impl_error)
0 # Do West Coast gfish rebuilder output (0/1)
2011 # Rebuilder: first year catch could have been set to zero (Ydecl)(-1 to set to 1999)
-1 # Rebuilder: year for current age structure (Yinit) (-1 to set to endyear+1)
#this is how we allocate fishing effort and mortality with the fleets - i.e  we want a fixed effort for the shrimp fleets and constant level of closed season discards in the projections going forward - talk with Jake about how to do this
1 # fleet relative F: 1=use first-last alloc year; 2=read seas(row) x fleet(col) below
# Note that fleet allocation is used directly as average F if Do_Forecast=4
# this will just give you retained biomass and won't have to back out the discards
3 # basis for fcast catch tuning and for fcast catch caps and allocation (2=deadbio; 3=retainbio; 5=deadnum;6=retainnum)
# Conditional input if relative F choice = 2
# Fleet relative F: rows are seasons, columns are fleets
#_Fleet: FISHERY1
# 1
# max totalcatch by fleet (-1 to have no max)
-1 -1 -1 -1
# max totalcatch by area (-1 to have no max)
-1
# fleet assignment to allocation group (enter group ID# for each fleet, 0 for not included in an alloc group)
0 0 0 0
#_Conditional on >1 allocation group
# allocation fraction for each of: 0 allocation groups # BY YEAR VOR SS VERSION 
# no allocation groups
66 # Number of forecast catch levels to input (else calc catch from forecast F)
99 # basis for input Fcast catch: 2=dead catch; 3=retained catch; 99=input Hrate(F) (units are from fleetunits; note new codes in SSV3.20)
#Year	Seas	Fleet	Catch(or_F)	
2015 1 1 0.05492551
2015 1 2 0.05005713
2015 1 3 0.04969543
2015 1 4 0.07356127
2016 1 1 0.05971905
2016 1 2 0.05442581
2016 1 3 0.05403253
2016 1 4 0.07356127
2017 1 4 0.07356127
2018 1 4 0.07356127
2019 1 4 0.07356127
2020 1 4 0.07356127
2021 1 4 0.07356127
2022 1 4 0.07356127
2023 1 4 0.07356127
2024 1 4 0.07356127
2025 1 4 0.07356127
2026 1 4 0.07356127
2027 1 4 0.07356127
2028 1 4 0.07356127
2029 1 4 0.07356127
2030 1 4 0.07356127
2031 1 4 0.07356127
2032 1 4 0.07356127
2033 1 4 0.07356127
2034 1 4 0.07356127
2035 1 4 0.07356127
2036 1 4 0.07356127
2037 1 4 0.07356127
2038 1 4 0.07356127
2039 1 4 0.07356127
2040 1 4 0.07356127
2041 1 4 0.07356127
2042 1 4 0.07356127
2043 1 4 0.07356127
2044 1 4 0.07356127
2045 1 4 0.07356127
2046 1 4 0.07356127
2047 1 4 0.07356127
2048 1 4 0.07356127
2049 1 4 0.07356127
2050 1 4 0.07356127
2051 1 4 0.07356127
2052 1 4 0.07356127
2053 1 4 0.07356127
2054 1 4 0.07356127
2055 1 4 0.07356127
2056 1 4 0.07356127
2057 1 4 0.07356127
2058 1 4 0.07356127
2059 1 4 0.07356127
2060 1 4 0.07356127
2061 1 4 0.07356127
2062 1 4 0.07356127
2063 1 4 0.07356127
2064 1 4 0.07356127
2065 1 4 0.07356127
2066 1 4 0.07356127
2067 1 4 0.07356127
2068 1 4 0.07356127
2069 1 4 0.07356127
2070 1 4 0.07356127
2071 1 4 0.07356127
2072 1 4 0.07356127
2073 1 4 0.07356127
2074 1 4 0.07356127

999 # verify end of input			

