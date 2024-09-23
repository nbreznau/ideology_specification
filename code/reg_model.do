 #delimit ;
log using /volumes/ddisk/mi/researcher/reg_model.log, replace;
clear matrix;
clear mata;



*USING SIMPLER AND FINAL SPECIFICATION FOR DEGREE INTERACTIONS;



*THE DATA IN CRI.CSV IS MODEL-LEVEL DATA;
*THE DATA IN CRI_TEAM.CSV IS TEAM-LEVEL DATA;
*TEAM LEVEL DATA CONTAINS MORE THAN ONE OBSERVATION PER TEAM FOR A FEW TEAMS, DUE TO STOCK-FLOW DISTINCTION;
*THIS PROGRAM USES THE MODEL LEVEL DATA;

/*
*DEFINITION OF KEY VARIABLES CONSTRUCTED BY BREZNAU-RINKE-WUTTKE (BRW) TEAM;
- `belief_ipred` - Belief that Hypothesis is true 	(that immigration reduces support), 
	team average of predicted factor scores
- `pro_immigrant` - Support laws to better integrate immigrants, team average, single question
- `topic_ipred` - Knowledge and experience with the topic of immigration and welfare state preferences, 
	team average of predicted factor scores
- `stats_ipred` - Knowledge and experience with quantiative statistical analysis, 
	team average of predicted factor scores
- `total_score` - Average score of each model from subjective voting amongst participants, 
	each participant reviewed 3 to 4 models

SOURCE: 04_CRI_MAIN_ANALYSES.RMD
Listing of variables used in construction of factor scores begins in line 262
*/





use /volumes/ddisk/mi/researcher/cri.dta, clear;


generate teamid=u_teamid;
destring teamid, force replace;
unique teamid;

rename BELIEF_HYPOTHESIS belief_hypothesis;
rename TOPIC_KNOWLEDGE topic_knowledge;
rename STATISTICS_SKILL statistics_skill;
rename MODEL_SCORE model_score;
rename AME ame;
rename DV dv;
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
rename Hresult hresult;
rename Hsupport hsupport;
rename Hreject hreject;
rename Hrej hrej;
rename Hsup hsup;
rename Hnotest hnotest;
rename Hmixed hmixed;



*DROPS TEAMS WITH MISSING ID;
drop if teamid==.;

*DROPS THE BASELINE BRADY-FINNIGAN RESULTS;
drop if teamid==0;
unique teamid;


*SIMPLIFY DATA SET BY DROPPING IRRELEVANT VARIABLES;
*drop AU-VE;
*drop emigration_ivC-fbXleftright;





*AVERAGE MARGINAL EFFECT VARIABLE;
*START WITH 1253 MODELS WITH NON-MISSING AME;
destring ame, replace force;
drop if ame==.;
summ ame;



*TEAM 1 DOES NOT REPORT AN AME, SO WILL BE DELETED;
list teamid if ame==.;
drop if teamid==1;
unique teamid;






*NUMBER OF MODELS PER TEAM;
egen nmodel=count(ame), by(teamid);
tabulate nmodel;






*TEAM SIZE;
tabulate team_size;
generate t2=(team_size==1);
generate t3=(team_size==3);
unique teamid if team_size==1;
unique teamid if team_size==2;
unique teamid if team_size==3;






*PERCENT MEN IN TEAM;
destring v_1101, force gen(v1101);
destring v_1102, force gen(v1102);
destring v_1103, force gen(v1103);
tabulate v1101, missing;
tabulate v1102, missing;
tabulate v1103, missing;

*TEAM 27 IS MISSING GENDER;
list team_size backgr_degree1 backgr_degree2 backgr_degree3 if teamid==27;
list v1101 v1102 v1103 if teamid==27;

*WILL USE HOT DECK IMPUTATION TO FILL IN THE GENDER OF THAT OBSERVATION;
*TEAM 27 IS A ONE PERSON TEAM WITH A DEGREE IN FIELD 4;
*TEAM LEVEL DATA SHOWS THAT 3 OTHER TEAMS (83, 87, 96) WITH SAME CHARACTERISTICS;
*THOSE 3 TEAMS ARE 2 MEN AND ONE WOMEN;
*WILL ASSIGN PMALE = .67 FOR TEAM 27;

