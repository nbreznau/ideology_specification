library('haven')
library('tidyverse')

# Unipark Survey Wave 4
W4 <- read_sav(here("data", "data_prep", "W4_export.sav"))


# Keep only peer review variables
df <- W4 %>%
  select(u_id, u_teamid, v_108:v_187)


# create summary statistics
df_x <- df %>%
  summarise(across(v_108:v_187, 
                   list(mean = ~mean(., na.rm = TRUE), 
                        N = ~sum(!is.na(.)))))

mean_cols <- grep("_mean", names(df_x), value = TRUE)
n_cols <- grep("_N", names(df_x), value = TRUE)

# Step 2: Extract the variable names by removing '_mean' and '_N' suffixes
variables <- gsub("_mean", "", mean_cols)

# Step 3: Create the new dataframe with variable, mean, and N columns
df_sum <- tibble(
  variable = variables,
  mean = as.numeric(df_x[mean_cols][1, ]),
  N = as.numeric(df_x[n_cols][1, ])
)

# remember 1 is unconfident and 7 is confident

# File with model descriptions (extracted from 'Research Designs' Google Sheet)
df_desc_match <- Research_Designs_Copy_of_DataoutWD <- read.csv(here("data", "data_prep", "Research Designs - Copy of DataoutWD.csv"))


# Three teams' models were divisible by major differences (linear/logit, scale versus single-item)
# These teams need the correct model identifiers

# Import cri results
cri <- read_csv(here("data", "cri.csv"))

# now matching the paragraph descriptions with the actual models

# create two df with identical columns and order for easy matching

df_cri <- select(cri, c("id", "twowayfe", "cluster_any", "mlm_re", "mlm_fe", "hybrid_mlm", "level_cyear", 
                        "level_country", "level_year", "logit", "ologit", "lpm", "listwise", 
                        "multimpute", "ols", "mlogit", "bayes", "L2boots", "weights",  
                        "pseudo_pnl", "dichotomize", "categorical", "mmodel", "unbalpanel", "w1985",
                        "w1990", "w1996", "w2006", "w2016", "AU", "AT", "BE", "CA", "CL", "HR", "CZ", 
                        "DK", "FI", "FR", "DE", "HU", "IS", "IE", "IL", "IT", "JP", "KR", "LV", "LT",
                        "NT", "NZ", "NO", "PH", "PL", "PT", "RU", "SK", "SI", "ES", "SE", "CH", "UK", 
                        "US", "ZA", "TW", "TR", "UY", "VE", "orig13", "orig17", "eeurope", "allavailable",
                        "emplrate_ivC", "unemprate_ivC", "socx_ivC", "gdp_ivC", "pop_ivC", "age_iv",
                        "age2_iv", "sex_iv", "employed_iv", "income_iv"))

df_pr <- select(df_desc_match, c("desc_id", "twowayfe", "cluster_any", "mlm_re", "mlm_fe", "hybrid_mlm", "level_cyear", 
                       "level_country", "level_year", "logit", "ologit", "lpm", "listwise", 
                       "multimpute", "ols", "mlogit", "bayes", "L2boots", "weights",  
                       "pseudo_pnl", "dichotomize", "categorical", "mmodel", "unbalpanel", "w1985",
                       "w1990", "w1996", "w2006", "w2016", "AU", "AT", "BE", "CA", "CL", "HR", "CZ", 
                       "DK", "FI", "FR", "DE", "HU", "IS", "IE", "IL", "IT", "JP", "KR", "LV", "LT",
                       "NT", "NZ", "NO", "PH", "PL", "PT", "RU", "SK", "SI", "ES", "SE", "CH", "UK", 
                       "US", "ZA", "TW", "TR", "UY", "VE", "orig13", "orig17", "eeurope", "allavailable",
                       "emplrate_ivC", "unemprate_ivC", "socx_ivC", "gdp_ivC", "pop_ivC", "age_iv",
                       "age2_iv", "sex_iv", "employed_iv", "income_iv"))

# percentage matching function
match_percentage <- function(row_one, row_two) {
  mean(row_one == row_two) * 100
}

