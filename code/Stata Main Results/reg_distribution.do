#delimit ;
log using /volumes/ddisk/mi/researcher/reg_distribution.log, replace;
clear matrix;
clear mata;




*THIS IS THE PROGRAM USED TO GET THE DESCRIPTIVE FREQUENCY DISTRIBUTIONS;




*THE PROGRAM USES BOTH THE TEAM LEVEL DATA AND THE MODEL LEVEL DATA;
*IT EXAMINES INCONSISTENCY IN THE SUMMARY MEASURE OF THE BELIEF VARIABLE IN THE BRW DATA FILE;


*********************************************************;
*PROGRAM ALSO CALCULATES DISTRIBUTION OF BELIEF VARIABLES ACROSS RESEARCHERS TO CHECK IF NUMERICAL DISTRIBUTION;
*MATCHES ORDER OF CODES WITH QUESTIONNAIRE;

*THESE DISTRIBUTIONS CONFIRM THAT "1" MEANS STRONG BELIEVE HYPOTHESIS IMMIGRATION REDUCES SUPPORT;
*AND "4" MEANS IMMIGRATION SOMEWHAT INCREASES SUPPORT FOR WELFARE STATE POLICIES;
*********************************************************;





use /volumes/ddisk/mi/researcher/cri_team.dta, clear;



rename BELIEF_HYPOTHESIS belief_hypothesis;
rename TOPIC_KNOWLEDGE topic_knowledge;
rename STATISTICS_SKILL statistics_skill;
rename MODEL_SCORE model_score;
rename AME ame;
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
rename belief_H1_11 belief_h1_11;
rename belief_H1_12 belief_h1_12;
rename belief_H1_13 belief_h1_13;
rename belief_H1_21 belief_h1_21;
rename belief_H1_22 belief_h1_22;
rename belief_H1_23 belief_h1_23;
rename belief_H1_31 belief_h1_31;
rename belief_H1_32 belief_h1_32;
rename belief_H1_33 belief_h1_33;
rename Hresult hresult;
rename Hsupport hsupport;
rename Hreject hreject;
rename Hrej hrej;
rename Hsup hsup;


destring u_teamid, force replace;
rename u_teamid teamid;
egen nobs=count(ame), by(teamid);
*DROPS THE EXTRA OBSERVATION FOR THE 15 TEAMS;
drop if nobs==2 & stock==0;
summ ame;

*DROPS THE BRADY-FINNIGAN TEAM;
drop if teamid==0;


*DROPS THE TEAM THAT DIDN'T PRODUCE AN AME;
destring ame, force replace;
drop if ame==.;


unique teamid;


*NOTE THAT BELIEF_1_AVG AND BELIEF_H1_11 HAVE THE SAME VALUES FOR TEAM_SIZE=1;
*THEREFORE CODE 1 MEANS BELIEF STRONGLY REDUCES, AND CODE 4 MEANS BELIEF SOMEWHAT INCREASES;
*THIS MATCHES QUESTIONNAIRE CODING;
*NOTE THAT BELIEF_A_AVG AND BELIEF_H1_11 PERFECTLY MATCH FOR TEAM SIZE OF 1;
tabulate belief_1_avg belief_h1_11 if team_size==1;


*AND THIS IS WHERE CONTRADICTION SHOWS UP;
*NOTE THAT VALUE OF 1 IN THE BELIEF_H1 VARIABLE IS ASSOCIATED WITH "LOW" IN THE BELIEF_HYPOTHESIS VARIABLE;
*OR: HIGH VALUES OF BELIEF_1_AVG ARE ASSOCIATED WITH A "HIGH" IN BELIEF_HYPOTHESIS, AND LOW VALUES WITH A "LOW";
tabulate belief_1_avg belief_hypothesis;
tabulate belief_1_avg belief_hypothesis if team_size==1;




*CONFIRM WHAT THE CODES MEAN WITH PERSON-LEVEL DISTRIBUTION COMPARISON WITH PUBLISHED FREQUENCY;
tabulate team_size;
rename belief_h1_11 b11;
rename belief_h1_12 b12;
rename belief_h1_13 b13;
rename belief_h1_21 b21;
rename belief_h1_22 b22;
rename belief_h1_23 b23;
rename belief_h1_31 b31;
rename belief_h1_32 b32;
rename belief_h1_33 b33;
keep teamid team_size b11 b12 b13 b21 b22 b23 b31 b32 b33 belief_1_avg belief_hypothesis;
destring b11-b33 belief_1_avg, force replace;
summ b11-b33;




reshape long b1 b2 b3, i(teamid);
drop if b1==.;

tabulate b1, missing;
tabulate b2, missing;
tabulate b3, missing;