generate nmale=(v1101==1) + (v1102==1) + (v1103==1);
generate team=(v1101~=.) + (v1102~=.) + (v1103~=.);
generate pmale=nmale/team;
replace pmale=.6666667 if teamid==27;
tabulate pmale;







*T-STATISTIC OF ESTIMATED AME AND IMPLIED STANDARD ERROR AT MODEL LEVEL;
destring z, force replace;
generate oldz=z;
replace z=abs(z);
gen std=abs(ame/z);
summ ame z;







*FIELD OF HIGHEST DEGREE OF TEAM;
tabulate backgr_degree1;

destring backgr_degree1, force gen(degree1);
destring backgr_degree2, force gen(degree2);
destring backgr_degree3, force gen(degree3);
tabulate backgr_degree1 degree1;
summ degree1 degree2 degree3;



generate d1=degree1;
generate d2=degree2;
generate d3=degree3;

replace d1=0 if d1==.;
replace d2=0 if d2==.;
replace d3=0 if d3==.;

generate counter=d1*100 + d2*10 + d3;
generate counter2=team_size*1000 + counter;
summ d1-d3 counter counter2;

tabulate counter2;


*SIZE OF TEAM THAT PROVIDES A DEGREE, NOT EQUAL TO TEAM_SIZE BECAUSE OF MISSING INFO;
replace team=(degree1~=.) + (degree2~=.) + (degree3~=.);


*THESE ARE THE EXCLUSIVE DISCIPLINES;
generate mdegree=1 if counter2==1100;
replace mdegree=2 if counter2==1200;
replace mdegree=3 if counter2==1300 | counter2==2303 | counter2==3333;
replace mdegree=4 if counter2==1400 | counter2==2400 | counter2==2404 | counter2==3444;
replace mdegree=5 if counter2==1500 | counter2==2505 | counter2==3555;
replace mdegree=6 if counter2==1600 | counter2==2606;

*ALL MIXED DEGREES FOR ACTUAL TEAM SIZE 2;
replace mdegree=20 if (team==2 & mdegree==.) | counter2==2654 ;
tabulate counter2 if mdegree==20;




*NOW BREAK UP TEAM SIZE 3 INTO 4 CATEGORIES;

tabulate counter2 if mdegree==30;
replace mdegree=31 if (counter2==3323 | counter2==3336
	| counter2==3343);
replace mdegree=32 if (counter2==3244 
	| counter2==3414 | counter2==3443);
*THE FOLLOWING 2 CATEGORIES USE DIFFERENT LEAD AUTHOR IN SOCIO OR POLI SCI TO CLASSIFY;
replace mdegree=33 if (counter2==3344 );
replace mdegree=34 if ( counter2==3433);
tabulate counter2 if team==3 & mdegree==.;
tabulate counter2 if team_size==3 & mdegree==.;
replace mdegree=30 if team_size==3 & mdegree==.;

tabulate counter2 if mdegree==30, missing;
tabulate counter2, sum(mdegree);















*PRO-IMMIGRATION INDEX USES THE VARIABLE MEASURING THE GENERAL ATTITUDE TOWARDS IMMIGRATION, ATTITUDE_IMMIGRATION_11;
*A VARIABLE COLLECTED IN THE FIRST WAVE QUESTIONNAIRE;
*THE VARIABLE pro_immigrant in lower case IS THE MEAN OF THE INDEX WITHIN A TEAM;
*THE PRO_IMMIGRANT VARIABLE IN UPPER CASE ONLY HAS 3 VALUES AS COMPARED TO MORE THAN 6 FOR THE pro_immigrant VARIABLE;
*HIGHER VALUES OF PRO_IMMIGRANT INDICATE THAT IMMIGRATION LAWS SHOULD BE RELAXED, MORE IMMIGRATION;
*NOTE THAT ATTITUDE_IMMIGRATION_11 IS IN REVERSE ORDER;
tabulate pro_immigrant attitude_immigration_11 if team_size==1;
rename PRO_IMMIGRANT pro;
generate proindex=pro_immigrant;
destring proindex, force replace;
tabulate proindex pro, missing;





