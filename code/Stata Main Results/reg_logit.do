 #delimit ;
log using /volumes/ddisk/mi/researcher/reg_logit.log, replace;
clear matrix;
clear mata;



*LOGIT REGRESSIONS;



use /volumes/ddisk/mi/researcher/model.dta, clear;



*MAIN OLS SPECIFICATION FOR CHECK;
reg ame  group1 group3    stats_brw topic_brw t2 t3 i.mdegree   [aw=1/nmodel] ,  cluster(teamid);



*LOGIT REGRESSIONS ON OUTLYING NEGATIVE & SIGNIFICANT COEFFICIENTS;
quietly logit neg10s   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(stats_brw-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit neg10s dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(dindex-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit neg10s dindex   pbelief stats_brw topic_brw t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(dindex-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit neg10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit neg10s group1 group3   pbelief stats_brw topic_brw t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit neg10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit neg10s proindex   pbelief stats_brw topic_brw t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
display e(ll) _skip(5) e(r2_p);




*LOGIT REGRESSIONS ON OUTLYING POSITIVE & SIGNIFICANT COEFFICIENTS;
quietly logit pos10s   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(stats_brw-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit pos10s group1   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit pos10s group1   pbelief stats_brw topic_brw t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit pos10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit pos10s group1 group3   pbelief stats_brw topic_brw t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit pos10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit pos10s proindex   pbelief stats_brw topic_brw t2 t3 i.mdegree  [iw=1/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
display e(ll) _skip(5) e(r2_p);




*LOGIT WEIGHTED REGRESSIONS ON OUTLYING NEGATIVE & SIGNIFICANT COEFFICIENTS;
quietly logit neg10s   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(stats_brw-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit neg10s dindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(dindex-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit neg10s dindex   pbelief stats_brw topic_brw t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(dindex-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit neg10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit neg10s group1 group3   pbelief stats_brw topic_brw t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit neg10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit neg10s proindex   pbelief stats_brw topic_brw t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
display e(ll) _skip(5) e(r2_p);




*LOGIT WEIGHTED REGRESSIONS ON OUTLYING POSITIVE & SIGNIFICANT COEFFICIENTS;
quietly logit pos10s   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(stats_brw-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit pos10s group1   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit pos10s group1   pbelief stats_brw topic_brw t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit pos10s group1 group3   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit pos10s group1 group3   pbelief stats_brw topic_brw t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(group1-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit pos10s proindex   stats_brw topic_brw  t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
display e(ll) _skip(5) e(r2_p);
quietly logit pos10s proindex   pbelief stats_brw topic_brw t2 t3 i.mdegree  [iw=pscore/nmodel] ,  cluster(teamid);
margins, dydx(proindex-topic_brw);
display e(ll) _skip(5) e(r2_p);





log close;


