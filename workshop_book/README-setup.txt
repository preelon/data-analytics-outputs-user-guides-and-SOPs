NMEP WORKSHOP BOOK TEMPLATE — SETUP NOTES

1. Extract the 'workshop_book' folder into:
   C:/Users/yogas/Documents/Enku/R project/hmis_preprocessing/

   It should sit beside _quarto.yml, bulletin/, dashboard/, and
   digital data collection tool/.

2. Open the existing hmis_preprocessing RStudio project.

3. In RStudio, confirm that getwd() returns the hmis_preprocessing
   project root.

4. Open workshop_book/_quarto.yml and review the title, author,
   chapters, and PDF settings.

5. Copy the actual contents of the existing guides into:
   - workshop_book/02-bulletin.qmd
   - workshop_book/03-dashboard.qmd
   - workshop_book/04-irs-digital-tool.qmd

   Preserve the original code and order. Remove or adapt the original
   document-level YAML headers where necessary; retain useful headings,
   code chunks, tables, figures, and explanations.

6. IMPORTANT: The book project executes code from the workshop_book
   directory. Review all relative file paths in copied code. Paths may
   need to point to parent project folders, for example ../data/filename.csv.
   Do not blindly replace paths; verify each one.

7. PDF rendering requires a LaTeX installation. From the RStudio
   Console, install TinyTeX once if needed:
     system2(quarto::quarto_path(), args = c("install", "tinytex"))

   This is a one-time setup. Restart RStudio if the installer asks you to.

8. Source the rendering script from the main project root:
     source("workshop_book/render_book.R")

   Then render:
     render_workshop_book()

9. The PDF and other book outputs will be in:
   workshop_book/_book/

10. The book's global execute: eval: false setting means code is shown
    in the PDF but is not executed during PDF production. Participants
    execute the code during the workshop. Add verified screenshots or
    expected outputs where useful.

11. Keep the existing website project and its docs/ output separate.
    Do not change the main project's _quarto.yml from type: website.