*CREATING PINDEX, PERCENT OF TEAM WITH PRO-IMMIGRATION IDEOLOGY;
*SIMPLY COUNT NUMBER OF AUTHORS WITH CORRECT CODE IN ATTITUDE VARIABLE, AND DIVIDE BY TEAM SIZE;
destring attitude_immigration_11, force gen(att1);
destring attitude_immigration_12, force gen(att2);
destring attitude_immigration_13, force gen(att3);


*REVERSE ORDER OF THE ATTITUDE IMMIGRATION VARIABLES TO MAKE THEM CONSISTENT WITH PROINDEX;
replace att1=7-att1;
replace att2=7-att2;
replace att3=7-att3;


*NOT ALL MEMBERS IN TEAM RESPONDED TO THE ATTITUDE_IMMIGRATION VARIABLES;
*WILL USE ACTUAL NUMBER WHO RESPONDED TO DEFINE INDEX BELOW;
replace team=(att1~=.) + (att2~=.) + (att3~=.);
generate npro=(att1>4 & att1~=.) + (att2>4 & att2~=.) + (att3>4 & att3~=.);
tabulate npro;
generate pindex=(npro/team);

*DINDEX IS THE VARIABLE THAT MEASURES IF AT LEAST HALF OF THE TEAM IS PRO-IMMIGRANT;
generate dindex=(pindex>=.5);
summ npro pindex dindex;

generate npro1=(att1==1) + (att2==1) + (att3==1);
generate npro2=(att1==2) + (att2==2) + (att3==2);
generate npro3=(att1==3) + (att2==3) + (att3==3);
generate npro4=(att1==4) + (att2==4) + (att3==4);
generate npro5=(att1==5) + (att2==5) + (att3==5);
generate npro6=(att1==6) + (att2==6) + (att3==6);


*THE Px VARIABLES GIVE % OF TEAM THAT IS IN EACH OF THE CODES;
generate p1=npro1/team;
generate p2=npro2/team;
generate p3=npro3/team;
generate p4=npro4/team;
generate p5=npro5/team;
generate p6=npro6/team;


*P12 P34 P56 GIVE % OF TEAM THAT IS 1,2 OR 3,4, OR 5,6;
generate p12=p1+p2;
generate p34=p3+p4;
generate p56=p5+p6;



*NOW DEFINING THE THREE TYPES OF TEAMS USED IN PAPER;


*GROUP 1, AT LEAST 1 PERSON IN TEAM IS ANTI-IMMIGRATION;
*GROUP 3, MORE THAN HALF OF TEAM IS PRO-IMMIGRATION, SAME AS DINDEX VARIABLE;
*GROUP 2, THE MODERATE MIDDLE;

*BUT THERE IS AN OVERLAP OF 2 TEAMS BETWEEN GROUPS 1 AND 3, BOTH TEAMS HAVE 3 PERSONS;
*IN THESE TEAMS, 1 PERSON IS A 2 BUT BOTH OF THE OTHER PEOPLE ARE 5 OR 6;
*WILL CLASSIFY THEM AS PRO-IMMIGRATION GROUP SINCE MAJORITY IS PRO-IMMIGRATION;

generate group1=(p12>0);
generate group3=(pindex>=.5);
tabulate group3 dindex;


tabulate group1 group3;
list teamid att1 att2 att3 if group1==1 & group3==1;
unique teamid if group1==10 & group3==1;
replace group1=0 if group1==1 & group3==1;
replace group1=1 if group1==1 & group3==1;

generate group2=(group1==0 & group3==0);
generate index=1*group1 +2*group2 + 3*group3;

tabulate index;









*TOPIC KNOWLEDGE;
tabulate topic_knowledge, missing;

