#delimit ;
* DEFINE WORKING DIRECTORY;
global workd "/GitHub/ideology_specification";
log using "$workd/code/Log Files/03.1_Robustness_Dyad.log", replace;
clear matrix;
clear mata;


*KEY ROBUSTNESS CHECKS OF DYAD RESULT;

*USES THE MODEL LEVEL DATA CREATED IN 04_Dyads.DO;


use "$workd/data/newmodel_d.dta", clear;


#delimit cr

tempname results
postfile `results' str40 model str20 ideology str20 coeff using ideology_resultsd.dta, replace


* ------------------ PROINDEX MODELS ------------------
foreach dv in ame neg10s pos10s {
foreach i in 00 01 02 03 04 05 06 {
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
    local b = _b[proindex]
    local se = _se[proindex]
    local star = cond(abs((`b')/(`se')) > 2.58, "***", cond(abs((`b')/(`se')) > 1.96, "**", cond(abs((`b')/(`se')) > 1.64, "*", "")))
    local coeff : display %4.2f `b' "`star'"
    local stderr : display "(" %4.2f `se' ")"
	post `results' ("`model'") ("proindex") ("`coeff'")
	post `results' ("") ("proindex") ("`stderr'")
}

* ------------------ P56 - P12 MODELS ------------------

foreach i in 00 01 02 03 04 05 06 {
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
foreach i in 00 01 02 03 04 05 06{
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
use ideology_resultsd.dta, clear
export excel using ideology_resultsd.xlsx, firstrow(variables) replace
restore

log close
