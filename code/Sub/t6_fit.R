m_1lp <- lm(formula=pos10s ~ group1 + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_2lp <- lm(formula=pos10s ~ group1 + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_3lp <- lm(formula=pos10s ~ group1 + group3 + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_4lp <- lm(formula=pos10s ~ group1 + group3 + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_5lp <- lm(formula=pos10s ~ proindex + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_6lp <- lm(formula=pos10s ~ proindex + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)


p_1lp <- lm(formula=pos10s ~ group1 + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_2lp <- lm(formula=pos10s ~ group1 + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_3lp <- lm(formula=pos10s ~ group1 + group3 + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_4lp <- lm(formula=pos10s ~ group1 + group3 + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_5lp <- lm(formula=pos10s ~ proindex + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_6lp <- lm(formula=pos10s ~ proindex + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

null_mlp <- lm(formula=pos10s ~ stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

null_plp <- lm(formula=pos10s ~ stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)