*MISSING DATA FOR THIS VARIABLE AND IT ALL BELONGS TO TEAM 27;
*MOREOVER TOPIC_KNOWLEDGE FOR TEAM 27 IN TEAM LEVEL DATA IS ALSO MISSING;
*WILL USE A HOT DECK PROCEDURE TO IMPUTE BASED ON MDEGREE, TEAM SIZE, AND PMALE;
tabulate teamid if topic_knowledge=="NA";

summ mdegree  if teamid==27;
tabulate topic_knowledge if mdegree==40 & team_size==1 & pmale==0;
tabulate topic_ipred if mdegree==40 & team_size==1 & pmale==0;
replace topic_knowledge="Low" if teamid==27;
replace topic_ipred="-0.253722245526001" if teamid==27;

tabulate topic_knowledge, missing;



*TOPIC_CAT CONVERTS TOPIC_KNOWLEDGE INTO NUMERIC, NOTE CODE 4 IS NA;
generate topic_cat=1*(topic_knowledge=="Low") + 2*(topic_knowledge=="Mid") 
	+ 3*(topic_knowledge=="High");


*TOPIC VARIABLE IN BRW COMES FROM A FACTOR ANALYSIS PREDICTION;
destring topic_ipred, force gen(topic_brw);
tabulate topic_brw topic_knowledge, missing;
summ topic_brw;












*STATS INFO IS MISSING FOR TEAM 27, BUT TEAM 27 DATA IS NOT AVAILABLE IN TEAM DATA;
*WILL USE HOT DECK PROCEDURE;
tabulate statistics_skill if mdegree==40 & team_size==1 & pmale==0;
tabulate stats_ipred if mdegree==40 & team_size==1 & pmale==0;
replace statistics_skill="Mid" if teamid==27;
replace stats_ipred="0.102538885683808" if teamid==27;

generate stats_cat=1*(statistics_skill=="Low") + 2*(statistics_skill=="Mid") 
	+ 3*(statistics_skill=="High");

*STATISTICS VARIABLE IN BRW COMES FROM A FACTOR ANALYSIS PREDICTION;
destring stats_ipred, force gen(stats_brw);
tabulate teamid if stats_brw==.;
replace stats_brw=0.649019158901927 if teamid==8;

tabulate statistics_skill, sum(stats_brw);







*REFEREE DATA;
*MODEL SCORE AND DUMMY VARIABLE INDICATING HIGH QUALITY RESEARCH;
tabulate model_score, missing;
generate model_cat=1*(model_score=="Low") + 2*(model_score=="Mid") 
	+ 3*(model_score=="High");
	

*MODEL SCORE VARIABLE IN BRW COMES FROM A FACTOR ANALYSIS PREDICTION;
generate model_brw=total_score;
destring model_brw, force replace;
summ model_brw model_cat;

*GENERATE HIGH QUALITY RESEARCH VARIABLE;
*NOTE THAT QUALITY THRESHOLD IS DEFINED IN BRW STUDY;
generate quality=(model_cat==3);

*NOTE THAT SINGLE AUTHORS DO NOT PRODUCE VALUABLE RESEARCH;
tabulate model_score team_size;









*MERGING IN ALTERNATIVE REFEREE SCORE;
sort id;
merge id using /volumes/ddisk/mi/researcher/cri_new_peer_scores.dta;
drop _merge;
drop if ame==.;

tabulate peer_mean;
summ peer_mean, detail;

generate quality2=(peer_mean>4.5);
replace quality2=. if peer_mean==.;


*IMPUTING MISSING VALUES OF PEER_MEAN USING MODEL_SCORE AND SPECIFICATION CHARATERISTICS;
global design jobs-health logit ols stock flow changeflow w1985-w2016 orig13 eeurope allavailable 
	twowayfe level_cyear mlm_fe mlm_re anynonlin;
	
summ peer_mean model_score;
generate pscore=peer_mean;
regress peer_mean model_brw $design;
predict phat;
replace pscore=phat if peer_mean==.;

