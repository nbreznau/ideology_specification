#delimit ;
* DEFINE WORKING DIRECTORY;
global workd "/GitHub/ideology_specification";
log using "$workd/code/Log Files/03_Robustness.log", replace;
clear matrix;
clear mata;


*KEY ROBUSTNESS CHECKS OF MAIN RESULT;
*SENSITIVITY TO DEFINITION OF EDUCATION VECTOR;
*AND TO DEFINITION OF IMMIGRATION IDEOLOGY;


*USES THE MODEL LEVEL DATA CREATED IN 02_Main_Models.DO;


use "$workd/data/newmodel.dta", clear;


*BRW MEASURE OF IMMIGRATION SENTIMENT;
tabulate proindex;
*P34 AND P56 ARE % OF TEAM THAT HAVE CODES 3-4, OR 5-6, IN IDEOLOGY MEASURE;
tabulate p12;
tabulate p34;
tabulate p56;

********************************************************************************;
****************************** Table S5 ****************************************;
********************************************************************************;
*positive or negative, cut at 0.015, otherwise results basically zero;
gen pos01 = .;
replace pos01 = 1 if ame >= 0.015;
replace pos01 = 0 if ame <= -0.015;
reg pos01  proindex    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
reg pos01  group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
reg pos01  group1 group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
lincom group3-group1;
reg pos01  group1 group3  pbelief  stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
lincom group3-group1;
*peer scores;
reg pos01  group1 group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel],  cluster(teamid);
lincom group3-group1;
reg pos01  group1 group3  pbelief  stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel] ,  cluster(teamid);
lincom group3-group1;

********************************************************************************;
****************************** Table S6 ****************************************;
********************************************************************************;

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

************************************************************************;
******************* Table S9 *******************************************;
************************************************************************;
*Team leader's ideology as independent variable;
generate oldanti=(oldimm<=2);
generate oldpro=(oldimm>=5);
reg ame  oldimm    		stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
reg ame oldpro 				stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
reg ame  oldanti oldpro  	stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
lincom oldanti-oldpro;
reg ame  oldanti oldpro  pbelief	stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);
lincom oldanti-oldpro;

*peer scores;

reg ame  oldanti oldpro     stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel],  cluster(teamid);
lincom oldanti-oldpro;
reg ame  oldanti oldpro   pbelief  stats_brw topic_brw t2 t3 i.mdegree   [aw=pscore/nmodel],  cluster(teamid);
lincom oldanti-oldpro;

* ALL REGRESSION COMBINATIONS

************************************************************************;
******************* Tables S7 & S8 *************************************;
************************************************************************;

set more off;

* Use carriage return mode (no semicolons);

#delimit cr;


tempname results
postfile `results' str40 model str20 ideology str20 coeff using ideology_results.dta, replace


* ------------------ PROINDEX MODELS ------------------
foreach dv in ame neg10s pos10s pos01 {
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "proindex_`i'_`dv'"
    if "`i'" == "00" {
        reg `dv' proindex [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' proindex i.mdegree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' proindex i.mdegree stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' proindex i.mdegree stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' proindex i.degree1 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' proindex i.degree1 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' proindex i.degree1 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' proindex i.counter2 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' proindex i.counter2 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' proindex i.counter2 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' proindex i.mdegree pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' proindex i.mdegree stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' proindex i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' proindex i.degree1 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' proindex i.degree1 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' proindex i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' proindex i.counter2 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' proindex i.counter2 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' proindex i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    local b = _b[proindex]
    local se = _se[proindex]
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
	post `results' ("`model'") ("proindex") ("`coeff'")
	post `results' ("") ("proindex") ("`stderr'")
}

* ------------------ TEAM LEAD IMM MODELS ------------------
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "oldimm_`i'_`dv'"
    if "`i'" == "00" {
        reg `dv' oldimm [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' oldimm i.mdegree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' oldimm i.mdegree stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' oldimm i.mdegree stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' oldimm i.degree1 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' oldimm i.degree1 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' oldimm i.degree1 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' oldimm i.counter2 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' oldimm i.counter2 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' oldimm i.counter2 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' oldimm i.mdegree pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' oldimm i.mdegree stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' oldimm i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' oldimm i.degree1 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' oldimm i.degree1 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' oldimm i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' oldimm i.counter2 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' oldimm i.counter2 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' oldimm i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    local b = _b[oldimm]
    local se = _se[oldimm]
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
	post `results' ("`model'") ("oldimm") ("`coeff'")
	post `results' ("") ("oldimm") ("`stderr'")
}