*NOW COMPARE TO CODING OF BELIEF_HYPOTHESIS VARIABLES B1, B2, B3 TO THE PUBLISHED APPENDIX;
*IN APPENDIX 1 IS BELIEF THAT IMM STRONGLY REDUCES AND 4 IS IMMIGRATION SOMEWHAT INCREASES SUPPORT;
*DISTRIBUTION OF B1 IS ROUGHLY SIMILAR, WITH MODE = 2, WITH FEWER OBSERVATIONS IN ACTUAL DATA;
*PUBLISHED FREQUENCY INCLUDES RESEARCHERS WHO DID NOT COMPLETE PROJECT (SEE P. 81 OF APPENDIX);
*DISTRIBUTION OF B2 IS ROUGHLY SIMILAR, WITH MODE = 2;
*DISTRIBUTION OF B3 IS ROUGHLY SIMILAR, WITH MODE = 3;

****CONCLUSION: CODING OF THE BELIEF_H1 VARIABLES IS SUCH THAT:
*1 = BELIEF STRONGLY REDUCES SUPPORT
*4 = BELIEF SOMEWHAT INCREASES SUPPORT;

*BUT NOW COMPARE TO CODING OF BELIEF_HYPOTHESIS VARIABLE;
gen meanb=(b1+b2+b3)/3;
tabulate b1 belief_hypothesis;
tabulate meanb belief_hypothesis;
tabulate b1 belief_hypothesis if team_size==1;
tabulate meanb belief_hypothesis if team_size==1;

****CODING OF THE BELIEF_HYPOTHESIS VARIABLE IS SUCH THAT:
*HIGH = BELIEF HAS NO SUPPORT OR SLIGHTLY INCREASES SUPPORT;
*LOW = BELIEF STRONGLY REDUCES SUPPORT;



*FREQUENCY DISTRIBUTION OF BELIEF IN HYPOTHESIS ACROSS RESEARCHERS;
tabulate b1;


hist b1, lcolor(blue) fcolor(blue%75) freq;












*FREQUENCY DISTRIBUTION OF PRO-IMMIGRATION INDEX AND OF DEGREE ACROSS RESEARCHERS;

use /volumes/ddisk/mi/researcher/cri_team.dta, clear;
destring u_teamid, force replace;


rename BELIEF_HYPOTHESIS belief_hypothesis;
rename TOPIC_KNOWLEDGE topic_knowledge;
rename STATISTICS_SKILL statistics_skill;
rename MODEL_SCORE model_score;
rename AME ame;
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
rename belief_H1_11 belief_h1_11;
rename belief_H1_12 belief_h1_12;
rename belief_H1_13 belief_h1_13;
rename belief_H1_21 belief_h1_21;
rename belief_H1_22 belief_h1_22;
rename belief_H1_23 belief_h1_23;
rename belief_H1_31 belief_h1_31;
rename belief_H1_32 belief_h1_32;
rename belief_H1_33 belief_h1_33;
rename Hresult hresult;
rename Hsupport hsupport;
rename Hreject hreject;
rename Hrej hrej;
rename Hsup hsup;



rename u_teamid teamid;
egen nobs=count(ame), by(teamid);
drop if nobs==2 & stock==0;
tabulate team_size;



rename pro_immigrant proindex;


*NOTE THAT THE A1 A2 A3 VARIABLES ARE IN REVERSE ORDER TO THE PROINDEX MEAN;
*IN QUESTIONNAIRE A HIGHER NUMBER IS IMMIGRATION LAWS SHOULD BE TOUGHER;
*BUT THE PROINDEX VARIABLE A HIGHER NUMBER IS IMMIGRATION LAWS SHOULD BE RELAXED;
tabulate attitude_immigration_11 proindex if team_size==1;

*SO WILL RESCALE THE ATTITUDINAL VARIABLES TO MAKE IT ALL CONSISTENT;
destring attitude_immigration_11 attitude_immigration_12 attitude_immigration_13 proindex, force replace;
rename attitude_immigration_11 a1;
rename attitude_immigration_12 a2;
rename attitude_immigration_13 a3;
replace a1=7-a1;
replace a2=7-a2;
replace a3=7-a3;
tabulate a1 proindex if team_size==1;


*keep teamid team_size a1 a2 a3 proindex;

destring backgr_degree1, force gen(degree1);
destring backgr_degree2, force gen(degree2);
destring backgr_degree3, force gen(degree3);


keep teamid team_size a1 a2 a3 degree1 degree2 degree3 proindex;



*ANOTHER PROBLEM SHOWS UP, TEAM_SIZE MAY NOT BE COMPLETELY RIGHT FOR THIS CALCULATION;
*SOME RESEARCHER-LEVEL DATA MAY BE MISSING;;

list teamid a1 a2 a3 proindex if team_size==1;
list teamid a1 a2 a3 proindex if team_size==2;
list teamid a1 a2 a3 proindex if team_size==3;

*CREATE NEW MEASURE OF TEAM_SIZE;
gen team=(a1~=.) + (a2~=.) + (a3~=.);
tabulate team team_size;



