library('haven')
library('tidyverse')

# Unipark Survey Wave 4
W4 <- read_sav(here::here("data", "data_prep", "W4_export.sav"))

# data generated in `subjective_voting_prep.R`
df_dyad <- read_rds(here::here("data", "data_prep", "df_mod_indiv_dyads.rds"))

# Model description paragraphs, given to participants to review
df_model_desc <- read_csv(here::here("data", "data_prep", "Model_Paragraphs_For_Merge.csv"))

# setup dataframe by question name
model_qs <- as.data.frame(colnames(subset(W4, select = v_108:v_187)))
colnames(model_qs) <- "matched_cases"

# make model variables
model_ids <- df_dyad$id[49:1309] #remove the original B&M models
model_qs[model_ids] <- NA

# mark which models have which variable
# Create a copy of the model_qs dataframe to store the result
model_qs_result <- model_qs

# Step 1: Split multiple values in df_dyad$matched_cases by comma and expand into a list
df_dyad$matched_cases_list <- strsplit(as.character(df_dyad$matched_cases), ",")

# Step 2: Initialize the model_qs_result dataframe with zeros
model_qs_result[, -1] <- 0  # Assuming first column is 'matched_cases'

# Step 3: Iterate over each row in model_qs and mark matches
for (i in 1:nrow(model_qs_result)) {
  
  # Extract the matched case for the current row in model_qs
  current_case <- model_qs_result$matched_cases[i]
  
  # Find all ids from df_dyad that match the current case
  matching_ids <- unique(df_dyad$id[unlist(df_dyad$matched_cases_list) %in% current_case])
  
  # remove NA
  matching_ids <- matching_ids[!is.na(matching_ids)]
  
  # Mark 1 in model_qs_result for the corresponding columns of matching ids
  model_qs_result[i, matching_ids] <- 1
}

# use common naming,
model_qs_result$v_variable <- model_qs_result$matched_cases

model_qs_result <- select(model_qs_result, -matched_cases)


# create the person-model_description dataframe
W4_long <- W4 %>%
  pivot_longer(
    cols = matches("^v_10[8-9]$|^v_1[1-8][0-9]$|^v_187$"),  # Select columns v_108 through v_187
    names_to = "v_variable",       # New column for the variable name (v_ columns)
    values_to = "peer_score"       # New column for the values (1 through 7)
  ) %>%
  filter(!is.na(peer_score))       # Remove rows where peer_score is NA

W4_long <- W4_long %>%
  select(u_id, u_teamid, v_variable, peer_score) %>%
  left_join(df_model_desc, by = "v_variable")

W4_long <- subset(W4_long, !is.na(model_desc))

df_model_long <- model_qs_result %>%
  pivot_longer(
    cols = -v_variable,              # Pivot all columns except v_variable
    names_to = "id",                 # New column for the column names (id)
    values_to = "value"              # New column for the 1 or 0 values
  ) %>%
  filter(value == 1)                 # Keep only the rows where the value is 1

# Step 2: Join the W4_long with df_model_long based on the "v_variable"
W4_expanded <- W4_long %>%
  inner_join(df_model_long, by = "v_variable") %>%
  select(-value)                     # Remove the "value" column since we no longer need it


# now save as the final person-model dyads
W4_expanded <- W4_expanded %>%
  select(u_id, u_teamid, id, everything())

write_csv(W4_expanded, here::here("data", "peer_model_dyad.csv"))
