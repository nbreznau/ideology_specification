#delimit ;
log using /volumes/ddisk/mi/researcher/reg_indiv.log, replace;
clear matrix;
clear mata;





*GETTING INDIVIDUAL LEVEL STATS & TOPIC INDECES;

use "/volumes/Ddisk/MI/Researcher/sem_p.dta", clear;

keep u_id stats topic belief;
rename stats stats_i;
rename topic topic_i;
rename belief belief_i;
sort u_id;

save /volumes/ddisk/data/junkindex.dta, replace;






*GETTING INDIVIDUAL-MODEL LEVEL DATA;

use /volumes/ddisk/mi/researcher/cri_long_participant_ame_dyad.dta, replace;


rename u_teamid teamid;

*MERGING IN INDIVIDUAL LEVEL INDICES;
sort u_id;
merge u_id using /volumes/ddisk/data/junkindex.dta;
drop _merge;


rename AME ame;
destring ame, force replace;
drop if ame==.;

rename attitude_immigration_1 att;
destring att, force replace;
tabulate att;
replace att=7-att;
tabulate att;

generate index=1*(att==1 | att==2) + 2*(att==3 | att==4) + 3*(att==5 | att==6);
tabulate index, missing;
drop if index==0;

generate indiv1=(index==1);
generate indiv2=(index==2);
generate indiv3=(index==3);



*GETTING HISTOGRAM USING INDIVIDUAL LEVEL DATA;

generate ame2=ame;
replace ame2=-.35 if ame<-.35;
replace ame2=.35 if ame>.35; 

*twoway (kdensity ame2 if index==1 [fw=1], kernel(ep) lcolor(red) fcolor(red%2) lwidth(medium) bwidth(.03) )
	(kdensity ame2 if index==2 [fw=1],kernel(ep) lcolor(green) fcolor(green%20) lwidth(medium) bwidth(.03) ) 
	(kdensity ame2 if index==3 [fw=1], kernel(ep) lcolor(blue) fcolor(blue%2) lwidth(medium) bwidth(.03)) ,
	legend(pos(6) rows(1)) legend(order(1 "Anti-immigrant Researchers" 2 "Moderate Researchers" 3 "Pro-immigrant Researchers"))
	saving(/volumes/ddisk/mi/researcher/hist_ame_indiv.gph, replace);



*INDIVIDUAL LEVEL FIELD OF STUDY;

rename backgr_degree degree;
destring degree, force replace;




*GET NUMBER OF MODELS EACH PERSON SUBMITTED;
egen nmodel=count(ame), by(u_id);




*BELIEF IN HYPOTHESIS AT INDIVIDUAL LEVEL;
tabulate belief_H1_1;
destring belief_H1_1, force replace;
generate pbelief=(belief_H1_1<=2);










*MERGING IN ALTERNATIVE REFEREE SCORE;
sort id;
merge id using /volumes/ddisk/mi/researcher/cri_new_peer_scores.dta;
drop _merge;
drop if ame==.;


*IMPUTING MISSING VALUES OF PEER_MEAN USING MODEL_SCORE AND SPECIFICATION CHARATERISTICS;
rename Jobs jobs;
rename Unemp unemp;
rename IncDiff incdiff;
rename OldAge oldage;
rename House house;
rename Health health;
rename Scale scale;
rename Stock stock;
rename Flow flow;
rename ChangeFlow changeflow;
rename BELIEF_HYPOTHESIS belief_hypothesis;
global design jobs-health logit ols stock flow changeflow w1985-w2016 orig13 eeurope allavailable 
	twowayfe level_cyear mlm_fe mlm_re anynonlin;

generate model_brw=total_score;
summ peer_mean model_brw;
generate pscore=peer_mean;
regress peer_mean model_brw $design;
predict phat;
replace pscore=phat if peer_mean==.;

summ pscore peer_mean model_brw;
corr pscore model_brw;







*NOTE THAT USING ID AS WEIGHT LEADS TO MUCH LOWER STANDARD ERRORS;
reg ame  indiv1 indiv3    stats_i topic_i  i.degree    ,  cluster(teamid);
reg ame  indiv1 indiv3    stats_i topic_i  i.degree    ,  cluster(id);