*CAN RECREATE PROINDEX USING CORRECTED MEASURE OF TEAM SIZE;
reshape long a degree, i(teamid);
drop if a==.;
egen suma=sum(a), by(teamid);
generate meana=suma/1 if team==1;
replace meana=suma/2 if team==2;
replace meana=suma/3 if team==3;
gen diff=meana-proindex;
summ diff;

*FREQUENCY DISTRIBUTION OF PRO-IMMIGRATION INDEX ACROSS RESEARCHERS;
tabulate a;

*FREQUENCY DISTRIBUTION OF DISCIPLINE ACROSS RESEARCHERS;
tabulate degree;


hist a, lcolor(red) fcolor(red%75) freq;











******************************************************************;


*DRAWING JOINT HISTOGRAMS OF AME;
*USING DATA CREATED IN REG_MODEL.DO;



use /volumes/ddisk/mi/researcher/model.dta, clear;


summ ame, detail;


*TRUNCATING TAILS OF DISTRIBUTION AT -.35 AND +.35;
generate ame2=ame;
replace ame2=-.35 if ame<-.35 ;
replace ame2=.35 if ame>.35 ;


xtile pame = ame, n(100);
tabulate pame, sum(ame);
drop pame;


xtile pame = ame2, n(100);
tabulate pame, sum(ame);



*GRAPHS USING 3-WAY INDEX, 3 KINDS OF TEAMS, GROUP1 GROUP2 GROUP3;

*twoway (kdensity ame2 if index==1 [fw=1], kernel(ep) lcolor(red) fcolor(red%2) lwidth(medium) bwidth(.03) )
		(kdensity ame2 if index==2 [fw=1],kernel(ep) lcolor(green) fcolor(green%20) lwidth(medium) bwidth(.03) ) 
		(kdensity ame2 if index==3 [fw=1], kernel(ep) lcolor(blue) fcolor(blue%2) lwidth(medium) bwidth(.03)) ,
		legend(pos(6) rows(1)) legend(order(1 "Anti-immigrant teams" 2 "Moderate teams" 3 "Pro-immigrant teams"));

*THIS SAVES THE GRAPH
*twoway (kdensity ame2 if index==1 [fw=1], kernel(ep) lcolor(red) fcolor(red%2) lwidth(medium) bwidth(.03)) 
	(kdensity ame2 if index==2 [fw=1],kernel(ep) lcolor(green) fcolor(green%20) lwidth(medium) bwidth(.03) ) 
	(kdensity ame2 if index==3 [fw=1], kernel(ep) lcolor(blue) fcolor(blue%2) lwidth(medium) bwidth(.03)) ,
	legend(pos(6) rows(1)) legend(order(1 "Anti-immigrant teams" 2 "Moderate teams" 3 "Pro-immigrant teams"))
	saving(/volumes/ddisk/mi/researcher/hist_ame_index.gph, replace);


*HISTOGRAM FOR SCORE FOR VARIOUS VALUES OF INDEX, USING MODEL LEVEL DATA;
*GRAPH IS IDENTICAL TO WHAT ONE WOULD GET IN THE COLLAPSED DATA , AND WEIGHTED BY NMODEL;

*THIS SAVES THE GRAPH FOR ORIGINAL MEASURE OF REFEREE SCORE;
*twoway (kdensity model_brw if index==1 [fw=1], kernel(ep) lcolor(red) fcolor(red%2) lwidth(medium) bwidth(.05)) 
		(kdensity model_brw if index==2 [fw=1],kernel(ep) lcolor(green) fcolor(green%20) lwidth(medium) bwidth(.05) ) 
		(kdensity model_brw if index==3 [fw=1], kernel(ep) lcolor(blue) fcolor(blue%2) lwidth(medium) bwidth(.05)) ,
		legend(pos(6) rows(1)) legend(order(1 "Anti-immigrant teams" 2 "Moderate teams" 3 "Pro-immigrant teams"))	
		saving(/volumes/ddisk/mi/researcher/hist_model.gph, replace);


*THIS SAVES THE GRAPH USING ALTERNATIVE MEASURE OF REFEREE SCORE;
*twoway (kdensity peer_mean if index==1 [fw=1], kernel(ep) lcolor(red) fcolor(red%2) lwidth(medium) bwidth(.20)) 
	(kdensity peer_mean if index==2 [fw=1],kernel(ep) lcolor(green) fcolor(green%20) lwidth(medium) bwidth(.20) ) 
	(kdensity peer_mean if index==3 [fw=1], kernel(ep) lcolor(blue) fcolor(blue%2) lwidth(medium) bwidth(.20)) ,
	legend(pos(6) rows(1)) legend(order(1 "Anti-immigrant teams" 2 "Moderate teams" 3 "Pro-immigrant teams"))
	saving(/volumes/ddisk/mi/researcher/hist_model2.gph, replace);





log close;

