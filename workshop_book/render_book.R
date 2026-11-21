# Run this script from the RStudio Console after opening the
# hmis_preprocessing project at its root directory.

render_workshop_book <- function() {
  project_root <- getwd()
  book_dir <- file.path(project_root, "workshop_book")

  if (!dir.exists(book_dir)) {
    stop(
      "Cannot find the workshop_book folder. ",
      "Open the hmis_preprocessing RStudio project and run this function from its root."
    )
  }

  old_wd <- getwd()
  on.exit(setwd(old_wd), add = TRUE)
  setwd(book_dir)

  # Use the native ARM64 R installation and its package library for Quarto.
  Sys.setenv(
    QUARTO_R = "C:/Program Files/R-aarch64/R-4.6.1/bin/Rscript.exe",
    R_LIBS_USER = "C:/Users/yogas/R/win-library/4.6",
    R_LIBS_SITE = "",
    R_LIBS = ""
  )

  status <- system2(
    quarto::quarto_path(),
    args = "render",
    stdout = "",
    stderr = ""
  )

  if (!identical(status, 0L)) {
    stop("Quarto book rendering failed. Review the messages above.")
  }

  message("Workshop book rendered. Check workshop_book/_book for the PDF.")
  invisible(file.path(book_dir, "_book"))
}

# After sourcing this file, render with:
# render_workshop_book()