summ pscore peer_mean model_brw;
corr pscore model_brw;













*BELIEF HYPOTHESIS HAS USUAL PROBLEM WITH MISSING DATA FOR TEAM 27;
*WILL AGAIN USE HOT DECK PROCEDURE;
tabulate belief_hypothesis if teamid==27;
tabulate belief_ipred if teamid==27;

tabulate belief_hypothesis if mdegree==40 & team_size==1 & pmale==0;
replace belief_hypothesis="Low" if teamid==27;
replace belief_ipred="-1.13508799270782" if teamid==27;

tabulate belief_hypothesis, missing;

generate belief_cat=1*(belief_hypothesis=="Low") + 2*(belief_hypothesis=="Mid") 
	+ 3*(belief_hypothesis=="High");
tabulate belief_hypothesis belief_cat, missing;


destring belief_ipred, force replace;
generate belief_brw=belief_ipred;
summ belief_brw belief_cat;





*THERE IS PROBABLY A MISCODING OF WHAT "HIGH BELIEF" MEANS IN DATA SET;
*SEE DISTRIBUTION.DO PROGRAM;
*ALSO APPENDIX SAYS THERE ARE 161 RESEARCHERS IN 73 TEAMS, P. 5;
*USING TEAM LEVEL DATA AND RESHAPING IT LEADS TO 159 PARTICIPANTS;
*DOING TABULATION OF THE BELIEF_H1_Hx VARIABLES LEADS TO DISTRIBUTION OF BELIEF;
*SIMILAR TO THAT IN APPENDIX QUESTIONNAIRE, P. 84, WHERE 1 MEANS BELIEF IMM STRONGLY REDUCES SOCIAL POLICY SUPPORT;


*ALTERNATIVE MEASURE OF BELIEF HYPOTHESIS USING INDIVIDUAL TEAM MEMBER BELIEFS;
*SEE 002_CRI_DATA_PREP.RMD, LINE 356;
*SUGGESTS CODING CHANGED FROM QUESTIONNAIRE AND HIGHER VALUES OF BELIEF_H1_11 SHOULD INDICATE MORE BELIEF IN HYPOTHESIS;
*BUT DISTRIBUTION OF VARIABLE COMPARED TO APPENDIX SUGGESTS THAT 1 IS STRONGLY REDUCES, AND 4 IS SOMEWHAT INCREASES;
*NOTE HIGH VALUE OF BELIEF_1_AVG MEANS *WEAKER* BELIEF IN HYPOTHESIS IMMIGRATION REDUCES SOCIAL SUPPORT;
*NOTE THAT BELIEF_1_AVG AND BELIEF_H1_11 ARE THE SAME FOR SINGLE PERSON TEAMS;
tabulate belief_1_avg belief_hypothesis;
tabulate belief_1_avg;
tabulate belief_1_avg belief_h1_11 if team_size==1;



destring belief_h1_11, force replace;
destring belief_h1_12, force replace;
destring belief_h1_13, force replace;
tabulate belief_h1_11, missing;
tabulate belief_h1_12, missing;
tabulate belief_h1_13, missing;


*NBELIEF IS NUMBER IN TEAM THAT BELIEVES HYPOTHESIS IMMIGRATION REDUCES SUPPORT;
*DBELIEF EQUALS 1 IF MORE THAN HALF THE TEAM BELIEVES IMMIGRATION REDUCES SUPPORT;
*IF IMMIGRATION REDUCES SUPPORT IT WOULD MEAN THAT THE AME IS NEGATIVE;
*USE CORRECT MEASURE OF TEAM SIZE TO DEFINE PBELIEF;
*THE ORIGINAL BELIEF INDICES ONLY HAVE 4 POTENTIAL VALUES SO CANNOT DIFFERENTIATE LOWER AND UPPER ENDS;
generate nbelief=(belief_h1_11<=2 & belief_h1_11~=.) 
	+ (belief_h1_12<=2 & belief_h1_12~=.) + (belief_h1_13<=2 & belief_h1_13~=.);