* ------------------ P56 - P12 MODELS ------------------

foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "p12p56_`i'_`dv'"
    if "`i'" == "00" {
        reg `dv' p12 p56 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' p12 p56 i.mdegree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' p12 p56 i.mdegree stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' p12 p56 i.mdegree stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' p12 p56 i.degree1 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' p12 p56 i.degree1 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' p12 p56 i.degree1 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' p12 p56 i.counter2 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' p12 p56 i.counter2 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' p12 p56 i.counter2 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' p12 p56 i.mdegree pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' p12 p56 i.mdegree stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' p12 p56 i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' p12 p56 i.degree1 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' p12 p56 i.degree1 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' p12 p56 i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' p12 p56 i.counter2 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' p12 p56 i.counter2 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' p12 p56 i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    lincom p56 - p12
    local b = r(estimate)
    local se = r(se)
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("p56-p12") ("`coeff'")
    post `results' ("") ("p56-p12")  ("`stderr'")
}

* ------------------ GROUP3 - GROUP1 MODELS ------------------

foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "g1g3_`i'_`dv'"
    if "`i'" == "00" {
        reg `dv' group1 group3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' group1 group3 i.mdegree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' group1 group3 i.mdegree stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' group1 group3 i.mdegree stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' group1 group3 i.degree1 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' group1 group3 i.degree1 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' group1 group3 i.degree1 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' group1 group3 i.counter2 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' group1 group3 i.counter2 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' group1 group3 i.counter2 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' group1 group3 i.mdegree pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' group1 group3 i.mdegree stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' group1 group3 i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' group1 group3 i.degree1 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' group1 group3 i.degree1 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' group1 group3 i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' group1 group3 i.counter2 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' group1 group3 i.counter2 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' group1 group3 i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    lincom group3 - group1
    local b = r(estimate)
    local se = r(se)
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("group3-group1") ("`coeff'")
    post `results' ("") ("group3-group1") ("`stderr'")
}

* ------------------ oldanti-oldpro MODELS ------------------

foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "olda1oldp3_`i'_`dv'"
    if "`i'" == "00" {
        reg `dv' oldanti oldpro [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' oldanti oldpro i.mdegree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' oldanti oldpro i.mdegree stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' oldanti oldpro i.mdegree stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' oldanti oldpro i.degree1 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' oldanti oldpro i.degree1 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' oldanti oldpro i.degree1 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' oldanti oldpro i.counter2 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' oldanti oldpro i.counter2 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' oldanti oldpro i.counter2 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' oldanti oldpro i.mdegree pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' oldanti oldpro i.mdegree stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' oldanti oldpro i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' oldanti oldpro i.degree1 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' oldanti oldpro i.degree1 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' oldanti oldpro i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' oldanti oldpro i.counter2 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' oldanti oldpro i.counter2 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' oldanti oldpro i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
	
    lincom oldanti - oldpro
    local b = r(estimate)
    local se = r(se)
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("oldanti-oldpro") ("`coeff'")
    post `results' ("") ("oldanti-oldpro") ("`stderr'")
}


