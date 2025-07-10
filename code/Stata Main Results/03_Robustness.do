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

*REGRESSIONS, ADDING CONTROLS STEPWISE;
*Response to R1, PNAS;
*Improved workflow for easy posting;

set more off;

* Use carriage return mode (no semicolons);

#delimit cr


tempname results
postfile `results' str40 model str20 ideology str20 coeff using ideology_results.dta, replace


* ------------------ PROINDEX MODELS ------------------
foreach dv in ame neg10s pos10s {
foreach i in 00 01 02 03 04 05 06 07 08 09 {
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
    local b = _b[proindex]
    local se = _se[proindex]
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
	post `results' ("`model'") ("proindex") ("`coeff'")
	post `results' ("") ("proindex") ("`stderr'")
}

* ------------------ P56 - P12 MODELS ------------------

foreach i in 00 01 02 03 04 05 06 07 08 09 {
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

foreach i in 00 01 02 03 04 05 06 07 08 09 {
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
    lincom group3 - group1
    local b = r(estimate)
    local se = r(se)
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("group3-group1") ("`coeff'")
    post `results' ("") ("group3-group1") ("`stderr'")
}

* Second Robustness Table
* ------------------ p56 MODELS ------------------
foreach i in 00 01 02 03 04 05 06 07 08 09 {
    local model "g1g3_`i'_`dv'"
    if "`i'" == "00" {
        reg `dv' p56 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' p56 i.mdegree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' p56 i.mdegree stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' p56 i.mdegree stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' p56 i.degree1 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' p56 i.degree1 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' p56 i.degree1 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' p56 i.counter2 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' p56 i.counter2 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' p56 i.counter2 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    local b = _b[p56]
    local se = _se[p56]
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("p56") ("`coeff'")
    post `results' ("") ("p56") ("`stderr'")
}

* ------------------ GROUP3 MODELS ------------------

foreach i in 00 01 02 03 04 05 06 07 08 09 {
    local model "g1g3_`i'_`dv'"
    if "`i'" == "00" {
        reg `dv' group3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' group3 i.mdegree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' group3 i.mdegree stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' group3 i.mdegree stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' group3 i.degree1 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' group3 i.degree1 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' group3 i.degree1 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' group3 i.counter2 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' group3 i.counter2 stats_brw topic_brw [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' group3 i.counter2 stats_brw topic_brw t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    local b = _b[group3]
    local se = _se[group3]
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