replace team=(belief_h1_11~=.) + (belief_h1_12~=.) + (belief_h1_13~=.);
*generate nbelief=(belief_h1_11<2) + (belief_h1_12<2) + (belief_h1_13<2);
generate pbelief=nbelief/team;
tabulate pbelief;









*******************************************;




*TYPE OF DEPENDENT VARIABLE USED;

encode dv, generate(dep);
tabulate dv, sum(dep);
tabulate scale;
tabulate dv scale;

 








***************************************************************************;

*ALL REGRESSIONS WILL BE WEIGHTED BY 1/NMODEL SO THEY ARE NUMERICALLY EQUIVALENT TO TEAM LEVEL REGRESSIONS;
*WILL LEAVE OUT PMALE FROM ALL REGRESSIONS;
*WILL INCLUDE TEAM_SIZE IN THE REFEREE SCORE, QUALITY REGRESSIONS;

reg ame  proindex    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
reg ame  dindex    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
reg ame  group1 group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);




*ADDING BELIEF;
reg ame  proindex  pbelief  stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
reg ame  dindex  pbelief  stats_brw topic_brw t2 t3 i.mdegree    [aw=1/nmodel] ,  cluster(teamid);
reg ame  group1 group3  pbelief  stats_brw topic_brw t2 t3 i.mdegree    [aw=1/nmodel] ,  cluster(teamid);








***************************************************************************;


*WEIGHTED REGRESSIONS USING PSCORE/NMODEL;
*WEIGHTING BY QUALITY HELPS ADDRESS PUBLICATION BIAS PROBLEM;
reg ame  proindex    stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);
reg ame  dindex    stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);
reg ame  group1 group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);






*ADDING BELIEF;
reg ame  proindex  pbelief  stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);
reg ame  dindex  pbelief  stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);
reg ame  group1 group3  pbelief  stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);











********************************************************************;

*GETTING EFFECTS ON ESTIMATE BY LOOKING AT EXTREME SIGNIFICANT COEFFICIENTS, USING 10TH AND 90TH PERCENTILES;


generate negsig=(ame<0 & z>1.645);
generate possig=(ame>0 & z>1.645);

summ ame;
generate pos10=(ame>.052);
generate neg10=(ame<-.071);
generate pos10s=(ame>.052 & z>1.645);
generate neg10s=(ame<-.071 & z>1.645);

summ pos10-neg10s;
summ pos10-neg10s [aw=model_brw];





*OLS REGRESSIONS ON EXTREME OUTCOMES;

reg neg10 proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg neg10 dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg neg10 group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg neg10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg neg10s dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg neg10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);




*REGRESSIONS ON OUTLYING POSITIVE & SIGNIFICANT COEFFICIENTS;
reg pos10 proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg pos10 dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg pos10 group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg pos10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg pos10s dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
reg pos10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);




*WEIGHTED REGRESSIONS ON OUTLYING NEGATIVE & SIGNIFICANT COEFFICIENTS;
reg neg10 proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
reg neg10 dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
reg neg10 group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
reg neg10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
reg neg10s dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
reg neg10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);




*WEIGHTED REGRESSIONS ON OUTLYING POSITIVE & SIGNIFICANT COEFFICIENTS;
reg pos10 proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
reg pos10 dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
reg pos10 group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
reg pos10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
reg pos10s dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
reg pos10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);

	





*LOGIT REGRESSIONS ON OUTLYING NEGATIVE & SIGNIFICANT COEFFICIENTS;
quietly logit neg10 proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
quietly logit neg10 dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(dindex-topic_brw);
quietly logit neg10 group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
quietly logit neg10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
quietly logit neg10s dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(dindex-topic_brw);
quietly logit neg10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);




*LOGIT REGRESSIONS ON OUTLYING POSITIVE & SIGNIFICANT COEFFICIENTS;
quietly logit pos10 proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
quietly logit pos10 dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(dindex-topic_brw);
quietly logit pos10 group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
quietly logit pos10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
quietly logit pos10s dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(dindex-topic_brw);
quietly logit pos10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);




