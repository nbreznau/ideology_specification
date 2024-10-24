m_1ldn <- lm(formula=neg10s ~ indiv3 + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_2ldn <- lm(formula=neg10s ~ indiv3 + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_3ldn <- lm(formula=neg10s ~ indiv1 + indiv3 + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_4ldn <- lm(formula=neg10s ~ indiv1 + indiv3 + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_5ldn <- lm(formula=neg10s ~ att + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_6ldn <- lm(formula=neg10s ~ att + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)


p_1ldn <- lm(formula=neg10s ~ indiv3 + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_2ldn <- lm(formula=neg10s ~ indiv3 + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_3ldn <- lm(formula=neg10s ~ indiv1 + indiv3 + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_4ldn <- lm(formula=neg10s ~ indiv1 + indiv3 + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_5ldn <- lm(formula=neg10s ~ att + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_6ldn <- lm(formula=neg10s ~ att + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)


null_mldn <- lm(formula=neg10s ~ stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

null_pldn <- lm(formula=neg10s ~ stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)