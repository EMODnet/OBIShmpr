#' Create data roxygen documentation
#'
#' @param dataset_name character string. variable name
#' @param dataset_title character string. Dataset title
#' @param description character string. Dataset description
#' @param source_url character string. Dataset source URL
#' @param format character string. Dataset format
#' @param data data.frame of data being documented
#'
#' @return a format description string
#' @export
#'
#' @examples
use_data_roxygen <- function(dataset_name, dataset_title, description, 
                             source_url = "https://example.com",
                             format = "tibble", data){
    
    usethis::use_template("data-r-template.R", 
                          fs::path("R", glue::glue("{dataset_name}.R")), 
                          data = list(dataset_title= dataset_title, 
                                      description = description,
                                      format = data_format(format, data), 
                                      source_url = source_url_format(source_url), 
                                      dataset_name = dataset_name), 
                          package = "OBIShmpr")
    
    devtools::document(roclets = 'rd')
    devtools::install(quick = TRUE)
    
}

data_format <- function(format = "tibble", data){
    glue::glue("A {format} of {ncol(data)} variables and {nrow(data)} observations")
}
source_url_format <- function(source_url){
    paste0("\\", "url\\{", source_url, "\\}")
    }
