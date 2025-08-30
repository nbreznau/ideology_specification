#delimit ;

* PACKAGES;
*ssc install unique;
*ssc install center;

* DEFINE WORKING DIRECTORY;
global workd "/GitHub/ideology_specification";
log using "$workd/code/Log Files/01_Data_Prep.log", replace;
clear matrix;
clear mata;

* SAVE NEW REFEREE SCORES AS .dta;
import delimited "$workd/data/cri_new_peer_scores.csv", clear varnames(1);
gen str100 id100 = substr(id, 1, 100);
drop id;
gen id = id100;
drop id100;
destring peer_mean, replace force;
destring peer_n, replace force;
sort id;
save "$workd/data/cri_new_peer_scores.dta", replace;


import delimited "$workd/data/cri.csv", clear bindquote(strict) varnames(1) maxquotedrows(1000);

generate teamid=u_teamid;
destring teamid, force replace;
unique teamid;


*DROPS TEAMS WITH MISSING ID;
drop if teamid==.;

*DROPS THE BASELINE BRADY-FINNIGAN RESULTS;
drop if teamid==0;
unique teamid;


*SIMPLIFY DATA SET BY DROPPING IRRELEVANT VARIABLES;
drop au-ve;
drop emigration_ivc-fbxleftright;


*AVERAGE MARGINAL EFFECT VARIABLE;
*START WITH 1253 MODELS WITH NON-MISSING AME;
destring ame, replace force;
drop if ame==.;
summ ame;

*PRO-IMMIGRANT BACKUP VAR
generate proi = pro_immigrant;

*TEAM 1 DOES NOT REPORT AN AME, SO WILL BE DELETED;
list teamid if ame==.;
drop if teamid==1;
unique teamid;


*NUMBER OF MODELS PER TEAM;
egen nmodel=count(ame), by(teamid);
tabulate nmodel;


*TEAM SIZE;
*TEAMS 93 AND 94 HAVE TEAM SIZE MISCODED;
replace team_size=3 if teamid==93;
replace team_size=1 if teamid==94;
tabulate team_size;

generate t2=(team_size==2);
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



generate mdegree=degree1;
replace mdegree=0 if counter2==3005;
replace mdegree=20 if counter2==2204 | counter2==2306 | counter2==2504 | counter2==2703;
replace mdegree=33 if counter2==3323 | counter2==3336 | counter2==3343;
replace mdegree=34 if counter2==3414 | counter2==3443;
replace mdegree=35 if counter2==3433;
replace mdegree=36 if counter2==3344;
replace mdegree=40 if counter2==3244 | counter2==3654;

tabulate counter2, sum(mdegree);



*PRO-IMMIGRATION INDEX USES THE VARIABLE MEASURING THE GENERAL ATTITUDE TOWARDS IMMIGRATION, ATTITUDE_IMMIGRATION_11;
*A VARIABLE COLLECTED IN THE FIRST WAVE QUESTIONNAIRE;
*THE VARIABLE pro_immigrant in lower case IS THE MEAN OF THE INDEX WITHIN A TEAM;
*THE PRO_IMMIGRANT VARIABLE IN UPPER CASE ONLY HAS 3 VALUES AS COMPARED TO MORE THAN 6 FOR THE pro_immigrant VARIABLE;
*HIGHER VALUES OF PRO_IMMIGRANT INDICATE THAT IMMIGRATION LAWS SHOULD BE RELAXED, MORE IMMIGRATION;
*NOTE THAT ATTITUDE_IMMIGRATION_11 IS IN REVERSE ORDER;
tabulate pro_immigrant attitude_immigration_11 if team_size==1;


generate proindex=pro_immigrant;
destring proindex, force replace;
tabulate proindex proi, missing;


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

*NUMBER IN TEAM WHO RESPONDED WITH EACH PARTICULAR INDEX VALUE;
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
*GROUP 3, MORE THAN HALF OF TEAM IS PRO-IMMIGRATION;
*GROUP 2, THE MODERATE MIDDLE;

