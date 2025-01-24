#delimit ;
* DEFINE WORKING DIRECTORY;
global workd "/GitHub/ideology_specification";
log using "$workd/code/Log Files/06_Fig_AME_Funnel.log", replace;
clear matrix;
clear mata;

use "$workd/data/df.dta", clear;

* generate standard error;
generate se = abs(ame) / abs(z);



* three cases missing on se;
preserve;
drop if se == .;

* set data as meta analysis data;
meta set ame se;

* funnelplot;
meta funnelplot;

* funnelplot by peer review quality;
meta funnelplot, by(quality2);
generate group = .;
replace group = 1 if group1 == 1;
replace group = 2 if group2 == 1;
replace group = 3 if group3 == 1;

* funnelplot by ideology;
meta funnelplot, by(group);
gen se_trim = se;

* trim huge se to 1 (7 cases);
replace se_trim = 1 if se > 1;

meta set ame se_trim;

meta funnelplot, by(group) msize(tiny);
graph export "C:\GitHub\ideology_specification\code\Stata Main Results\Funnel_Plot.png", as(png) name("Graph") replace;
restore;
log close;