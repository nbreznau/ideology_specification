### Ideological bias in the production of research findings

[George J. Borjas](https://www.hks.harvard.edu/faculty/george-borjas) <br>
Harvard University <br>
[Nate Brezau](https://sites.google.com/site/nbreznau/) <br>
German Institute for Adult Education - Leibniz Institute for Lifelong Learning

### Working NBER Paper
Borjas, George J., and Nate Breznau. 2024. “Ideological Bias in Estimates of the Impact of Immigration.” [https://www.nber.org/papers/w33274](https://www.nber.org/papers/w33274)


<br>
<br>

#### Abstract

This is the reproducible workflow for the study of how political ideology impacts research findings. It uses experimental data from the Crowdsourced Replication Initiative of [Breznau, Rinke and Wuttke et al](https://www.pnas.org/doi/10.1073/pnas.2203150119) involving 71 teams of 158 researchers who produced 1,253 estimates resulting from their various models testing the impact of immigration on public opinion using International Social Survey Program and various macro-indicator data. 

<br>
<br>

#### Data sources

| Filename | Source | Description |
|-------------|--------------------|-------------------------------------------|
| [cri.csv](https://github.com/nbreznau/CRI/blob/master/data/cri.csv) | [BRW Github Repo](https://github.com/nbreznau/CRI) | Model-level data containing specifications and effect outcomes |
| [cri_team.csv](https://github.com/nbreznau/CRI/blob/master/data/cri_team.csv) | [BRW Github Repo](https://github.com/nbreznau/CRI) | Team-level data with researcher characteristics aggregated by team, with individual-researcher data in wide-format by team |
| [peer_model_dyad.csv](https://doi.org/10.7910/DVN/UUP8CX) | [BRW Harvard Dataverse](https://doi.org/10.7910/DVN/UUP8CX) | Peer review scores by model |
| [cri_new_peer_scores.csv](https://github.com/nbreznau/ideology_specification/blob/main/data/cri_new_peer_scores.csv) | Authors calculations | Model-specific average peer scores, Generated in this workflow, see code files 001-002 in [data/data_prep](https://github.com/nbreznau/ideology_specification/tree/main/data/data_prep) |
| [cri_long_participant_ame_dyad.csv](https://github.com/nbreznau/ideology_specification/blob/main/data/cri_long_participant_ame_dyad.csv) | Authors calculations | Dyadic data with each participant-model combination within each team, so that teams with multiple participants have repeated observations of models per participant, see code file 003 in [data/data_prep](https://github.com/nbreznau/ideology_specification/tree/main/data/data_prep) | 
| [sem_p.csv](https://github.com/nbreznau/ideology_specification/blob/main/data/sem_p.csv) | [BRW Github Repo](https://github.com/nbreznau/CRI) | Original factor analysis based scoring of statistics skills and topic experience by team, generated in BRW's [002_CRI_Data_Prep.Rmd](https://github.com/nbreznau/CRI/blob/master/code/data_prep/002_CRI_Data_Prep.Rmd) code. |


*BRW = [Breznau, Rinke and Wuttke et al. 2022](https://www.pnas.org/doi/10.1073/pnas.2203150119)


<br>
<br>

#### Notes for users

Stata and R code runs in separate named files starting with numbers indicating the order in which they must be run (01_, 02_, etc.).

The main results were produced using Stata and can be found under [code/Stata Main Results](https://github.com/nbreznau/ideology_specification/tree/main/code/Stata_Main_Results). The log files are knitted into the folder `code/Log Files`. Note that users must install some ado's using 'ssc install', these commands are at the top of the .do files but commented out.

We used R to check the results and to produce the figures and this code is found in [code/R Robustness Results and Figures](https://github.com/nbreznau/ideology_specification/tree/main/code/R_Robustness_Results_and_Figures). The knitted files are also in the folder `code/Log Files` 


## Source Code For All Tables and Figures

### Figure 1
Code: 
/code/`R Robustness Results and Figures`/03_Fig1.Rmd

Results: 
/results/Fig1A.png, 
/results/Fig1B.png, 
/results/Fig1C.png, 
/results/Fig1B.png

### Figure 2
Code:
/code/`R Robustness Results and Figures`/03_Fig2.Rmd
Fig2B only in Stata:
/code/`Stata Main Results`/05_Expected_AME.do

Results:
/results/Fig2A.png
/results/Fig2B.png

### Figure 3
Code:
/code/`R Robustness Results and Figures`/03_Fig3.Rmd

Results:
/results/Fig3.png

### Table 1
Code:
/code/`Stata Main Results`/02_Main_Regs.do

Results:
/code/`Log Files`/02_Main_Regs.log

**Note that Table 1 draws the coefficients or linear combinations only, from the full models in Tables S2-S4**

### Table 2
Code:
/code/`Stata Main Results`/05_Expected_AME.do

Results:
/code/`Log Files`/05_Expected_AME.log

### Table S1
Code: 
/code/`Stata Main Results`/02_Main_Regs.do, or
/code/`R Robustness Results and Figures`/02_Tables.Rmd

Results:
/results/TableS1.csv, or
/code/`Log Files`/02_Main_Regs.log

### Table S2
Code:

### Table S3 & S4
Code: /code/`Stata Main Results`/02_Main_Regs.do

Results:
/code/`Log Files`/02_Main_Regs.log

### Table S5
Code: /code/`Stata Main Results`/03_Robustness.do

Results:
/code/`Log Files`/03_Robustness.log

### Tables S6-S9
Code: 
/code/`Stata Main Results`/03_Robustness.do

Results:
/code/`Log Files`/03_Robustness.log

### Table S10
Code:
/code/`Stata Main Results`/04_Dyads.do

Results:
/code/`Log Files`/04_Dyads.log

### Table S11 & S12
Code:
/code/`Stata Main Results`/05_Expected_AME.do

Results:
/code/`Log Files`/05_Expected_AME.log

Results:

### Figure S1 & S2
Code:
/code/`R Robustness Results and Figures`/03_Fig1.Rmd

Results:
/results/FigS1.png
/results/FigS2.png

### Figure S3
Code:
/code/`Stata Main Results`/03_Robustness.do
/code/`Stata Main Results`/03.1_Robustness_Dyad.do

Results:
/code/`Stata Main Results`/ideology_results.xlsx
/code/`Stata Main Results`/ideology_resultsd.xlsx
/code/`Log Files`/03_Robustness.log
/code/`Log Files`/03.1_Robustness_Dyad.log




