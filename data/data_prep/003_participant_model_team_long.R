library('tidyverse')

# long format participant data (each participant is a row)
cri_long <- read_csv(here::here("data", "cri_survey_long_public_nolabs.csv"))
cri <- read_csv(here::here("data", "cri.csv"))
# cri_team <- read_csv(here::here("data", "cri_team.csv"))

# create a df where each participant gets a dyad with each model from their team
cri_long_participant_ame_dyad <- merge(cri_long, cri, by = "u_teamid")

write.csv(cri_long_participant_ame_dyad, here::here("data", "cri_long_participant_ame_dyad.csv"), row.names = F)
