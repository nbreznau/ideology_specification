#delimit ;
log using /volumes/ddisk/mi/researcher/reg_reject.log, replace;
clear matrix;
clear mata;

*THE DATA IN CRI.CSV IS MODEL-LEVEL DATA;
*THE DATA IN CRI_TEAM.CSV IS TEAM-LEVEL DATA;
*TEAM LEVEL DATA CONTAINS MORE THAN ONE OBSERVATION PER TEAM FOR A FEW TEAMS, DUE TO STOCK-FLOW DISTINCTION;

**************************************************;
*THIS PROGRAM USES DATA AT TEAM-CONCLUSION LEVEL;
*THE VARIABLE HREJECT IS CONSTANT WITHIN A TEAM;
*THE VARIABLE HREJ IS NOT CONSTANT WITHIN A TEAM, AND DIFFERS FOR THE 16 TEAMS WITH DIFFERENT CONCLUSIONS;
**************************************************;


*GETTING VARIANCE OF THE AME WITHIN A TEAM;
*TEAM-CONCLUSION LEVEL DATA;

use /volumes/ddisk/mi/researcher/cri.dta, clear;

generate teamid=u_teamid;
destring teamid, force replace;

*DROPS TEAMS WITH MISSING ID;
drop if teamid==.;

*DROPS THE BASELINE BRADY-FINNIGAN RESULTS;
drop if teamid==0;

rename AME ame;
rename Hrej hrej;

destring ame, force replace;
destring z, force replace;

replace z=abs(z);
generate varame=(ame/z)^2;
generate negsig=(ame<0 & z>1.645);
generate possig=(ame>0 & z>1.645);
*generate negsig=(ame<0 & z>1.96);
*generate possig=(ame>0 & z>1.96);
generate nmodel=1;

*THE TEAM-CONCLUSION LEVEL DATA IS DEFINED BY TEAMID AND HREJ;
collapse (sum) nmodel negsig possig (mean) meaname=ame varame meanz=z (sd) sdame=ame, by(teamid hrej);
generate rpos=possig/nmodel;
generate rneg=negsig/nmodel;

summ;

save /volumes/ddisk/data/junkvar.dta, replace;






*GETTING AVERAGE REFEREE SCORE FOR EACH TEAM-CONCLUSION COMBINATION;
use /volumes/ddisk/mi/researcher/model.dta, replace;

collapse (mean) pscore, by(teamid hrej);

save /volumes/ddisk/data/junkpscore.dta, replace;







*GET TEAM-CONCLUSION LEVEL DATA;

use /volumes/ddisk/mi/researcher/cri_team.dta, clear;


generate teamid=u_teamid;
destring teamid, force replace;

*DROPS TEAMS WITH MISSING ID;
drop if teamid==.;

*DROPS THE BASELINE BRADY-FINNIGAN RESULTS;
drop if teamid==0;


rename BELIEF_HYPOTHESIS belief_hypothesis;
rename TOPIC_KNOWLEDGE topic_knowledge;
rename STATISTICS_SKILL statistics_skill;
rename MODEL_SCORE model_score;
rename AME ame;
rename belief_H1_11 belief_h1_11;
rename belief_H1_12 belief_h1_12;
rename belief_H1_13 belief_h1_13;
rename Hsupport hsupport;
rename Hreject hreject;
rename Hrej hrej;
rename Hsup hsup;
rename Hnotest hnotest;
rename Hmixed hmixed;

encode Hresult, gen(hresult);

*SIMPLIFY DATA SET BY DROPPING IRRELEVANT VARIABLES;
drop AU-VE;
drop emigration_ivC-fbXleftright;


*AVERAGE MARGINAL EFFECT VARIABLE;
destring ame, replace force;
summ ame;


*TEAM 1 DOES NOT REPORT AN AME, SO WILL BE DELETED;
list teamid if ame==.;
drop if ame==.;



*TEAM SIZE;
*TEAM 93 HAS TEAM SIZE MISCODED;
replace team_size=3 if teamid==93;
tabulate team_size;

generate t2=(team_size==2);
generate t3=(team_size==3);
unique teamid if team_size==1;
unique teamid if team_size==2;
unique teamid if team_size==3;




*GENDER COMPOSITION OF TEAM;
destring v_1101 v_1102 v_1103, force replace;
generate nmale=(v_1101==1) + (v_1102==1) + (v_1103==1);
generate team=(v_1101~=.) + (v_1102~=.) + (v_1103~=.);
generate pmale=nmale/team;
replace pmale=.6666667 if teamid==27;
tabulate pmale;





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
replace mdegree=20 if (team==2 & mdegree==.) ;
tabulate counter2 if mdegree==20;




