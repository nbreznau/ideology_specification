m_1ln <- lm(formula=neg10s ~ group3 + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_2ln <- lm(formula=neg10s ~ group3 + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_3ln <- lm(formula=neg10s ~ group1 + group3 + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_4ln <- lm(formula=neg10s ~ group1 + group3 + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_5ln <- lm(formula=neg10s ~ proindex + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_6ln <- lm(formula=neg10s ~ proindex + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)


p_1ln <- lm(formula=neg10s ~group3 + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_2ln <- lm(formula=neg10s ~ group3 + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_3ln <- lm(formula=neg10s ~ group1 + group3 + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_4ln <- lm(formula=neg10s ~ group1 + group3 + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_5ln <- lm(formula=neg10s ~ proindex + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_6ln <- lm(formula=neg10s ~ proindex + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

null_mln <- lm(formula=neg10s ~ stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

null_pln <- lm(formula=neg10s ~ stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)