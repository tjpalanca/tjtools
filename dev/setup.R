# Basic Information
golem::fill_desc(
  pkg_name          = "tjtools",
  pkg_title         = "TJ Tools",
  pkg_description   = "Random Tools built with Shiny",
  author_first_name = "TJ",
  author_last_name  = "Palanca",
  author_email      = "mail@tjpalanca.com",
  repo_url          = "https://github.com/tjpalanca/tjtools"
)

# Set golem options
golem::set_golem_options()

# Create common files
usethis::use_mit_license(name = "TJ Palanca")
usethis::use_readme_rmd(open = FALSE)
usethis::use_code_of_conduct()
usethis::use_lifecycle_badge("Experimental")
usethis::use_news_md(open = FALSE)

## Use git ----
usethis::use_git()

## Init Testing Infrastructure ----
## Create a template for tests
golem::use_recommended_tests()

## Use Recommended Packages ----
golem::use_recommended_deps()

## Favicon ----
# If you want to change the favicon (default is golem's one)
golem::remove_favicon()
golem::use_favicon() # path = "path/to/ico". Can be an online file.

## Add helper functions ----
golem::use_utils_ui()
golem::use_utils_server()

# You're now set! ----

# go to dev/02_dev.R
rstudioapi::navigateToFile( "dev/02_dev.R" )