df_cri_matched <- df_cri %>%
  mutate(across(twowayfe:income_iv, as.numeric)) %>%  # Convert to numeric if not already
  bind_cols(map_dfc(1:nrow(df_pr), function(i) {
    df_two_row <- df_pr[i, ]
    match_percentage_col <- apply(df_cri, 1, match_percentage, df_two_row)
    tibble(!!paste0("match_", df_desc_match$desc_id[i]) := match_percentage_col)
  }))

# take models with a 92% matching rate as a match
# create a variable that lists which models match

# start with 95% (277 filled in)
match_columns <- select(df_cri_matched, starts_with("match_"))

df_cri_matched <- df_cri_matched %>%
  mutate(matched_cases = pmap_chr(match_columns, 
                                  ~ {
                                    # Capture the column values
                                    cases <- c(...)
                                    # Get the names of the columns being checked
                                    col_names <- names(match_columns)
                                    # Find the indices where the case values are 80 or greater
                                    matched <- which(cases >= 95)
                                    if (length(matched) > 0) {
                                      # Get the corresponding variable names, remove "match_" prefix
                                      matched_vars <- gsub("match_", "", col_names[matched])
                                      paste(matched_vars, collapse = ", ")
                                    } else {
                                      NA_character_  # If no match, leave as NA
                                    }
                                  }))


# now fill in remaining NA with 93% (500 filled in)
df_cri_matched <- df_cri_matched %>%
  mutate(matched_cases = if_else(
    is.na(matched_cases),  # Only replace NA values
    pmap_chr(match_columns, 
             ~ {
               # Capture the column values
               cases <- c(...)
               # Get the names of the columns being checked
               col_names <- names(match_columns)
               # Find the indices where the case values are 75 or greater
               matched <- which(cases >= 93)
               if (length(matched) > 0) {
                 # Get the corresponding variable names, remove "match_" prefix
                 matched_vars <- gsub("match_", "", col_names[matched])
                 paste(matched_vars, collapse = ", ")
               } else {
                 NA_character_  # If no match, leave as NA
               }
             }),
    matched_cases  # Retain existing values if not NA
  ))
    
# then with 92% (609 filled in)
df_cri_matched <- df_cri_matched %>%
  mutate(matched_cases = if_else(
    is.na(matched_cases),  # Only replace NA values
    pmap_chr(match_columns, 
             ~ {
               # Capture the column values
               cases <- c(...)
               # Get the names of the columns being checked
               col_names <- names(match_columns)
               # Find the indices where the case values are 75 or greater
               matched <- which(cases >= 92)
               if (length(matched) > 0) {
                 # Get the corresponding variable names, remove "match_" prefix
                 matched_vars <- gsub("match_", "", col_names[matched])
                 paste(matched_vars, collapse = ", ")
               } else {
                 NA_character_  # If no match, leave as NA
               }
             }),
    matched_cases  # Retain existing values if not NA
  ))

# then with 90% (871 filled in)
df_cri_matched <- df_cri_matched %>%
  mutate(matched_cases = if_else(
    is.na(matched_cases),  # Only replace NA values
    pmap_chr(match_columns, 
             ~ {
               # Capture the column values
               cases <- c(...)
               # Get the names of the columns being checked
               col_names <- names(match_columns)
               # Find the indices where the case values are 75 or greater
               matched <- which(cases >= 90)
               if (length(matched) > 0) {
                 # Get the corresponding variable names, remove "match_" prefix
                 matched_vars <- gsub("match_", "", col_names[matched])
                 paste(matched_vars, collapse = ", ")
               } else {
                 NA_character_  # If no match, leave as NA
               }
             }),
    matched_cases  # Retain existing values if not NA
  ))

# then with 88% (963 filled in)
df_cri_matched <- df_cri_matched %>%
  mutate(matched_cases = if_else(
    is.na(matched_cases),  # Only replace NA values
    pmap_chr(match_columns, 
             ~ {
               # Capture the column values
               cases <- c(...)
               # Get the names of the columns being checked
               col_names <- names(match_columns)
               # Find the indices where the case values are 75 or greater
               matched <- which(cases >= 88)
               if (length(matched) > 0) {
                 # Get the corresponding variable names, remove "match_" prefix
                 matched_vars <- gsub("match_", "", col_names[matched])
                 paste(matched_vars, collapse = ", ")
               } else {
                 NA_character_  # If no match, leave as NA
               }
             }),
    matched_cases  # Retain existing values if not NA
  ))