*LOGIT WEIGHTED REGRESSIONS ON OUTLYING NEGATIVE & SIGNIFICANT COEFFICIENTS;
quietly logit neg10 proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
quietly logit neg10 dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(dindex-topic_brw);
quietly logit neg10 group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
quietly logit neg10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
quietly logit neg10s dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(dindex-topic_brw);
quietly logit neg10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);




*LOGIT WEIGHTED REGRESSIONS ON OUTLYING POSITIVE & SIGNIFICANT COEFFICIENTS;
quietly logit pos10 proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
quietly logit pos10 dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(dindex-topic_brw);
quietly logit pos10 group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
quietly logit pos10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
quietly logit pos10s dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(dindex-topic_brw);
quietly logit pos10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);



























********************************************************************;

*RELATIONSHIP BETWEEN QUALITY OF RESEARCH AND PRO-IMMIGRATION INDEX

*NOTE HUGE RELATIONSHIP BETWEEN TEAM SIZE AND QUALITY, NO HIGH-QUALITY RESEARCH WHEN ONLY SINGLE AUTHOR;
tabulate team_size model_cat;

*PERHAPS USE XDEGREE TO CONTROL FOR DEGREE;
generate xdegree=mdegree if mdegree==20;
replace xdegree=mdegree if mdegree==30;
replace xdegree=mdegree if mdegree==40;
replace xdegree=mdegree if mdegree==50;
replace xdegree=0 if xdegree==.;


generate lowquality=(belief_hypothesis=="Low");





*FACTOR SCORE AS DEPENDENT VARIABLE;
reg model_brw proindex     stats_brw topic_brw t2 t3 i.mdegree  [aw=1/nmodel] ,  cluster(teamid);
reg model_brw dindex     stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
reg model_brw group1 group3     stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);







*QUALITY MODELS LOSE A LOT OF SINGLETON OBSERVATIONS IF WE USE LOGIT;
*SO WILL DO LINEAR PROBABILITY MODEL INSTEAD;


*OLS MODELS ON HIGH QUALITY;
reg quality proindex     stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] , cluster(teamid);
reg quality dindex     stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] , cluster(teamid);
reg quality group1 group3     stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] , cluster(teamid);





*LOGIT MODELS ON HIGH QUALITY;
quietly logit quality proindex     stats_brw topic_brw t2 t3 i.mdegree   [iw=1/nmodel] ,  cluster(teamid);
display e(r2_p);
margins, dydx(proindex-t3);
quietly logit quality dindex     stats_brw topic_brw t2 t3 i.mdegree   [iw=1/nmodel] ,  cluster(teamid);
display e(r2_p);
margins, dydx(dindex-t3);
quietly logit quality group1 group3     stats_brw topic_brw t2 t3 i.mdegree   [iw=1/nmodel] ,  cluster(teamid);
display e(r2_p);
margins, dydx(group1-t3);











********************************************************************;










*RELATIONSHIP BETWEEN NEW MEASURE OF QUALITY OF RESEARCH AND PRO-IMMIGRATION INDEX;
*NOTE THESE REGRESSIONS LOSE A FEW OBSERVATIONS BECAUSE PEER_MEAN IS NOT AVAILABLE FOR 38 OBSERVATIONS;




summ quality quality2;


*NOTE HUGE RELATIONSHIP BETWEEN TEAM SIZE AND QUALITY, NO HIGH-QUALITY RESEARCH WHEN ONLY SINGLE AUTHOR;
tabulate team_size quality;
tabulate team_size quality2;





*WEIGHT ALSO BY PEER_N, NUMBER OF REVIEWERS THAT MODEL HAD;


*NEW REFEREE SCORE MEASURE AS DEPENDENT VARIABLE;
reg peer_mean proindex     stats_brw topic_brw t2 t3 i.mdegree  [aw=peer_n/nmodel] ,  cluster(teamid);
reg peer_mean dindex     stats_brw topic_brw t2 t3 i.mdegree   [aw=peer_n/nmodel] ,  cluster(teamid);
reg peer_mean group1 group3     stats_brw topic_brw t2 t3 i.mdegree   [aw=peer_n/nmodel] ,  cluster(teamid);







