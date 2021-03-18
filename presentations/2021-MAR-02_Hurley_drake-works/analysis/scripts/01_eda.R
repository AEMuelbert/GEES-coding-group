# checking results

library(dplyr)
library(drake)

drake::r_make() # when interactive, or when the vis graph is not important
# alternative: source("make.R") # execute steps, but ideally restart R Session
# drake::r_make() is safer, as it starts a new R session in the background

source("R/functions.R")
source("R/plan.R")

drake::outdated(plan)
drake::vis_drake_graph(plan)


# check individual targets
loadd(daymet_data)
daymet_data %>% str()
daymet_data$measurement %>% unique()


loadd(daymet_clean)
colnames(daymet_clean)
daymet_clean$date %>% head()


readd(plot_all_sites) # readd "executes" automatically
readd(plot_june_models) # readd "executes" automatically
