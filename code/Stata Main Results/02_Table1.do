
#delimit ;
* DEFINE WORKING DIRECTORY;
global workd "/GitHub/ideology_specification";
log using "$workd/code/Log Files/01_Table1.log", replace;
clear matrix;
clear mata;

use "$workd/data/df.dta", clear;

*DESCRIPTIVE TABLE AT THE MODEL LEVEL;

tabulate topic_knowledge, sum(topic_brw);
tabulate statistics_skill, sum(stats_brw);
tabulate model_score, sum(model_brw);

generate hmodel=(model_score=="High");


summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  ;
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  if index==1 ;
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  if index==2;
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  if index==3;


*SUMMARY STATS WEIGHTED BY THE INVERSE OF THE NUMBER OF MODELS;
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2   [aw=1/nmodel];
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  if index==1  [aw=1/nmodel];
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  if index==2 [aw=1/nmodel];
summ ame neg10 pos10 negsig possig neg10s pos10s proindex  p12 p34 p56 group1 group2 group3 pbelief  nmodel team_size
	stats_brw topic_brw model_brw peer_mean zpeer_mean quality quality2  if index==3 [aw=1/nmodel];

collapse (mean) team_size group1 group2 group3, by(teamid);
summ team_size;
summ team_size if group1==1;
summ team_size if group2==1;
summ team_size if group3==1;


log close;
