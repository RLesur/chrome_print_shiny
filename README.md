# How to use `pagedown::chrome_print()` in a Shiny app?

<!-- badges: start -->
<!-- badges: end -->

This is a demo project to show how to use `pagedown::chrome_print()` in a Shiny application.

Using `pagedown::chrome_print()` in Shiny is not straightforward because:

- `async = TRUE` must be used
- in that case, `pagedown::chrome_print()` returns a promise
- using promises in Shiny is an advanced topic for many users

This demo app is the first step for writing a vignette on this topic (see <https://github.com/rstudio/pagedown/issues/114>). 
