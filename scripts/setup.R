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

# Development Options
usethis::use_git()

# Testing infrastructure
golem::use_recommended_tests()

# Use recommended packages
golem::use_recommended_deps()

# Favicon
golem::remove_favicon()
golem::use_favicon("../tjblog/static/images/favicon.png")