*BUT THERE IS AN OVERLAP OF 2 TEAMS, #61 and #64, BETWEEN GROUPS 1 AND 3, BOTH TEAMS HAVE 3 PERSONS;
*IN THESE TEAMS, 1 PERSON IS A 2 BUT BOTH OF THE OTHER PEOPLE ARE 5 OR 6;
*WILL CLASSIFY THEM AS PRO-IMMIGRATION GROUP SINCE MORE THAN HALF ARE PRO-IMMIGRATION;

generate group1=(p12>0);
generate group3=(p56>.5);
tabulate teamid if group1==1 & group3==1;
replace group1=0 if group3==1;
generate group2=1-group1-group3;


generate index=1*group1 +2*group2 + 3*group3;

unique teamid if group1==1;
unique teamid if group2==1;
unique teamid if group3==1;

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

gen str100 id100 = substr(id, 1, 100);
drop id;
gen id = id100;
drop id100;
sort id;
merge id using "$workd/data/cri_new_peer_scores.dta";
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



center peer_mean, standardize;
rename c_peer_mean zpeer_mean;


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


*THERE IS A MISCODING OF WHAT "HIGH BELIEF" MEANS IN DATA SET;
*USING TEAM LEVEL DATA AND RESHAPING IT LEADS TO 159 PARTICIPANTS;
*DOING TABULATION OF THE BELIEF_H1_Hx VARIABLES LEADS TO DISTRIBUTION OF BELIEF;
*SIMILAR TO THAT IN APPENDIX QUESTIONNAIRE, P. 84, WHERE 1 MEANS BELIEF IMM STRONGLY REDUCES SOCIAL POLICY SUPPORT;


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


generate nbelief=(belief_h1_11<=2 & belief_h1_11~=.) 
	+ (belief_h1_12<=2 & belief_h1_12~=.) + (belief_h1_13<=2 & belief_h1_13~=.);
replace team=(belief_h1_11~=.) + (belief_h1_12~=.) + (belief_h1_13~=.);
generate pbelief=nbelief/team;
tabulate pbelief;


destring belief_ipred, force replace;



*******************************************;




*TYPE OF DEPENDENT VARIABLE USED;

encode dv, generate(dep);
tabulate dv, sum(dep);
tabulate scale;
tabulate dv scale;



*************************************************;

*STANDARDIZING THE STATISTICS AND TOPIC VARIABLES;
*NOTE CENTERING IS WEIGHTED BY INVERSE OF NUMBER OF MODELS;
generate stats_brw_orig=stats_brw;
generate topic_brw_orig=topic_brw;

center stats_brw topic_brw, standardize;
drop stats_brw topic_brw;
rename c_stats_brw stats_brw;
rename c_topic_brw topic_brw;
summ stats_brw topic_brw;



/*
*STANDARDIZING THE PROINDEX VARIABLE;
*HOWEVER, REGRESSIONS WILL USE THE ACTUAL INDEX ON THE 1-6 SCALE;
center proindex, standardize;
summ proindex c_proindex;
*/

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


generate hmodel=(model_score=="High");

* Generate most 'senior' scholar's immigration ideology per team;
* This takes the most statistically experienced member as the 'senior';

preserve;
import delimited "$workd/data/sem_p.csv", clear varnames(1);
* in order to make sure teams are accounted for in stats;
gen stats_m = stats;
replace stats_m = 0 if stats == .;
egen maxstats=max(stats), by(u_teamid);
generate good=.;
replace good=1 if maxstats==stats;
tabulate good;
keep if good==1;
keep u_teamid pro_immigrant ;
rename pro_immigrant oldimm;
sort u_teamid;
save "$workd/data/sem_p_merge.dta", replace;
restore;

sort u_teamid;
merge u_teamid using "$workd/data/sem_p_merge.dta";

*SAVE MODEL LEVEL DATA;

save "$workd/data/df.dta", replace;


log close;


