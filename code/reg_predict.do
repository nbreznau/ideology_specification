#delimit ;
log using /volumes/ddisk/mi/researcher/reg_predict.log, replace;
clear matrix;
clear mata;



*USES THE MODEL LEVEL DATA CREATED IN REG_MODEL.DO;


use "/Volumes/Ddisk/MI/Researcher/model.dta", clear;
encode dv, gen(dvv);

drop if ame==.;

*DEFINES "SET" AS THE SET OF VARIABLES USED TO SUMMARIZE SPECIFICATION DECISIONS;
global set scale stock flow  level_cyear allavailable w1996 w2006 w2016;



*GETS LINEAR PREDICTION OF THE SET;
*LINEAR PREDICTION IS USELESS AS IT DOESN'T REALLY TAKE ACCOUNT OF INTERACTIONS;
regress ame $set [aw=model_brw];
predict pame;


*THE COLLAPSE BY $SET WEIGHTED BY THE REFEREE SCORE MODEL_BRW PRODUCES SIMILAR RESULTS;

*THE VARIABLE MAME IS THE MEAN AME BY SPECIFICATION;
*THE VARIABLE MEANSCORE IS THE MEAN REFEREE SCORE FOR EACH OF THE 58 SPECIFICATIONS;
collapse (mean) mame=ame pame meanscore=model_brw meanpeer=pscore, 
	by($set);
*THE VARIABLE SPEC GIVES THE NUMBER OF THE SPECIFICATION, THERE ARE 58;
generate spec=_n;
summ mame spec;
save /volumes/ddisk/data/junkame.dta, replace;




*MERGE MAME WITH THE DATA SET;
use "/Volumes/Ddisk/MI/Researcher/model.dta";

encode dv, gen(dvv);

global set scale stock flow  level_cyear allavailable w1996 w2006 w2016;

	
sort $set;
merge $set using /volumes/ddisk/data/junkame.dta;


*NOTE THAT MODEL_BRW IS THE WRONG SCORE FOR THE 58 MIXED SPECIFICATION;
*SO WILL USE MEANSCORE INSTEAD;

*NOTE DIFFERENCE IN R-SQUARED BETWEEN AME AND LINEAR SET OF SPECIFICATION PREDICTIONS;
*AND AME AND FULL INTERACTION MODEL;

reg ame $set;
areg ame, absorb(spec);





*MEANS OF REGRESSORS USED TO SUMMARIZE SPEFICATIONS BY INDEX;
*THIS CREATES DESCRIPTIVE TABLE OF DIFFERENT SPECIFICATIONS USED BY DIFFERENT BROUPS;

tabulate index,  sum(scale);
tabulate index, sum(stock);
tabulate index, sum(flow);
tabulate index, sum(level_cyear);
tabulate index, sum(allavailable);
tabulate index, sum(w1996);
tabulate index, sum(w2006);
tabulate index, sum(w2016);







*REGRESSIONS ON PREDICTED AME;


reg mame proindex     stats_brw topic_brw   t2 t3 i.mdegree  [aw=1/nmodel],  cluster(teamid);
reg mame dindex     stats_brw topic_brw   t2 t3 i.mdegree   [aw=1/nmodel],  cluster(teamid);
reg mame group1 group3     stats_brw topic_brw   t2 t3 i.mdegree   [aw=1/nmodel],  cluster(teamid);

reg mame proindex     stats_brw topic_brw   t2 t3 i.mdegree  [aw=meanpeer/nmodel],  cluster(teamid);
reg mame dindex     stats_brw topic_brw   t2 t3 i.mdegree  [aw=meanpeer/nmodel],  cluster(teamid);
reg mame group1 group3     stats_brw topic_brw   t2 t3 i.mdegree  [aw=meanpeer/nmodel],  cluster(teamid);




*REGRESSIONS ON "RESIDUAL" OF AME AFTER TAKING ACCOUNT OF ENDOGENOUS SPECIFICATION SELECTION;

gen residual=ame-mame;

reg residual proindex     stats_brw topic_brw   t2 t3 i.mdegree   [aw=1/nmodel],  cluster(teamid);
reg residual dindex     stats_brw topic_brw   t2 t3 i.mdegree   [aw=1/nmodel],  cluster(teamid);
reg residual group1 group3     stats_brw topic_brw   t2 t3 i.mdegree   [aw=1/nmodel],  cluster(teamid);

reg residual proindex     stats_brw topic_brw   t2 t3 i.mdegree  [aw=meanpeer/nmodel],  cluster(teamid);
reg residual dindex     stats_brw topic_brw   t2 t3 i.mdegree  [aw=meanpeer/nmodel],  cluster(teamid);
reg residual group1 group3     stats_brw topic_brw   t2 t3 i.mdegree  [aw=meanpeer/nmodel],  cluster(teamid);





*THIS PRODUCES THE GRAPH SHOWING DISTRIBUTION DIFFERENCES IN PREDICTED AME ACROSS TEAMS;
*twoway (kdensity mame if index==1 [fw=1], kernel(ep) lcolor(red) fcolor(red%2) lwidth(medium) bwidth(.03) )
	(kdensity mame if index==2 [fw=1],kernel(ep) lcolor(green) fcolor(green%20) lwidth(medium) bwidth(.03) ) 
	(kdensity mame if index==3 [fw=1], kernel(ep) lcolor(blue) fcolor(blue%2) lwidth(medium) bwidth(.03)) ,
	legend(pos(6) rows(1)) legend(order(1 "Anti-immigrant teams" 2 "Moderate teams" 3 "Pro-immigrant teams"))
	saving(/volumes/ddisk/mi/researcher/hist_pred_ame.gph, replace);



*THIS SAVES THE GRAPH;
*twoway (kdensity mame if index==1 [fw=1], kernel(ep) lcolor(red) fcolor(red%2) lwidth(medium) bwidth(.03) )
	(kdensity mame if index==2 [fw=1],kernel(ep) lcolor(green) fcolor(green%20) lwidth(medium) bwidth(.03) ) 
	(kdensity mame if index==3 [fw=1], kernel(ep) lcolor(blue) fcolor(blue%2) lwidth(medium) bwidth(.03)) ,
	legend(pos(6) rows(1)) legend(order(1 "Anti-immigrant teams" 2 "Moderate teams" 3 "Pro-immigrant teams"))
	saving(/volumes/ddisk/mi/researcher/hist_pred_ame.gph, replace);


log close;
