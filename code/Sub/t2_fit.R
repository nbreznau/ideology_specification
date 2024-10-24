m_1l <- lm(formula=AME ~ group3 + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_2l <- lm(formula=AME ~ group3 + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_3l <- lm(formula=AME ~ group1 + group3 + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_4l <- lm(formula=AME ~ group1 + group3 + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_5l <- lm(formula=AME ~ proindex + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

m_6l <- lm(formula=AME ~ proindex + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)


p_1l <- lm(formula=AME ~group3 + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_2l <- lm(formula=AME ~ group3 + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_3l <- lm(formula=AME ~ group1 + group3 + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_4l <- lm(formula=AME ~ group1 + group3 + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_5l <- lm(formula=AME ~ proindex + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

p_6l <- lm(formula=AME ~ proindex + pbelief + stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)

null_ml <- lm(formula=AME ~ stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = 1/df$nmodel, data = df)

null_pl <- lm(formula=AME ~ stats_brw + topic_brw + t2 + t3 + factor(mdegree), weights = df$pscore/df$nmodel, data = df)