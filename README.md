# How to use `pagedown::chrome_print()` in a Shiny app?

<!-- badges: start -->
<!-- badges: end -->

This is a demo project to show how to use `pagedown::chrome_print()` in a Shiny application.

Using `pagedown::chrome_print()` in Shiny is not straightforward because:

- `async = TRUE` must be used
- in that case, `pagedown::chrome_print()` returns a promise
- using promises in Shiny is an advanced topic for many users  
  please, read <https://rstudio.github.io/promises/articles/shiny.html>

This app is deployed at this address <https://romain-lesur.shinyapps.io/chrome_print_shiny/>.

This demo app is the first step for writing a vignette on this topic (see <https://github.com/rstudio/pagedown/issues/114>).  

If you have any question, please ask on [RStudio Community](https://community.rstudio.com/) or [open an issue in **pagedown**](https://github.com/rstudio/pagedown/issues).
