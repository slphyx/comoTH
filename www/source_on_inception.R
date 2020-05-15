library(bsplus)
library(deSolve)
library(DT)
library(highcharter)
library(lubridate)
library(pushbar)
library(readxl)
library(reshape2)
library(scales)
library(shiny)
library(shinyBS)
library(shinycssloaders)
library(shinyhelper)
library(shinythemes)
library(shinyWidgets)
library(tidyverse)


load(file = "./www/data/cases.Rda")
load(file = "./www/data/contacts.Rda")
load(file = "./www/data/demog.Rda")
load(file = "./www/data/mort_sever_default.Rda")

load(file = "./www/data/casesprv.RData")

# choices of countries for dropdown
countries_cases <- sort(unique(cases$country))
countries_contact <- names(contact_home)
countries_demographic <- sort(unique(population$country))

provinces_cases <- sort(unique(as.character(casesprv$province)))

# options for exporting highchart
hc_export_items <- c("downloadPNG", "downloadCSV", "downloadXLS")


# from pop - pop from each age group  --> pop/sum(pop)
THpopstruc_frac <- c(
0.0515193859, 0.0550684987, 0.0589370530, 0.0627293321, 0.0688811678, 0.0690889043, 0.0639927709,
0.0682383166, 0.0760579036, 0.0803068591, 0.0802142516, 0.0728143639, 0.0625738449, 0.0466576508,
0.0326982625, 0.0226967120, 0.0153425836, 0.0080756902, 0.0032263334, 0.0007545275, 0.0001255874
)

THpopstruc <- c(
    3596052, 3843780, 4113805, 4378506, 4807904, 4822404, 4466694, 4763033, 5308840, 5605417, 5598953,5082441,
    4367653, 3256703, 2282338, 1584230, 1070912,  563683,  225198,   52666, 8766
)

# x=(pop from each province / total pop of TH)
# x/sum(x)
THprv_frac <- c(
0.00579126,0.00389485,0.0870993,0.00555611,0.0243823,0.010873,0.00505017,0.0147636,
0.00818602,0.0266053,0.0197217,0.0231144,0.00716505,0.0151021,0.0122132,0.0136007,
0.026681,0.0071952,0.0114345,0.00632173,0.00982805,0.0115987,0.00427464,0.0147508,
0.00537274,0.0039722,0.0139608,0.0109976,0.038689,0.0163171,0.0238551,0.00734942,
0.0121956,0.00783653,0.00702676,0.0188352,0.017294,0.0108716,0.00409701,0.00803895,
0.00730748,0.0152449,0.00738828,0.00839712,0.0132544,0.00685509,0.0124653,0.00615748,
0.00746745,0.00833183,0.00291624,0.0133516,0.0108936,0.0200326,0.00851535,0.0176058,
0.0200763,0.00870687,0.00284218,0.00983378,0.00489667,0.0032178,0.0161739,0.0218142,
0.00917944,0.0130497,0.0161984,0.0213998,0.00986789,0.00984958,0.00351741,0.0286362,
0.0242474,0.00505354,0.00700103,0.00807629,0.00826387
)

THprv_frac <- data.frame(province = provinces_cases,frac=THprv_frac)
