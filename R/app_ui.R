#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny shinyWidgets
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    #Your application UI logic
    fluidPage(
      titlePanel("Retirement Location"),
      sidebarLayout(
        # Sidebar ----
        sidebarPanel(width = 3,
                     fluidRow(
                       h1("Criteria"),
                     ## Input: State ----
                     pickerInput("stname", "State:",
                                 choices = sort(unique(retirementLoc$stname)),
                                 selected = unique(retirementLoc$stname),
                                 multiple = T,
                                 options = list(
                                   `actions-box` = TRUE,
                                   `deselect-all-text` = "None",
                                   `select-all-text` = "All",
                                   `none-selected-text` = "zero"
                                 )
                      ),
                     ## Input: Population  ----
                     sliderInput("pop_2020", "2020 Population:",
                                 min = min(retirementLoc$pop_2020),
                                 max = max(retirementLoc$pop_2020),
                                 value = c(87, 9943046)
                      ),
                     ## Input: Population Change  ----
                     sliderInput("pct_pop_change", "% Pop. Change 2010 to 2020:",
                                 min = min(retirementLoc$pct_pop_change, na.rm = T),
                                 max = max(retirementLoc$pct_pop_change, na.rm = T),
                                 value = c(-33.3, 139.7)
                      )
                    )
        ),
        # Main ----
        mainPanel("main panel",
                  mod_table_ui("table_ui_1")
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'retirement'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

