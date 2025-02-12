
#delimit ;
* DEFINE WORKING DIRECTORY;
global workd "/GitHub/ideology_specification";
log using "$workd/code/Log Files/02_Main_Regs.log", replace;
clear matrix;
clear mata;

use "$workd/data/df.dta", clear;




*DESCRIPTIVE TABLE AT THE MODEL LEVEL;

tabulate topic_knowledge, sum(topic_brw);
tabulate statistics_skill, sum(stats_brw);
tabulate model_score, sum(model_brw);

generate hmodel=(model_score=="High");


summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  ;
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  if index==1 ;
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  if index==2;
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  if index==3;


*SUMMARY STATS WEIGHTED BY THE INVERSE OF THE NUMBER OF MODELS;
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2   [aw=1/nmodel];
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  if index==1  [aw=1/nmodel];
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  if index==2 [aw=1/nmodel];
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  if index==3 [aw=1/nmodel];

preserve;
collapse (mean) team_size group1 group2 group3, by(teamid);
summ team_size;
summ team_size if group1==1;
summ team_size if group2==1;
summ team_size if group3==1;
restore;








***************************************************************************;

*ALL REGRESSIONS WILL BE WEIGHTED BY 1/NMODEL SO THEY ARE NUMERICALLY EQUIVALENT TO TEAM LEVEL REGRESSIONS;
*WILL LEAVE OUT PMALE FROM ALL REGRESSIONS;
*WILL INCLUDE TEAM_SIZE IN THE REFEREE SCORE, QUALITY REGRESSIONS;

reg ame  proindex    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
reg ame  p12 p56    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg ame  group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
reg ame  group1 group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
* as Stata is our main software for analysis, we save these results as the file stata_adj_means.csv for Fig1
margins, dydx(group1 group3) level(90)
margins, at(group1 == 0 group3 == 0) level(90)
lincom group3-group1;




*ADDING BELIEF;
reg ame  proindex pbelief  stats_brw topic_brw t2 t3 i.mdegree    [aw=1/nmodel] ,  cluster(teamid);
reg ame  p12 p56  pbelief  stats_brw topic_brw t2 t3 i.mdegree    [aw=1/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg ame  group3  pbelief  stats_brw topic_brw t2 t3 i.mdegree    [aw=1/nmodel] ,  cluster(teamid);
reg ame  group1 group3  pbelief  stats_brw topic_brw t2 t3 i.mdegree    [aw=1/nmodel] ,  cluster(teamid);
lincom group3-group1;




***************************************************************************;


*WEIGHTED REGRESSIONS USING PSCORE/NMODEL;
*WEIGHTING BY QUALITY HELPS ADDRESS PUBLICATION BIAS PROBLEM;
reg ame  proindex    stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);
reg ame  p12 p56    stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg ame  group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);
reg ame  group1 group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);
lincom group3-group1;





*ADDING BELIEF;
reg ame  proindex  pbelief  stats_brw topic_brw t2 t3 i.mdegree    [aw=pscore/nmodel] ,  cluster(teamid);
reg ame  p12 p56  pbelief  stats_brw topic_brw t2 t3 i.mdegree    [aw=pscore/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg ame  group3  pbelief  stats_brw topic_brw t2 t3 i.mdegree    [aw=pscore/nmodel] ,  cluster(teamid);
reg ame  group1 group3  pbelief  stats_brw topic_brw t2 t3 i.mdegree    [aw=pscore/nmodel] ,  cluster(teamid);
lincom group3-group1;





*GETTING PERCENTILE DIFFERENCE BETWEEN PRO AND ANTI IMMIGRATION TEAMS;



reg ame  group1 group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
predict rame, resid;
xtile prame=rame [aw=1/nmodel], n(100);

tabulate mdegree, gen(dum);
center stats_brw topic_brw t2 t3 dum* [aw=1/nmodel];
reg ame group1 group3 c_* [aw=1/nmodel], cluster(teamid);
reg ame group1 group2 group3 c_* [aw=1/nmodel], cluster(teamid) nocons;

tabulate prame, sum(rame);




********************************************************************;
*OLS REGRESSIONS ON OUTLYING NEGATIVE & SIGNIFICANT OUTCOMES;


summ pos10-neg10s;
summ pos10-neg10s [aw=model_brw];

reg neg10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg neg10s p12 p56   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg neg10s group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg neg10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
lincom group3-group1;
reg neg10s p12 p56 pbelief  stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg neg10s group1 group3 pbelief stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
lincom group3-group1;



*REGRESSIONS ON OUTLYING POSITIVE & SIGNIFICANT COEFFICIENTS;
reg pos10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg pos10s p12 p56   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg pos10s group1   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg pos10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
lincom group3-group1;
reg pos10s p12 p56 pbelief  stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg pos10s group1 group3 pbelief stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
lincom group3-group1;

*make a pscore that averages 1 for balanced weighting;
gen pscore_1 = pscore - 3.190467;

*WEIGHTED BY PEER REFEREE SCORES;
reg neg10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/(pscore_1*nmodel)] ,  cluster(teamid);
reg neg10s p12 p56   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/(pscore_1*nmodel)] ,  cluster(teamid);
lincom p56-p12;
reg neg10s group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/(pscore_1*nmodel)] ,  cluster(teamid);
reg neg10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/(pscore_1*nmodel)] ,  cluster(teamid);
lincom group3-group1;
reg neg10s p12 p56 pbelief  stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/(pscore_1*nmodel)] ,  cluster(teamid);
lincom p56-p12;
reg neg10s group1 group3 pbelief stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/(pscore_1*nmodel)] ,  cluster(teamid);
lincom group3-group1;

