m_1ldp <- lm(formula=pos10s ~ indiv2 + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_2ldp <- lm(formula=pos10s ~ indiv1 + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_3ldp <- lm(formula=pos10s ~ indiv1 + indiv3 + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_4ldp <- lm(formula=pos10s ~ indiv1 + indiv3 + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_5ldp <- lm(formula=pos10s ~ att + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

m_6ldp <- lm(formula=pos10s ~ att + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)


p_1ldp <- lm(formula=pos10s ~ indiv1 + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_2ldp <- lm(formula=pos10s ~ indiv1 + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_3ldp <- lm(formula=pos10s ~ indiv1 + indiv3 + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_4ldp <- lm(formula=pos10s ~ indiv1 + indiv3 + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_5ldp <- lm(formula=pos10s ~ att + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)

p_6ldp <- lm(formula=pos10s ~ att + pbelief + stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)


null_mldp <- lm(formula=pos10s ~ stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight, data = df_dyad)

null_pldp <- lm(formula=pos10s ~ stats_i + topic_i + t2 + t3 + factor(backgr_degree), weights = df_dyad$pweight*df_dyad$pscore, data = df_dyad)