# then with 85% (1119 filled in)
df_cri_matched <- df_cri_matched %>%
  mutate(matched_cases = if_else(
    is.na(matched_cases),  # Only replace NA values
    pmap_chr(match_columns, 
             ~ {
               # Capture the column values
               cases <- c(...)
               # Get the names of the columns being checked
               col_names <- names(match_columns)
               # Find the indices where the case values are 75 or greater
               matched <- which(cases >= 85)
               if (length(matched) > 0) {
                 # Get the corresponding variable names, remove "match_" prefix
                 matched_vars <- gsub("match_", "", col_names[matched])
                 paste(matched_vars, collapse = ", ")
               } else {
                 NA_character_  # If no match, leave as NA
               }
             }),
    matched_cases  # Retain existing values if not NA
  ))

# then with 80% (1271 filled in)
df_cri_matched <- df_cri_matched %>%
  mutate(matched_cases = if_else(
    is.na(matched_cases),  # Only replace NA values
    pmap_chr(match_columns, 
             ~ {
               # Capture the column values
               cases <- c(...)
               # Get the names of the columns being checked
               col_names <- names(match_columns)
               # Find the indices where the case values are 75 or greater
               matched <- which(cases >= 80)
               if (length(matched) > 0) {
                 # Get the corresponding variable names, remove "match_" prefix
                 matched_vars <- gsub("match_", "", col_names[matched])
                 paste(matched_vars, collapse = ", ")
               } else {
                 NA_character_  # If no match, leave as NA
               }
             }),
    matched_cases  # Retain existing values if not NA
  ))

# create a df to use for creating model-participant dyads
df_mod_indiv_dyads <- select(df_cri_matched, c(id, matched_cases))
write_rds(df_mod_indiv_dyads, here("data", "data_prep", "df_mod_indiv_dyads.rds"))

# calculate the weighted mean
calculate_weighted_mean <- function(vars, df_sum) {
  # Filter df_sum for the matching variables
  df_filtered <- df_sum %>% filter(variable %in% vars)
  
  if (nrow(df_filtered) > 0) {
    # Calculate the weighted mean: sum(mean * N) / sum(N)
    weighted_mean <- sum(df_filtered$mean * df_filtered$N) / sum(df_filtered$N)
    return(weighted_mean)
  } else {
    return(NA_real_)
  }
}

# Function to calculate weighted mean and sum of N
calculate_peer_N <- function(vars, df_sum) {
  # Filter df_sum for the matching variables
  df_filtered <- df_sum %>% filter(variable %in% vars)
  
  if (nrow(df_filtered) > 0) {
    # Sum the N values
    total_N <- sum(df_filtered$N)
    return(total_N)
  } else {
    return(NA_real_)
  }
}

# Apply logic to df_cri_matched
df_cri_matched <- df_cri_matched %>%
  mutate(
    peer_mean = if_else(
      is.na(matched_cases),  # If matched_cases is NA, peer_mean stays NA
      NA_real_, 
      # Otherwise, calculate the weighted mean
      map_dbl(matched_cases, ~ {
        # Split the matched_cases string into individual variables
        vars <- unlist(strsplit(.x, ", "))
        
        # Call the function to calculate weighted mean
        if (length(vars) > 0) {
          calculate_weighted_mean(vars, df_sum)
        } else {
          NA_real_
        }
      })
    ),
    
    peer_N = if_else(
      is.na(matched_cases),  # If matched_cases is NA, peer_N stays NA
      NA_real_,
      # Otherwise, calculate the sum of N values
      map_dbl(matched_cases, ~ {
        # Split the matched_cases string into individual variables
        vars <- unlist(strsplit(.x, ", "))
        
        # Call the function to calculate the sum of N
        if (length(vars) > 0) {
          calculate_peer_N(vars, df_sum)
        } else {
          NA_real_
        }
      })
    )
  )

# Now filter out the scores
cri_new_peer_scores <- select(df_cri_matched, c(id, peer_mean, peer_N))

# remove B&M's original model
cri_new_peer_scores <- cri_new_peer_scores[49:1309,]



write.csv(cri_new_peer_scores, here::here("data", "cri_new_peer_scores.csv"), row.names = F)