*NOTE THAT REGHDFE COMMAND CLUSTERING AT BOTH TEAM AND ID LEVEL IS SAME AS REG COMMAND CLUSTERING AT TEAM LEVEL;
reghdfe ame  indiv1 indiv3   stats_i topic_i    , absorb(degree) cluster(teamid id);







*FILLING IN MISSING VALUES FOR INDIVIDUAL-LEVEL STATS & TOPIC INDEX;
destring stats_ipred, force replace;
destring topic_ipred, force replace;
destring belief_ipred, force replace;

*THE STATS_IPRED AND TOPIC_IPRED VARIABLES ARE MISSING FOR TEAM 27, WILL IMPUTE USING HOT DECK PREDICTION;
replace stats_ipred=0.102538885683808 if teamid==27;
replace topic_ipred=-0.25372224552600 if teamid==27;
replace belief_hypothesis="Low" if teamid==27;
replace belief_ipred=-1.13508799270782 if teamid==27;



*CORRECT CODING ERROR IN BELIEF_IPRED;
replace belief_ipred=-belief_ipred;


generate stats_old=stats_i;
generate topic_old=topic_i;
generate belief_old=belief_i;


*WILL NOW FILL IN MISSING INDIVIDUAL INFORMATION USING HOT DECK IMPUTATION BASED ON DEGREE;
*AND BASED ON TEAM'S STATISTICS_SKILL AND TOPIC_KNOWLEDGE;
summ stats_i stats_ipred topic_i topic_ipred  belief_i belief_ipred;



egen statimp=mean(stats_i), by(degree STATISTICS_SKILL);
egen topicimp=mean(topic_i), by(degree TOPIC_KNOWLEDGE );
egen beliefimp=mean(belief_i), by(degree belief_hypothesis);

replace stats_i=statimp if stats_i==.;
replace topic_i=topicimp if topic_i==.;
replace belief_i=beliefimp if belief_i==.;




*INDIVIDUAL LEVEL INDICES WILL BE SET TO MISSING IF THEY ARE MISSING BASIC INFORMATION ON STATS & TOPIC;
*THIS AFFECTS TEAM 33, WHICH ALTHOUGH HAS TEAM_SIZE = 3, THERE IS ONLY ONE U_ID FOR THE TEAM;
replace stats_i=. if teamid==33;
replace topic_i=. if teamid==33;
replace belief_i=. if teamid==33;
summ ame stats_i stats_ipred topic_i topic_ipred belief_i belief_ipred stats_old topic_old belief_old;



reg ame  indiv1 indiv3  stats_i topic_i i.degree  [aw=1/team_size]  ,  cluster(teamid);



summ ame indiv1 indiv3 pbelief stats_i topic_i;

*THE WEIGHT THAT WILL LEAD TO ABOUT 71 WEIGHTED OBSERVATIONS;
generate pweight=1/(team_size*nmodel);

reg ame  indiv1 indiv3  stats_i topic_i i.team_size i.degree  [aw=pweight]  ,  cluster(teamid);
lincom indiv3-indiv1;
reg ame  indiv1 indiv3  stats_i topic_i i.team_size i.degree  [aw=pscore*pweight]  ,  cluster(teamid);
lincom indiv3-indiv1;


*INCLUDING BELIEF VARIABLE;

reg ame  indiv1 indiv3 pbelief stats_i topic_i i.team_size i.degree  [aw=pweight]  ,  cluster(teamid);
lincom indiv3-indiv1;
reg ame  indiv1 indiv3 pbelief stats_i topic_i i.team_size i.degree  [aw=pscore*pweight]  ,  cluster(teamid);
lincom indiv3-indiv1;


*SAME REGRESSIONS BUT USING REGHDFE COMMAND AND CLUSTERING AT TEAM-MODEL-INDIVIDUAL LEVEL;

generate pweight2=pscore*pweight;

reghdfe ame  indiv1 indiv3  stats_i topic_i i.degree  [aw=pweight]    , 
	absorb(degree) cluster(u_id teamid id);
lincom indiv3-indiv1;
reghdfe ame  indiv1 indiv3  stats_i topic_i i.degree  [aw=pweight2]    , 
	absorb(degree) cluster(u_id teamid id);
lincom indiv3-indiv1;

reghdfe ame  indiv1 indiv3 pbelief stats_i topic_i i.degree  [aw=pweight]    , 
	absorb(degree) cluster(u_id teamid id);
