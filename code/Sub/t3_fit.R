m_1ld <- lm(formula=AME ~ indiv3 + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_2ld <- lm(formula=AME ~ indiv3 + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_3ld <- lm(formula=AME ~ indiv1 + indiv3 + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_4ld <- lm(formula=AME ~ indiv1 + indiv3 + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_5ld <- lm(formula=AME ~ att + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_6ld <- lm(formula=AME ~ att + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)


p_1ld <- lm(formula=AME ~ indiv3 + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_2ld <- lm(formula=AME ~ indiv3 + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_3ld <- lm(formula=AME ~ indiv1 + indiv3 + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_4ld <- lm(formula=AME ~ indiv1 + indiv3 + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_5ld <- lm(formula=AME ~ att + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_6ld <- lm(formula=AME ~ att + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)


null_mld <- lm(formula=AME ~ stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

null_pld <- lm(formula=AME ~ stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)