*QUALITY MODELS LOSE A LOT OF SINGLETON OBSERVATIONS IF WE USE LOGIT;
*SO WILL DO LINEAR PROBABILITY MODEL INSTEAD;


*OLS MODELS ON HIGH quality2;
reg quality2 proindex     stats_brw topic_brw t2 t3 i.mdegree   [aw=peer_n/nmodel] , cluster(teamid);
reg quality2 dindex     stats_brw topic_brw t2 t3 i.mdegree   [aw=peer_n/nmodel] , cluster(teamid);
reg quality2 group1 group3     stats_brw topic_brw t2 t3 i.mdegree   [aw=peer_n/nmodel] , cluster(teamid);





*LOGIT MODELS ON HIGH quality2;
quietly logit quality2 proindex     stats_brw topic_brw t2 t3 i.mdegree   [iw=peer_n/nmodel] ,  cluster(teamid);
display e(r2_p); 
margins, dydx(proindex-t3);
quietly logit quality2 dindex     stats_brw topic_brw t2 t3 i.mdegree   [iw=peer_n/nmodel] ,  cluster(teamid);
display e(r2_p); 
margins, dydx(dindex-t3);
quietly logit quality2 group1 group3     stats_brw topic_brw t2 t3 i.mdegree   [iw=peer_n/nmodel] ,  cluster(teamid);
display e(r2_p); 
margins, dydx(group1-t3);










********************************************************************;



*SAVE MODEL LEVEL DATA FOR GRAPHS;

save /volumes/ddisk/mi/researcher/model.dta, replace;





*********************************************************************;





*DESCRIPTIVE TABLE AT THE MODEL LEVEL;

tabulate topic_knowledge, sum(topic_brw);
tabulate statistics_skill, sum(stats_brw);
tabulate model_score, sum(model_brw);

generate highstats=(statistics_skill=="High");
generate hightopic=(topic_knowledge=="High");
generate highmodel=(model_score=="High");


summ dindex group1 group2 group3;
tabulate dindex group3;

summ ame neg10s pos10s proindex dindex p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel ;
summ ame neg10s pos10s proindex dindex p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel if index==1 ;
summ ame neg10s pos10s proindex dindex p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel if index==2;
summ ame neg10s pos10s proindex dindex p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel if index==3;


*SUMMARY STATS WEIGHTED BY THE INVERSE OF THE NUMBER OF MODELS;
summ ame neg10s pos10s proindex dindex p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel  [aw=1/nmodel];
summ ame neg10s pos10s proindex dindex p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel if index==1  [aw=1/nmodel];
summ ame neg10s pos10s proindex dindex p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel if index==2 [aw=1/nmodel];
summ ame neg10s pos10s proindex dindex p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel if index==3 [aw=1/nmodel];




**************************************************************'

*DESCRIPTIVE TABLE AT THE TEAM LEVEL BY COLLAPSING FROM THE MODEL LEVEL DATA;

*THERE SEEMS TO BE AN INCONSISTENCY WITH THE TOPIC_KNOWLEDGE VARIABLE IN THE TEAM LEVEL DATA;
*VERY FEW TEAMS ARE CLASSIFIED AS "HIGH" AS COMPARED TO THE MODEL LEVEL DATA;
*SIMPLEST WAY TO SHOW IT IS TO DO A TABULATE MODEL_BRW TOPIC_KNOWLEDGE IN BOTH DATA SETS;


collapse (mean) ame proindex dindex group1 group2 group3 p12 p34 p56 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel index, by(teamid);



summ ame proindex dindex p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size 
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel ;
summ ame proindex dindex p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size 
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel if index==1;
summ ame proindex dindex p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel if index==2 ;
summ ame proindex dindex p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean quality quality2 hrej highstats-highmodel if index==3;










log close;


