library(dplyr)
library(ragg)
library(ggplot2)
library(readxl)


df_dyadx <- read_xlsx(here("code", "Stata Main Results", "ideology_resultsd_ext.xlsx"))


df_parsed_dyad <- df_dyadx %>%
  fill(model, .direction = "down") %>%
  mutate(
    row_type = if_else(str_detect(coeff, "\\("), "se", "coef"),
    sig = if_else(row_type == "coef" & str_detect(coeff, "\\*"), 1L, 0L),
    effect_tmp = if_else(row_type == "coef",
                         parse_number(str_remove_all(coeff, "\\*")),
                         NA_real_),
    se_tmp = if_else(row_type == "se",
                     parse_number(str_remove_all(coeff, "[\\(\\)]")),
                     NA_real_)
  ) %>%
  group_by(model) %>%
  summarise(
    effect = mean(abs(effect_tmp), na.rm = T),
    se     = mean(se_tmp, na.rm = T),
    ideology = first(na.omit(ideology)),
    sig = first(na.omit(sig))) %>%
  subset(!is.na(model)) %>%
  arrange(effect) %>%
  mutate(model_ord = row_number())



p_curve_nosing <- ggplot(df_parsed_dyad, aes(x = model_ord, y = effect)) +
  geom_errorbar(aes(ymin = effect - 1.96 * se,
                    ymax = effect + 1.96 * se),
                width = 0, color = "grey50") +
  geom_point(aes(color = factor(sig)), size = 0.9) +   # map sig to color
  scale_color_manual(values = c("0" = "grey70", "1" = "blue")) +
  scale_y_continuous(limits = c(-0.1, NA)) +
  geom_hline(yintercept = 0, linetype = "dotted", color = "grey50") +
  labs(
    title = NULL,
    x = NULL,
    y = "Effect with 95% error bars",
    color = "p < 0.10"
  ) +
  theme_classic() +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    panel.grid.major.x = element_blank()
  )



agg_png(here("results", "Fig1_AB_Resp.png"), res = 288, width = 3000, height = 1500)

p_curve_nosing

dev.off()



df_parsed_dyad %>%
  summarise(pct_sig = mean(sig == 1) * 100)

df_parsed_dyad <- df_parsed_dyad %>%
  mutate(
    # Extract ONLY the two digits flanked by underscores, then convert to numeric
    model_num = as.numeric(str_match(model, "_(\\d{2})_")[, 2]),
    
    # Create dummy: 1 if model is 07 through 18, 0 otherwise
    target_dummy = if_else(model_num >= 7 & model_num <= 18, 1, 0)
  )

# 2. Calculate the percentage significant by group
sig_comparison <- df_parsed_dyad %>%
  group_by(target_dummy) %>%
  summarise(
    total_models = n(),
    # mean() of a 1/0 variable calculates the exact proportion; multiply by 100 for %
    pct_sig = mean(sig == 1, na.rm = TRUE) * 100 
  )
