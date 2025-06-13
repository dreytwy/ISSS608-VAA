# extract_and_save_rds_from_prototype.R

# Create target folder if not exist
if (!dir.exists("rds_objects")) dir.create("rds_objects")

# Render or source the .qmd (assumes it's R Markdown compatible)
rmarkdown::render("Prototype.qmd", output_format = "html_document")

# Safe save function
safe_save <- function(obj, name) {
  tryCatch({
    saveRDS(obj, file = file.path("rds_objects", paste0(name, ".rds")))
    message("Saved: ", name)
  }, error = function(e) {
    message("Failed to save ", name, ": ", e$message)
  })
}

# Loop through all objects in the global env
objs <- ls(envir = .GlobalEnv)
for (obj_name in objs) {
  obj <- get(obj_name, envir = .GlobalEnv)
  if (inherits(obj, c("gg", "ggraph", "plotly", "visNetwork", "leaflet", "highchart"))) {
    safe_save(obj, obj_name)
  }
}
