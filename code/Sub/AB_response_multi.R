library(dplyr)
library(purrr)
library(miceadds)
library(stringr)

# --- 1. Define Your Variable Permutations ---
dvs <- c("AME", "pos10s", "neg10s")
test_ivs <- c("proindex", "group1", "group3", "group1 + group3", 
              "p12", "p56", "p12 + p56")
base_controls <- "stats_brw + topic_brw + t2 + t3"
disc_vars <- c("soc_on_team", "polsci_on_team", "sing_dummy_1", 
               "sing_dummy_2.1", "sing_dummy_2.2")

# Generate all 32 possible combinations of your 5 discipline variables
# (Ranging from 0 included to all 5 included)
disc_combos <- unlist(lapply(0:length(disc_vars), function(x) {
  combn(disc_vars, x, simplify = FALSE)
}), recursive = FALSE)

# Convert combinations into formula-ready strings
disc_strings <- sapply(disc_combos, function(x) {
  if(length(x) == 0) return("") else return(paste(x, collapse = " + "))
})

# --- 2. Build the Master Grid of Models ---
model_grid <- expand.grid(dv = dvs, test = test_ivs, disc = disc_strings, 
                          stringsAsFactors = FALSE) %>%
  mutate(
    model_num = row_number(),
    # Construct the exact formula string
    formula_str = case_when(
      disc == "" ~ paste(dv, "~", test, "+", base_controls),
      TRUE ~ paste(dv, "~", test, "+", base_controls, "+", disc)
    )
  )

# --- 3. Run Models & Extract Results ---
multiverse_results <- map_dfr(1:nrow(model_grid), function(i) {
  
  f_str <- model_grid$formula_str[i]
  
  # Use tryCatch so the loop doesn't break if one model fails due to singularities
  tryCatch({
    # Run the model
    m <- miceadds::lm.cluster(formula = as.formula(f_str), 
                              weights = 1/df$nmodel, 
                              cluster = "u_teamid", 
                              data = df)
    
    # Extract robust coefficients and variance-covariance matrix
    coefs <- coef(m)
    vcov_mat <- vcov(m)
    
    # Initialize an empty list for this row's results
    res <- list(
      model_num = model_grid$model_num[i],
      equation = f_str,
      
      coef_proindex = NA_real_, se_proindex = NA_real_,
      coef_group1 = NA_real_, se_group1 = NA_real_,
      coef_group3 = NA_real_, se_group3 = NA_real_,
      coef_g1_minus_g3 = NA_real_, se_g1_minus_g3 = NA_real_,
      
      coef_p12 = NA_real_, se_p12 = NA_real_,
      coef_p56 = NA_real_, se_p56 = NA_real_,
      coef_p12_minus_p56 = NA_real_, se_p12_minus_p56 = NA_real_
    )
    
    # Safely pull coefficients and SEs if they exist in the model
    if ("proindex" %in% names(coefs)) {
      res$coef_proindex <- coefs["proindex"]
      res$se_proindex <- sqrt(vcov_mat["proindex", "proindex"])
    }
    if ("group1" %in% names(coefs)) {
      res$coef_group1 <- coefs["group1"]
      res$se_group1 <- sqrt(vcov_mat["group1", "group1"])
    }
    if ("group3" %in% names(coefs)) {
      res$coef_group3 <- coefs["group3"]
      res$se_group3 <- sqrt(vcov_mat["group3", "group3"])
    }
    if ("p12" %in% names(coefs)) {
      res$coef_p12 <- coefs["p12"]
      res$se_p12 <- sqrt(vcov_mat["p12", "p12"])
    }
    if ("p56" %in% names(coefs)) {
      res$coef_p56 <- coefs["p56"]
      res$se_p56 <- sqrt(vcov_mat["p56", "p56"])
    }
    
    # Calculate Linear Combinations if both terms exist in the model
    if (all(c("group1", "group3") %in% names(coefs))) {
      res$coef_g1_minus_g3 <- coefs["group1"] - coefs["group3"]
      res$se_g1_minus_g3 <- sqrt(vcov_mat["group1", "group1"] + 
                                   vcov_mat["group3", "group3"] - 
                                   2 * vcov_mat["group1", "group3"])
    }
    
    if (all(c("p12", "p56") %in% names(coefs))) {
      res$coef_p12_minus_p56 <- coefs["p12"] - coefs["p56"]
      res$se_p12_minus_p56 <- sqrt(vcov_mat["p12", "p12"] + 
                                     vcov_mat["p56", "p56"] - 
                                     2 * vcov_mat["p12", "p56"])
    }
    
    return(as_tibble(res))
    
  }, error = function(e) {
    # If the model fails entirely, return the formula with an error note
    res_err <- tibble(model_num = model_grid$model_num[i], equation = paste("FAILED:", f_str))
    return(res_err)
  })
})