*NOW BREAK UP TEAM SIZE 3 INTO 4 CATEGORIES;

replace mdegree=31 if (counter2==3323 | counter2==3336
	| counter2==3343);
replace mdegree=32 if (counter2==3244 
	| counter2==3414 | counter2==3443);
*THE FOLLOWING 2 CATEGORIES USE DIFFERENT LEAD AUTHOR IN SOCIO OR POLI SCI TO CLASSIFY;
*ALSO SEPARATES OUT STRANGE TEAM WITH 3 DISTINCT FIELDS;
replace mdegree=33 if (counter2==3344 );
replace mdegree=34 if (counter2==3433);
replace mdegree=35 if (counter2==3654);
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
unique teamid if group1==1 & group3==1;
replace group3=1 if group1==1 & group3==1;
replace group1=0 if group1==1 & group3==1;




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
drop topic_cat;
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










*BELIEF HYPOTHESIS HAS USUAL PROBLEM WITH MISSING DATA FOR TEAM 27;
*WILL AGAIN USE HOT DECK PROCEDURE;
*NOT CLEAR THAT BELIEF VARIABLE SHOULD BE IMPUTED IN THIS CONTEXT;
*AS THE BELIEF VARIABLE IS A KEY INDEPENDENT VARIABLE;
tabulate belief_hypothesis if teamid==27;
tabulate belief_ipred if teamid==27;

tabulate belief_hypothesis if mdegree==40 & team_size==1 & pmale==0;
replace belief_hypothesis="Low" if teamid==27;
replace belief_ipred="-1.13508799270782" if teamid==27;

tabulate belief_hypothesis, missing;

*BELIEF_CAT REVERSES ORDER TO MAKE IT CONSISTENT WITH DATA;
drop belief_cat;
generate belief_cat=3*(belief_hypothesis=="Low") + 2*(belief_hypothesis=="Mid") 
	+ 1*(belief_hypothesis=="High");
tabulate belief_hypothesis belief_cat, missing;


destring belief_ipred, force replace;




*THERE IS PROBABLY A MISCODING OF WHAT "HIGH BELIEF" MEANS IN DATA SET, DIRECTION IS REVERSED;
*ALTERNATIVE MEASURE OF BELIEF HYPOTHESIS USING INDIVIDUAL TEAM MEMBER BELIEFS;
*SEE 002_CRI_DATA_PREP.RMD, LINE 356;
*SUGGESTS CODING CHANGED FROM QUESTIONNAIRE AND HIGHER VALUES OF BELIEF_H1_11 SHOULD INDICATE MORE BELIEF IN HYPOTHESIS;
*BUT DISTRIBUTION OF VARIABLE COMPARED TO APPENDIX SUGGESTS THAT 1 IS STRONGLY REDUCES, AND 4 IS SOMEWHAT INCREASES;
*NOTE HIGH VALUE OF BELIEF_1_AVG MEANS *WEAKER* BELIEF IN HYPOTHESIS IMMIGRATION REDUCES SOCIAL SUPPORT;
*NOTE THAT BELIEF_1_AVG AND BELIEF_H1_11 ARE THE SAME FOR SINGLE PERSON TEAMS;
tabulate belief_1_avg belief_hypothesis;
tabulate belief_1_avg;
tabulate belief_1_avg belief_h1_11 if team_size==1;


destring belief_1_avg, force replace;
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

tabulate belief_hypothesis, sum(pbelief);
tabulate belief_hypothesis, sum(belief_ipred);
tabulate pbelief, sum(belief_ipred);


*NOTE SIGN IS REVERSED BECAUSE THE ORDERING OF THE BELIEF VARIABLE IN FINAL DATA SET IS INCORRECT;
generate belief_brw=-belief_ipred;
tabulate belief_hypothesis, sum(belief_brw);
tabulate pbelief, sum(belief_brw);

tabulate belief_cat, sum(belief_brw);




tabulate Hresult hresult;

summ belief_brw stats_brw topic_brw ame;






	
*MERGING IN ALTERNATIVE MEASURES OF MEAN AND VARIANCE OF AME FROM MODEL LEVEL DATA;
sort teamid hrej;
merge teamid hrej using /volumes/ddisk/data/junkvar.dta;
drop _merge;

*MERGING IN REFEREE SCORE;
sort teamid hrej;
merge teamid hrej using /volumes/ddisk/data/junkpscore.dta;
drop _merge;

drop if ame==.;

summ ame meaname;
*NOTE THAT AT TEAM-CONCLUSION LEVEL HREJ IS THE CORRECT VARIABLE TO USE;
list teamid hrej hreject ame meaname;