* ------------------ p56 or p12 MODELS ------------------
*depends on DV which direction
if "`dv'" == "pos10s" {
	local pm "p12"
} 
else {
	local pm "p56"
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "g1g3_`i'_`dv'"
    if "`i'" == "00" {
        reg `dv' `pm' [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' `pm' i.mdegree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' `pm' i.mdegree stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' `pm' i.mdegree stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' `pm' i.degree1 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' `pm' i.degree1 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' `pm' i.degree1 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' `pm' i.counter2 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' `pm' i.counter2 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' `pm' i.counter2 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' `pm' i.mdegree pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' `pm' i.mdegree stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' `pm' i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' `pm' i.degree1 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' `pm' i.degree1 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' `pm' i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' `pm' i.counter2 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' `pm' i.counter2 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' `pm' i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    local b = _b[`pm']
    local se = _se[`pm']
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("p56") ("`coeff'")
    post `results' ("") ("p56") ("`stderr'")
}

* ------------------ GROUP3 MODELS ------------------
*depends on DV which direction
if "`dv'" == "pos10s" {
	local gm "group1"
} 
else {
	local gm "group3"
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "g1g3_`i'_`dv'"
    if "`i'" == "00" {
        reg `dv' `gm' [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' `gm' i.mdegree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' `gm' i.mdegree stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' `gm' i.mdegree stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' `gm' i.degree1 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' `gm' i.degree1 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' `gm' i.degree1 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' `gm' i.counter2 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' `gm' i.counter2 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' `gm' i.counter2 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' `gm' i.mdegree pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' `gm' i.mdegree stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' `gm' i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' `gm' i.degree1 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' `gm' i.degree1 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' `gm' i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' `gm' i.counter2 pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' `gm' i.counter2 stats_brw topic_brw pbelief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' `gm' i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=1/nmodel], cluster(teamid)
    }
    local b = _b[`gm']
    local se = _se[`gm']
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("group3") ("`coeff'")
    post `results' ("") ("group3") ("`stderr'")

}

***********************************************************************************************************************
******************************** WEIGHTED BY PEER REVIEW SCORES *******************************************************
***********************************************************************************************************************




foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "proindex_`i'_`dv'_peer"
    if "`i'" == "00" {
        reg `dv' proindex [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' proindex i.mdegree [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' proindex i.mdegree stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' proindex i.mdegree stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' proindex i.degree1 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' proindex i.degree1 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' proindex i.degree1 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' proindex i.counter2 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' proindex i.counter2 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' proindex i.counter2 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' proindex i.mdegree pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' proindex i.mdegree stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' proindex i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' proindex i.degree1 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' proindex i.degree1 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' proindex i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' proindex i.counter2 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' proindex i.counter2 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' proindex i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    local b = _b[proindex]
    local se = _se[proindex]
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
	post `results' ("`model'") ("proindex") ("`coeff'")
	post `results' ("") ("proindex") ("`stderr'")
}

* ------------------ TEAM LEAD IMM MODELS ------------------
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "oldimm_`i'_`dv'_peer"
    if "`i'" == "00" {
        reg `dv' oldimm [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' oldimm i.mdegree [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' oldimm i.mdegree stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' oldimm i.mdegree stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' oldimm i.degree1 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' oldimm i.degree1 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' oldimm i.degree1 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' oldimm i.counter2 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' oldimm i.counter2 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' oldimm i.counter2 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' oldimm i.mdegree pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' oldimm i.mdegree stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' oldimm i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' oldimm i.degree1 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' oldimm i.degree1 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' oldimm i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' oldimm i.counter2 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' oldimm i.counter2 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' oldimm i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    local b = _b[oldimm]
    local se = _se[oldimm]
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
	post `results' ("`model'") ("oldimm") ("`coeff'")
	post `results' ("") ("oldimm") ("`stderr'")
}

* ------------------ P56 - P12 MODELS ------------------

foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "p12p56_`i'_`dv'_peer"
    if "`i'" == "00" {
        reg `dv' p12 p56 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' p12 p56 i.mdegree [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' p12 p56 i.mdegree stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' p12 p56 i.mdegree stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' p12 p56 i.degree1 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' p12 p56 i.degree1 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' p12 p56 i.degree1 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' p12 p56 i.counter2 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' p12 p56 i.counter2 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' p12 p56 i.counter2 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' p12 p56 i.mdegree pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' p12 p56 i.mdegree stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' p12 p56 i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' p12 p56 i.degree1 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' p12 p56 i.degree1 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' p12 p56 i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' p12 p56 i.counter2 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' p12 p56 i.counter2 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' p12 p56 i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    lincom p56 - p12
    local b = r(estimate)
    local se = r(se)
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("p56-p12") ("`coeff'")
    post `results' ("") ("p56-p12")  ("`stderr'")
}

* ------------------ GROUP3 - GROUP1 MODELS ------------------

foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "g1g3_`i'_`dv'_peer"
    if "`i'" == "00" {
        reg `dv' group1 group3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' group1 group3 i.mdegree [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' group1 group3 i.mdegree stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' group1 group3 i.mdegree stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' group1 group3 i.degree1 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' group1 group3 i.degree1 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' group1 group3 i.degree1 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' group1 group3 i.counter2 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' group1 group3 i.counter2 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' group1 group3 i.counter2 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' group1 group3 i.mdegree pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' group1 group3 i.mdegree stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' group1 group3 i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' group1 group3 i.degree1 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' group1 group3 i.degree1 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' group1 group3 i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' group1 group3 i.counter2 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' group1 group3 i.counter2 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' group1 group3 i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    lincom group3 - group1
    local b = r(estimate)
    local se = r(se)
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("group3-group1") ("`coeff'")
    post `results' ("") ("group3-group1") ("`stderr'")
}

* ------------------ oldanti-oldpro MODELS ------------------

foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "olda1oldp3_`i'_`dv'_peer"
    if "`i'" == "00" {
        reg `dv' oldanti oldpro [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' oldanti oldpro i.mdegree [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' oldanti oldpro i.mdegree stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' oldanti oldpro i.mdegree stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' oldanti oldpro i.degree1 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' oldanti oldpro i.degree1 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' oldanti oldpro i.degree1 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' oldanti oldpro i.counter2 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' oldanti oldpro i.counter2 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' oldanti oldpro i.counter2 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' oldanti oldpro i.mdegree pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' oldanti oldpro i.mdegree stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' oldanti oldpro i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' oldanti oldpro i.degree1 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' oldanti oldpro i.degree1 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' oldanti oldpro i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' oldanti oldpro i.counter2 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' oldanti oldpro i.counter2 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' oldanti oldpro i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
	
    lincom oldanti - oldpro
    local b = r(estimate)
    local se = r(se)
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("oldanti-oldpro") ("`coeff'")
    post `results' ("") ("oldanti-oldpro") ("`stderr'")
}


* ------------------ percent MODELS ------------------
*depends on DV which direction
if "`dv'" == "pos10s" {
	local pm "p12"
} 
else {
	local pm "p56"
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "g1g3_`i'_`dv'_peer"
    if "`i'" == "00" {
        reg `dv' `pm' [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' `pm' i.mdegree [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' `pm' i.mdegree stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' `pm' i.mdegree stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' `pm' i.degree1 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' `pm' i.degree1 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' `pm' i.degree1 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' `pm' i.counter2 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' `pm' i.counter2 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' `pm' i.counter2 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' `pm' i.mdegree pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' `pm' i.mdegree stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' `pm' i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' `pm' i.degree1 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' `pm' i.degree1 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' `pm' i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' `pm' i.counter2 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' `pm' i.counter2 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' `pm' i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    local b = _b[`pm']
    local se = _se[`pm']
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("p56") ("`coeff'")
    post `results' ("") ("p56") ("`stderr'")
}

* ------------------ GROUP3 MODELS ------------------
*depends on DV which direction
if "`dv'" == ""pos10s {"
	local gm "group1"
} 
else {
	local gm "group3"
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "g1g3_`i'_`dv'_peer"
    if "`i'" == "00" {
        reg `dv' `gm' [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' `gm' i.mdegree [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' `gm' i.mdegree stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' `gm' i.mdegree stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' `gm' i.degree1 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' `gm' i.degree1 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' `gm' i.degree1 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' `gm' i.counter2 [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' `gm' i.counter2 stats_brw topic_brw [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' `gm' i.counter2 stats_brw topic_brw t2 t3 [aw=pscore/nmodel], cluster(teamid)
    }
	else if "`i'" == "10" {
        reg `dv' `gm' i.mdegree pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' `gm' i.mdegree stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' `gm' i.mdegree stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' `gm' i.degree1 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' `gm' i.degree1 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' `gm' i.degree1 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' `gm' i.counter2 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' `gm' i.counter2 stats_brw topic_brw pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' `gm' i.counter2 stats_brw topic_brw t2 t3 pbelief [aw=pscore/nmodel], cluster(teamid)
    }
    local b = _b[`gm']
    local se = _se[`gm']
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("group3") ("`coeff'")
    post `results' ("") ("group3") ("`stderr'")

}

}

* ------------------ END ------------------

postclose `results'

preserve
use ideology_results.dta, clear
export excel using ideology_results.xlsx, firstrow(variables) replace
restore

log close
