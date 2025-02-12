#delimit ;
* DEFINE WORKING DIRECTORY;
global workd "/GitHub/ideology_specification";
log using "$workd/code/Log Files/03_Robustness.log", replace;
clear matrix;
clear mata;


*KEY ROBUSTNESS CHECKS OF MAIN RESULT;
*SENSITIVITY TO DEFINITION OF EDUCATION VECTOR;
*AND TO DEFINITION OF IMMIGRATION IDEOLOGY;


*USES THE MODEL LEVEL DATA CREATED IN 02_Table_1_2_5_6.DO;


use "$workd/data/newmodel.dta", clear;


*BRW MEASURE OF IMMIGRATION SENTIMENT;
tabulate proindex;
*P34 AND P56 ARE % OF TEAM THAT HAVE CODES 3-4, OR 5-6, IN IDEOLOGY MEASURE;
tabulate p12;
tabulate p34;
tabulate p56;


*WEIGHTED BY 1/NMODEL;
*USING MDEGREE EDUCATION VECTOR;
reg ame  proindex    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
reg ame  p12 p56    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg ame  group1 group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
lincom group3-group1;
reg ame  group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);

*USING EDUCATION OF LEAD RESEARCHER;
reg ame  proindex    stats_brw topic_brw t2 t3 i.degree1   [aw=1/nmodel] ,  cluster(teamid);
reg ame  p12 p56    stats_brw topic_brw t2 t3 i.degree1   [aw=1/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg ame  group1 group3    stats_brw topic_brw t2 t3 i.degree1   [aw=1/nmodel] ,  cluster(teamid);
lincom group3-group1;
reg ame  group3    stats_brw topic_brw t2 t3 i.degree1   [aw=1/nmodel] ,  cluster(teamid);


*USING ALL POSSIBLE COMBINATIONS OF EDUCATION AMONG THREE RESEARCHERS;
reg ame  proindex    stats_brw topic_brw t2 t3 i.counter2   [aw=1/nmodel] ,  cluster(teamid);
reg ame  p12 p56    stats_brw topic_brw t2 t3 i.counter2   [aw=1/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg ame  group1 group3    stats_brw topic_brw t2 t3 i.counter2   [aw=1/nmodel] ,  cluster(teamid);
lincom group3-group1;
reg ame  group3    stats_brw topic_brw t2 t3 i.counter2   [aw=1/nmodel] ,  cluster(teamid);




*WEIGHTED BY PSCORE/NMODEL;
*USING MDEGREE EDUCATION VECTOR;
reg ame  proindex    stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);
reg ame  p12 p56    stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg ame  group1 group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);
lincom group3-group1;
reg ame  group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);


*USING EDUCATION OF LEAD RESEARCHER;
reg ame  proindex    stats_brw topic_brw t2 t3 i.degree1   [aw=pscore/nmodel] ,  cluster(teamid);
reg ame  p12 p56    stats_brw topic_brw t2 t3 i.degree1   [aw=pscore/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg ame  group1 group3    stats_brw topic_brw t2 t3 i.degree1   [aw=pscore/nmodel] ,  cluster(teamid);
lincom group3-group1;
reg ame  group3    stats_brw topic_brw t2 t3 i.degree1   [aw=pscore/nmodel] ,  cluster(teamid);


*USING ALL POSSIBLE COMBINATIONS OF EDUCATION AMONG THREE RESEARCHERS;
reg ame  proindex    stats_brw topic_brw t2 t3 i.counter2   [aw=pscore/nmodel] ,  cluster(teamid);
reg ame  p12 p56    stats_brw topic_brw t2 t3 i.counter2   [aw=pscore/nmodel] ,  cluster(teamid);
lincom p56-p12;
reg ame  group1 group3    stats_brw topic_brw t2 t3 i.counter2   [aw=pscore/nmodel] ,  cluster(teamid);
lincom group3-group1;
reg ame  group3    stats_brw topic_brw t2 t3 i.counter2   [aw=pscore/nmodel] ,  cluster(teamid);


log close;
