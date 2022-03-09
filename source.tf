
locals {
  handler_extension = var.runtime == null ? "" : (
    length(regexall("^python.*", var.runtime)) > 0 ? "py" : (
      length(regexall("^node.*", var.runtime)) > 0 ? "js" : (
        length(regexall("^ruby.*", var.runtime)) > 0 ? "rb" : ""
      )
    )
  )

  handler_file = "index.${local.handler_extension}"
}


data "archive_file" "lambda_archive" {
  count                   = local.use_file ? 1 : 0
  type                    = "zip"
  output_path             = "${path.module}/${var.name}.zip"
  source_content          = var.function_source
  source_content_filename = local.handler_file
}
