#delimit ;
log using /volumes/ddisk/mi/researcher/reg_hours.log, replace;
clear matrix;
clear mata;



*LABOR SUPPLY REGRESSIONS;


use "/Volumes/Ddisk/MI/Researcher/model.dta", clear;


*GET HOURS OF WORK FOR EACH OF THE UP TO THREE TEAM MEMBERS;
destring v_331, force replace;
destring v_332, force replace;
destring v_333,force replace;
summ v_33*;

*NUMBER OF TEAM MEMBERS WITH NON-MISSING HOURS;
replace team=(v_331~=.) + (v_332~=.) + (v_333~=.);
tabulate team_size team;

generate hours1=v_331;
generate hours2=v_332;
generate hours3=v_333;

replace hours1=0 if hours1==.;
replace hours2=0 if hours2==.;
replace hours3=0 if hours3==.;

list hours* if teamid==60;




*CHANGING HOURS WORKED FOR OUTLYING TEAM 60;
*THE VALUE 300 MAY INCLUDE TIME LEARNING STATA;
*CHANGE TEAM 60 HOURS AT THE BEGINNING OF ANY VARIABLE GENERATION;
*WILL SET TO THE HIGHEST OBSERVED VALUE AMONG OTHER PARTICIPANTS, OR 30;



replace hours1=30 if hours1==300;





generate sumhours=hours1+hours2+hours3;

tabulate sumhours;



generate meanhours=sumhours/team;
summ sumhours meanhours;
generate lsumhours=log(sumhours);
generate lmeanhours=log(meanhours);



*GET VARIABLES MEASURING SKILLS IN STATS & POLICY AT INDIVIDUAL LEVEL;

rename backgr_exp_teach_stat1 teach1;
rename backgr_exp_teach_stat2 teach2;
rename backgr_exp_teach_stat3 teach3;
destring teach1 teach2 teach3, force replace;


rename v_181 pubstat1;
rename v_182 pubstat2;
rename v_183 pubstat3;
destring pubstat1 pubstat2 pubstat3, force replace;

rename v_211 pubreg1;
rename v_212 pubreg2;
rename v_213 pubreg3;
destring pubreg1 pubreg2 pubreg3, force replace;


rename v_171 pubimm1;
rename v_172 pubimm2;
rename v_173 pubimm3;
destring pubimm1 pubimm2 pubimm3, force replace;

rename v_191 pubpol1;
rename v_192 pubpol2;
rename v_193 pubpol3;
destring pubpol1 pubpol2 pubpol3, force replace;





*MAKES NO SENSE TO RUN HOURS REGRESSIONS AT MODEL LEVEL;
*COLLAPSE TO TEAM LEVEL ;




collapse (mean) sumhours lsumhours meanhours lmeanhours p12 p56  pmale pindex hours1 hours2 hours3
	att1 att2 att3 ame degree1 degree2 degree3
	pubstat1 pubstat2 pubstat3 pubimm1 pubimm2 pubimm3 pubpol1 pubpol2 pubpol3 teach1 teach2 teach3
	pubreg1 pubreg2 pubreg3 
	proindex dindex group1 group3 index team_size t2 t3 nmodel 
	stats_brw topic_brw model_brw mdegree, by(teamid);






*WEIGHING BY INVERSE OF TEAM SIZE ;
*AVERAGE HOURS WORKED BY RESEARCHER MEANS AS JUST FOR A 1 PERSON TEAM AS FOR A 3 PERSON TEAM;	

summ sumhours, detail;
reg lsumhours  group1 group3    team_size stats_brw topic_brw   t2 t3 i.mdegree [aw=1/team_size]  ,  cluster(teamid);
reg lmeanhours  group1 group3    team_size stats_brw topic_brw   t2 t3 i.mdegree  [aw=1/team_size] ,  cluster(teamid);






*LABOR SUPPLY REGRESSIONS AT INDIVIDUAL LEVEL;





replace att1=0 if att1==.;
replace att2=0 if att2==.;
replace att3=0 if att3==.;

keep att1 att2 att3 hours1 hours2 hours3 proindex pindex group1 group3 p12 p56 
	nmodel stats_brw topic_brw model_brw 
	pubstat1 pubstat2 pubstat3 pubimm1 pubimm2 pubimm3 pubpol1 pubpol2 pubpol3 teach1 teach2 teach3
	pubreg1 pubreg2 pubreg3 
	degree1 degree2 degree3 team_size t2 t3 teamid;


reshape long att hours degree pubstat pubreg pubimm pubpol teach diff, i(teamid);


generate lhours=log(hours);
replace att=. if att==0;
generate anti=(att<=2 & att~=.);
generate pro=(att>=5 & att~=.);
replace anti=. if att==0;
replace pro=. if att==0;
replace degree=. if degree==0;
replace diff=. if diff==0;



*REGRESSIONS MEASURING STAT SKILLS AND TOPICAL EXPERIENCE AT INDIVIDUAL LEVEL;

gen stat=(pubstat==2 | pubstat==3);
gen reg=(pubreg==2 | pubreg==3);
gen imm=(pubimm==2 | pubimm==3);
gen pol=(pubpol==2 | pubpol==3);

gen method=(stat==1 | reg==1);
gen topic=(imm==1 | pol==1);

replace stat=. if pubstat==.;
replace reg=. if pubreg==.;
replace imm=. if pubimm==.;
replace pol=. if pubpol==.;
replace method=. if pubstat==. | pubreg==.;
replace topic=. if pubimm==. | pubpol==.;

summ stat reg imm pol method topic;


regress lhours anti pro method topic i.degree, cluster(teamid);
regress lhours anti pro team_size method topic i.degree, cluster(teamid);




log close;
