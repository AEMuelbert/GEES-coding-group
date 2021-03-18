# This is where you write your drake plan.
# Details: https://books.ropensci.org/drake/plans.html

plan <- drake_plan(


  iris_data = file_in("test.RDS"),
  # getting data ---------------------------
  all_sites = data.frame(site = c("Vancouver", "Jasper", "Calgary", "Saskatoon"),
                         lat = c(49.26, 52.87, 51.04, 52.16),
                         lon = c(-123.10, -118.08, -114.07, -106.67),
                         stringsAsFactors = FALSE),

  daymet_data = download_daymet_data(all_sites,start = 1990, end = 2016),

  # cleaning data --------------------
  daymet_clean = clean_data(dframe = daymet_data),

  # figures --------------------------
  plot_all_sites = plot_daymet_figures(dframe = daymet_clean,
                                       msmt = "tmax..deg.c."),

  plot_june_models = plot_daymet_june_temp_models(daymet_clean),



  # reporting ---------------------------
  final_paper = rmarkdown::render(knitr_in("report.Rmd"),
                                  output_file = file_out("report.html"),
                                  quiet = TRUE)
)
