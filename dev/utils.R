# Required libraries
require(golem)
require(usethis)

# Development functions
dnr <- function(preload = FALSE, reset = FALSE) {
    if (preload){
        devtools::load_all()
    }
    if (reset) {
        golem::detach_all_attached()
        rm(list=ls(all.names = TRUE))
    }
    devtools::document()
    devtools::load_all()
}

run <- function(dnr = TRUE, prod = FALSE) {
    if (dnr) dnr()
    options(golem.app.prod = prod)

}