lincom indiv3-indiv1;
reghdfe ame  indiv1 indiv3 pbelief stats_i topic_i i.degree  [aw=pweight2]    , 
	absorb(degree) cluster(u_id teamid id);
lincom indiv3-indiv1;



kkk;




********************************************************************;

*GETTING EFFECTS ON ESTIMATE BY LOOKING AT EXTREME SIGNIFICANT COEFFICIENTS, USING 10TH AND 90TH PERCENTILES;

destring z, force replace;
replace z=abs(z);

generate negsig=(ame<0 & z>1.645);
generate possig=(ame>0 & z>1.645);

summ ame;
generate pos10=(ame>.052);
generate neg10=(ame<-.071);
generate pos10s=(ame>.052 & z>1.645);
generate neg10s=(ame<-.071 & z>1.645);

summ pos10-neg10s;
summ pos10-neg10s [aw=model_brw];

*LOGIT REGRESSIONS ON OUTLYING NEGATIVE & SIGNIFICANT COEFFICIENTS;
quietly logit neg10 indiv1 indiv3   stats_i topic_i  i.team_size i.degree  [iw=pweight] ,  cluster(teamid);
margins, dydx(indiv1-topic_i);
quietly logit neg10s indiv1 indiv3   stats_i topic_i  i.team_size i.degree  [iw=pweight] ,  cluster(teamid);
margins, dydx(indiv1-topic_i);




*LOGIT REGRESSIONS ON OUTLYING POSITIVE & SIGNIFICANT COEFFICIENTS;
quietly logit pos10 indiv1 indiv3   stats_i topic_i  i.team_size i.degree  [iw=pweight] ,  cluster(teamid);
margins, dydx(indiv1-topic_i);
quietly logit pos10s indiv1 indiv3   stats_i topic_i  i.team_size i.degree  [iw=pweight] ,  cluster(teamid);
margins, dydx(indiv1-topic_i);




*LOGIT WEIGHTED REGRESSIONS ON OUTLYING NEGATIVE & SIGNIFICANT COEFFICIENTS;
quietly logit neg10 indiv1 indiv3   stats_i topic_i  i.team_size i.degree  [iw=pscore*pweight] ,  cluster(teamid);
margins, dydx(indiv1-topic_i);
quietly logit neg10s indiv1 indiv3   stats_i topic_i  i.team_size i.degree  [iw=pscore*pweight] ,  cluster(teamid);
margins, dydx(indiv1-topic_i);




*LOGIT WEIGHTED REGRESSIONS ON OUTLYING POSITIVE & SIGNIFICANT COEFFICIENTS;
quietly logit pos10 indiv1 indiv3   stats_i topic_i  i.team_size i.degree  [iw=pscore*pweight] ,  cluster(teamid);
margins, dydx(indiv1-topic_i);
quietly logit pos10s indiv1 indiv3   stats_i topic_i  i.team_size i.degree  [iw=pscore*pweight] ,  cluster(teamid);
margins, dydx(indiv1-topic_i);




*REFEREE SCORE REGRESSIONS;

generate quality2=(peer_mean>4.5);
replace quality2=. if peer_mean==.;


reg peer_mean  indiv1 indiv3  stats_i topic_i i.degree  [aw=pweight]  ,  cluster(teamid);
reg quality2  indiv1 indiv3  stats_i topic_i i.degree  [aw=pweight]  ,  cluster(teamid);
quietly logit quality2 indiv1 indiv3   stats_i topic_i  i.degree  [iw=pweight] ,  cluster(teamid);
margins, dydx(indiv1-topic_i);


*twoway (kdensity peer_mean if index==1 [fw=1], kernel(ep) lcolor(red) fcolor(red%2) lwidth(medium) bwidth(.2) )
	(kdensity peer_mean if index==2 [fw=1],kernel(ep) lcolor(green) fcolor(green%20) lwidth(medium) bwidth(.2) ) 
	(kdensity peer_mean if index==3 [fw=1], kernel(ep) lcolor(blue) fcolor(blue%2) lwidth(medium) bwidth(.2)) ,
	legend(pos(6) rows(1)) legend(order(1 "Anti-immigrant Researchers" 2 "Moderate Researchers" 3 "Pro-immigrant Researchers"));


log close;