tabulate hrej hreject;








*DO BELIEFS DRIVE NORMATIVE CONCLUSIONS?
*WEIGHTED BY # OF MODELS SO THAT TEAMS THAT STUDIED THE ISSUE "MORE" COUNT MORE IN THE NORMATIVE REGRESSION;


*ALTERNATIVE MEASURES OF BELIEF;
*BELIEF_BRW IS THE FACTOR INDEX IN THE ORIGINAL PAPER TIMES MINUS 1;
*PBELIEF GIVES THE FRACTION OF THE TEAM THAT STRONGLY BELIEVES IN HYPOTHESIS;
*HBELIEF IS A DUMMY = 1 IF BELIEF_HYPOTHESIS IS "LOW", WHICH MEANS TEAM REALLY BELIEVES THE HYPOTHESIS BASED ON FACTOR INDEX;
*PB1 = 1 IF MORE THAN HALF TEH TEAM STRONGLY BELIEVES IN HYPOTHESIS;

generate hbelief=(belief_hypothesis=="Low");
corr pbelief hbelief;



*PB1 INDICATES IF MORE THAN HALF THE TEAM STRONGLY BELIEVES IN HYPOTHESIS;
generate pb1=(pbelief>.5);








*MAIN REGRESSIONS AND PREDICTIONS FOR GRAPH;



quietly logit hrej pb1  meaname rneg  nmodel  stats_brw topic_brw i.team_size i.mdegree [iw=1]   , 
	cluster(teamid);
display e(r2_p); 
margins, dydx(pb1-topic);
quietly logit hrej pb1  meaname rneg group1 group3 nmodel  stats_brw topic_brw i.team_size i.mdegree [iw=1]   , 
	cluster(teamid);
display e(r2_p); 
margins, dydx(pb1-topic);

quietly logit hrej pb1  meaname rneg  nmodel  stats_brw topic_brw i.team_size i.mdegree [iw=nmodel]   , 
	cluster(teamid);
display e(r2_p); 
margins, dydx(pb1-topic);
quietly logit hrej pb1  meaname rneg group1 group3 nmodel  stats_brw topic_brw i.team_size i.mdegree [iw=nmodel]   , 
	cluster(teamid);
display e(r2_p); 
margins, dydx(pb1-topic);


generate code=1*(rneg<=.15) + 2*(rneg>.15 & rneg<.5) + 3*(rneg==.5) + 4*(rneg>.5);
generate v10=(code==1 & pb1==0);
generate v11=(code==1 & pb1==1);
generate v20=(code==2 & pb1==0);
generate v21=(code==2 & pb1==1);
generate v30=(code==3 & pb1==0);
generate v31=(code==3 & pb1==1);
generate v40=(code==4 & pb1==0);
generate v41=(code==4 & pb1==1);
generate gp=1*v10 + 2*v11 + 3*v20 + 4*v21 + 5*v30 + 6*v31 + 7*v40 + 8*v41;


tabulate code pb1, sum(hrej) me nofreq;


logit hrej i.gp  , nocons cluster(teamid);
margins gp, atmeans;

logit hrej i.gp nmodel stats_brw topic_brw i.team_size i.mdegree ,  cluster(teamid);
margins gp, atmeans;
lincom 1.gp-2.gp;
lincom 3.gp-4.gp;
lincom 5.gp-6.gp;
lincom 7.gp-8.gp;

logit hrej i.gp nmodel stats_brw topic_brw i.team_size i.mdegree [iw=nmodel],  cluster(teamid);
margins gp, atmeans;
lincom 1.gp-2.gp;
lincom 3.gp-4.gp;
lincom 5.gp-6.gp;
lincom 7.gp-8.gp;





save /volumes/ddisk/data/junkrej.dta, replace;



*GRAPHICAL ANALYSIS OF BELIEFS AND HYPOTHESIS REJECTION;
*DONE AT THE TEAM-CONCLUSION LEVEL, AND USING THE PB1 MEASURE OF BELIEFS;
*collapse (mean) rneg hrej pb1, by(teamid);


replace code=0.075 if code==1;
replace code=0.325 if code==2;
replace code=0.5 if code==3;
replace code=0.75 if code==4;
tabulate code;

collapse (mean) hrej, by(code pb1);

reshape wide hrej, i(code) j(pb1);
list;
scatter hrej* code, connect(l l)
	legend(pos(6) rows(1)) legend(order(1 "No belief in hypothesis" 2 "Strong belief in hypothesis"))	
	saving(/volumes/ddisk/mi/researcher/rejection.gph, replace);




use /volumes/ddisk/data/junkrej.dta, clear;



log close;