*REGRESSIONS ON OUTLYING POSITIVE & SIGNIFICANT COEFFICIENTS;
reg pos10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/(pscore_1*nmodel)] ,  cluster(teamid);
reg pos10s p12 p56   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/(pscore_1*nmodel)] ,  cluster(teamid);
lincom p56-p12;
reg pos10s group1   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/(pscore_1*nmodel)] ,  cluster(teamid);
reg pos10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/(pscore_1*nmodel)] ,  cluster(teamid);
lincom group3-group1;
reg pos10s p12 p56 pbelief  stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/(pscore_1*nmodel)] ,  cluster(teamid);
lincom p56-p12;
reg pos10s group1 group3 pbelief stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/(pscore_1*nmodel)] ,  cluster(teamid);
lincom group3-group1;



*RELATIONSHIP BETWEEN NEW MEASURE OF QUALITY OF RESEARCH AND PRO-IMMIGRATION INDEX;
*NOTE THESE REGRESSIONS LOSE A FEW OBSERVATIONS BECAUSE PEER_MEAN IS NOT AVAILABLE FOR 38 OBSERVATIONS;




summ quality2;


*WEIGHT ALSO BY PEER_N, NUMBER OF REVIEWERS THAT MODEL HAD;


*NEW REFEREE SCORE MEASURE AS DEPENDENT VARIABLE;
reg zpeer_mean p12 p56     stats_brw topic_brw t2 t3 i.mdegree  [aw=peer_n/nmodel] ,  cluster(teamid);
reg zpeer_mean group1 group3     stats_brw topic_brw t2 t3 i.mdegree   [aw=peer_n/nmodel] ,  cluster(teamid);






*QUALITY MODELS LOSE A LOT OF SINGLETON OBSERVATIONS IF WE USE LOGIT;
*SO WILL DO LINEAR PROBABILITY MODEL INSTEAD;


*OLS MODELS ON HIGH quality2;
reg quality2 p12 p56     stats_brw topic_brw t2 t3 i.mdegree   [aw=peer_n/nmodel] , cluster(teamid);
reg quality2 group1 group3     stats_brw topic_brw t2 t3 i.mdegree   [aw=peer_n/nmodel] , cluster(teamid);





*USING MEDIAN;

generate y1=att1;
generate y2=att2;
generate y3=att3;

gen median = y1 + y2 + y3 - min(y1, y2, y3) - max(y1, y2, y3);
replace median = max(y1, y2, y3) if 
	(missing(y1) + missing(y2) + missing(y3)) == 2 ;
replace median = (         cond(missing(y1), 0, y1) + 
        cond(missing(y2), 0, y2) + 
        cond(missing(y3), 0, y3) ) / 2 
        if (missing(y1) + missing(y2) + missing(y3)) == 1 	;

* For later loading;
save "$workd/data/newmodel.dta", replace;

log close;