# View the final compiled dataframe
head(multiverse_results)

# combine

library(dplyr)

# Re-join the dv and test columns from your model_grid so we can use them for logic
final_results <- multiverse_results %>%
  left_join(model_grid %>% select(model_num, dv, test), by = "model_num") %>%
  mutate(
    # 1. Grab the single correct raw effect and SE based on the 'test' variable
    raw_effect = case_when(
      test == "proindex" ~ coef_proindex,
      test == "group1" ~ coef_group1,
      test == "group3" ~ coef_group3,
      test == "group1 + group3" ~ coef_g1_minus_g3,
      test == "p12" ~ coef_p12,
      test == "p56" ~ coef_p56,
      test == "p12 + p56" ~ coef_p12_minus_p56
    ),
    se = case_when(
      test == "proindex" ~ se_proindex,
      test == "group1" ~ se_group1,
      test == "group3" ~ se_group3,
      test == "group1 + group3" ~ se_g1_minus_g3,
      test == "p12" ~ se_p12,
      test == "p56" ~ se_p56,
      test == "p12 + p56" ~ se_p12_minus_p56
    ),
    
    # 2. Apply your explicit theoretical alignment rules
    effect = case_when(
      # proindex: needs sign change for neg10s
      test == "proindex" & dv == "neg10s" ~ raw_effect * -1,
      
      # group1 and p12: need sign change for AME and pos10s
      test %in% c("group1", "p12") & dv %in% c("AME", "pos10s") ~ raw_effect * -1,
      
      # group3 and p56: need sign change for neg10s
      test %in% c("group3", "p56") & dv == "neg10s" ~ raw_effect * -1,
      
      # Linear Combos: For AME/pos10s, (negative group1) - (positive group3) = a negative raw distance. 
      # We multiply by -1 to convert it to a positive absolute magnitude.
      test %in% c("group1 + group3", "p12 + p56") & dv %in% c("AME", "pos10s") ~ raw_effect * -1,
      
      # Everything else (e.g., proindex on AME, linear combos on neg10s) stays exactly as is
      TRUE ~ raw_effect
    ),
    
    # 3. Calculate final metrics
    sig = ifelse(abs(effect / se) > 1.645, 1, 0),
    ci_90 = 1.645 * se,
    ci_lower = effect - ci_90,
    ci_upper = effect + ci_90
  ) %>%
  
  # 4. Clean up the dataframe by dropping models that failed to run
  filter(!is.na(effect))

# Check the first few rows to verify the alignment
head(final_results %>% select(model_num, dv, test, raw_effect, effect, sig))



# 1. Filter, sort, and rank to create the curve shape
plot_data <- final_results %>%
  filter(!is.na(effect)) %>%         # Drop any rows that failed to produce an effect
  arrange(effect) %>%                # Sort from most negative to most positive
  mutate(model_rank = row_number())  # Assign the x-axis rank

# 2. Plot the Specification Curve
spec_curve <- ggplot(plot_data, aes(x = model_rank, y = effect)) +
  
  # Plot 90% Confidence Intervals in the background using your calculated bounds
  geom_errorbar(aes(ymin = ci_lower, ymax = ci_upper),
                width = 0, color = "grey70", alpha = 0.6) +
  
  # Plot point estimates on top, mapping the color to your 'sig' dummy
  geom_point(aes(color = factor(sig)), size = 1.2) +
  
  # Apply the requested blue and grey color scheme
  scale_color_manual(values = c("0" = "grey40", "1" = "blue"),
                     labels = c("Not Significant", "Significant (p < 0.10)")) +
  
  # Add a null baseline
  geom_hline(yintercept = 0, linetype = "dashed", color = "black", linewidth = 0.5) +
  
  # Clean up the aesthetics
  labs(
    title = "Specification Curve of Multiverse Analysis",
    subtitle = "Point estimates with 90% Confidence Intervals",
    x = "Models Ranked by Effect Size",
    y = "Coefficient Estimate",
    color = "Significance"
  ) +
  theme_classic() +
  theme(
    axis.text.x = element_blank(),      # Hide the arbitrary rank numbers on the x-axis
    axis.ticks.x = element_blank(),
    legend.position = "bottom"
  )

