# Custom functions are an important part of a drake workflow.
# This is where you write them.
# Details: https://books.ropensci.org/drake/plans.html#functions

#' Site-level daymet download
#'
#' Uses `daymetr::download_daymet()`
#'
#' @param sites_df data.frame containing columns site, lat and lon
#' @param start numeric, start year
#' @param end numeric, end year
#' @param ... other arguments to `download_daymet()`
#'
#' @return a data.frame with requested
#' @export
#'
download_daymet_data <- function(sites_df, start, end, ...){

    # checks ...

    # execute ...
    downloaded_data <- purrr::pmap_dfr(sites_df,
                                      daymetr::download_daymet,
                                      start = start,
                                      end = end-2,
                                      internal = TRUE,
                                      simplify = TRUE,
                                      ...)

    return(downloaded_data)

}



#' Adjust daymet downloads
#'
#' @param dframe data.frame of daymet downloads
#'
#' @return data.frame with adjusted columns/data
#' @export
#'
clean_data <- function(dframe){

    cleaned <- dframe %>%
        mutate(date = as.POSIXct(
            strptime(
                paste(year, yday),
                format = "%Y %j"))
            )

    return(cleaned)

}



#' Make env plots
#'
#' @param dframe data.frame of daymet downloads
#'
#' @return ggplot object
#' @export
#'
plot_daymet_figures <- function(dframe, msmt){

    plot_df <- dframe %>%
        dplyr::filter(measurement == msmt)


        ggplot(plot_df,
               aes(x = date, y = value, color = site)) +
        geom_line() +
        facet_wrap(~site) +
        theme_bw()

}


#' Make trend plots
#'
#' @details Ideally, data generation and plotting should be separated
#'
#' @param dframe data.frame of daymet downloads
#'
#' @return ggplot object
#' @export
#'
plot_daymet_june_temp_models <- function(dframe){


    plot_df <- dframe %>%
        mutate(month = lubridate::month(date)) %>%
        dplyr::filter(measurement == "tmax..deg.c.",
                      month == 6) %>%
        dplyr::group_by(site, year, month) %>%
        dplyr::summarise(mean_value = mean(value, na.rm = TRUE),
                         date = mean(date))


    ggplot(plot_df,
           aes(x = date, y = mean_value, color = site)) +
        geom_point() +
        geom_smooth(method = "lm") +
        theme_bw() +
        labs(title = "Trendyyyy!")


}
