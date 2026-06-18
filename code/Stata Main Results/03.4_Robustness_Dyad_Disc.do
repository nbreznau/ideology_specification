#delimit ;
* DEFINE WORKING DIRECTORY;
global workd "/GitHub/ideology_specification";
log using "$workd/code/Log Files/03.1_Robustness_Dyad_Disc.log", replace;
clear matrix;
clear mata;


*KEY ROBUSTNESS CHECKS OF DYAD RESULT;
* This time edited to include the equivalent models that were run at the team-level;
* with degree coded differently;

*USES THE MODEL LEVEL DATA CREATED IN 04_Dyads.DO;


use "$workd/data/newmodel_d.dta", clear;

encode backgr_degree1, gen(fdegree);
gen maj_degree = 1;
replace maj_degree = 3 if inlist(teamid, 6, 7, 8, 13, 16, 17, 19, 20, 21, 22, 23, 26, 28, 30, 31, 32, 34, 35, 36, 37, 38, 39, 42, 43, 45, 49, 52, 54, 58, 61, 62, 65, 68, 69, 70, 72, 73, 86, 95, 101);
replace maj_degree = 4 if inlist(teamid, 2, 3, 5, 18, 27, 40, 41, 46, 64, 75, 77, 82, 83, 84, 87, 93, 94, 96, 97, 98, 104);
replace maj_degree = 5 if inlist(teamid, 12, 33, 48, 56, 60);
replace maj_degree = 6 if inlist(teamid, 10, 106);

#delimit cr

tempname results
postfile `results' str40 model str20 ideology str20 coeff using ideology_resultsd_ext.dta, replace


* ------------------ PROINDEX MODELS ------------------
foreach dv in ame neg10s pos10s {
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "dproindex_`i'_`dv'"
    if "`i'" == "00" {
        reg `dv' proindex [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' proindex i.degree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' proindex i.degree stats_i topic_i [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' proindex i.degree stats_i topic_i t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' proindex i.degree belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' proindex i.degree stats_i topic_i belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' proindex i.degree stats_i topic_i t2 t3 belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "07" {
        reg `dv' proindex i.fdegree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' proindex i.fdegree stats_i topic_i [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' proindex i.fdegree stats_i topic_i t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "10" {
        reg `dv' proindex i.fdegree belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' proindex i.fdegree stats_i topic_i belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' proindex i.fdegree stats_i topic_i t2 t3 belief [aw=1/nmodel], cluster(teamid)
    }
	else if "`i'" == "13" {
        reg `dv' proindex i.maj_degree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' proindex i.maj_degree stats_i topic_i [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' proindex i.maj_degree stats_i topic_i t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' proindex i.maj_degree belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' proindex i.maj_degree stats_i topic_i belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' proindex i.maj_degree stats_i topic_i t2 t3 belief [aw=1/nmodel], cluster(teamid)
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

foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "dp12p56_`i'_`dv'"
    if "`i'" == "00" {
        reg `dv' indiv1 indiv3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' indiv1 indiv3 i.degree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' indiv1 indiv3 i.degree stats_i topic_i [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' indiv1 indiv3 i.degree stats_i topic_i t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' indiv1 indiv3 i.degree belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' indiv1 indiv3 i.degree stats_i topic_i belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' indiv1 indiv3 i.degree stats_i topic_i t2 t3 belief [aw=1/nmodel], cluster(teamid)
    }
	else if "`i'" == "07" {
        reg `dv' indiv1 indiv3 i.fdegree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' indiv1 indiv3 i.fdegree stats_i topic_i [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' indiv1 indiv3 i.fdegree stats_i topic_i t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "10" {
        reg `dv' indiv1 indiv3 i.fdegree belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' indiv1 indiv3 i.fdegree stats_i topic_i belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' indiv1 indiv3 i.fdegree stats_i topic_i t2 t3 belief [aw=1/nmodel], cluster(teamid)
    }
	else if "`i'" == "13" {
        reg `dv' indiv1 indiv3 i.maj_degree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' indiv1 indiv3 i.maj_degree stats_i topic_i [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' indiv1 indiv3 i.maj_degree stats_i topic_i t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' indiv1 indiv3 i.maj_degree belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' indiv1 indiv3 i.maj_degree stats_i topic_i belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' indiv1 indiv3 i.maj_degree stats_i topic_i t2 t3 belief [aw=1/nmodel], cluster(teamid)
    }
    lincom indiv3 - indiv1
    local b = r(estimate)
    local se = r(se)
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("indiv3-indiv1") ("`coeff'")
    post `results' ("") ("indiv3-indiv1")  ("`stderr'")
}



* Second Robustness Table
* ------------------ percent MODELS ------------------
if "`dv'" == "pos10s" {
	local gm "indiv1"
} 
else {
	local gm "indiv3"
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 {
    local model "dg1g3_`i'_`dv'"
    if "`i'" == "00" {
        reg `dv' `gm' [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "01" {
        reg `dv' `gm' i.degree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "02" {
        reg `dv' `gm' i.degree stats_i topic_i [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "03" {
        reg `dv' `gm' i.degree stats_i topic_i t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "04" {
        reg `dv' `gm' i.degree belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "05" {
        reg `dv' `gm' i.degree stats_i topic_i belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "06" {
        reg `dv' `gm' i.degree stats_i topic_i t2 t3 belief [aw=1/nmodel], cluster(teamid)
    }
	else if "`i'" == "07" {
        reg `dv' `gm' i.fdegree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "08" {
        reg `dv' `gm' i.fdegree stats_i topic_i [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "09" {
        reg `dv' `gm' i.fdegree stats_i topic_i t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "10" {
        reg `dv' `gm' i.fdegree belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "11" {
        reg `dv' `gm' i.fdegree stats_i topic_i belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "12" {
        reg `dv' `gm' i.fdegree stats_i topic_i t2 t3 belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "13" {
        reg `dv' `gm' i.maj_degree [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "14" {
        reg `dv' `gm' i.maj_degree stats_i topic_i [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "15" {
        reg `dv' `gm' i.maj_degree stats_i topic_i t2 t3 [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "16" {
        reg `dv' `gm' i.maj_degree belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "17" {
        reg `dv' `gm' i.maj_degree stats_i topic_i belief [aw=1/nmodel], cluster(teamid)
    }
    else if "`i'" == "18" {
        reg `dv' `gm' i.maj_degree stats_i topic_i t2 t3 belief [aw=1/nmodel], cluster(teamid)
    }
    local b = _b[`gm']
    local se = _se[`gm']
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
    post `results' ("`model'") ("p56") ("`coeff'")
    post `results' ("") ("p56") ("`stderr'")
}



}

* ------------------ END ------------------

postclose `results'

preserve
use ideology_resultsd_ext.dta, clear
export excel using ideology_resultsd_ext.xlsx, firstrow(variables) replace
restore

log close
