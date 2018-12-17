#---------------------------------------------------------------------#
#                   UDPipe NLP Workflow                               #
#---------------------------------------------------------------------#


library("shiny")
tags$style(type="text/css",
           ".shiny-output-error { visibility: hidden; }",
           ".shiny-output-error:before { visibility: hidden; }"
)

shinyUI(
  fluidPage(
  
    titlePanel("UDPipe NLP Workflow"),
  
    sidebarLayout( 
      
      sidebarPanel(  
        
              fileInput("txtfl", "Upload Sample Text File for Analysis in .txt format:"),
              fileInput("udpipfl", "Upload Trained UDPipe Model:"),
              checkboxGroupInput("checkGroup", label = h3("Speech Tags to be Selected"), 
                                 choices = list("Adjective(JJ)" = "JJ", "Noun(NN)" = "NN", "Proper Noun(NNP)" = "NNP", "Adverb(RB)" = "RB", "Verb(VB)" = "VB"),
                                 selected = c("JJ","NN","NNP")),
              selectInput("Language", label = h3("Select Language"), 
                          choices = list("English" = "English", "Spanish" = "Spanish","Hindi" = "Hindi", "Tamil" = "Tamil", "Dutch" = "Dutch", "German" = "German", "Other" = "Other"), 
                          selected = "English"),
              hr(),
              fluidRow(column(3, verbatimTextOutput("value"))),
              submitButton(text = "Apply Changes", icon("refresh"))),
      
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  tabPanel("Overview",
                           h4(p("Data input")),
                           p("This app supports only text files (.txt) data file.Please ensure that the text files are saved in UTF-8 Encoding format.",align="justify"),
                           p("Please refer to the link below for sample English text file."),
                           a(href="https://github.com/shob4ya/Shiny-App---UDPipe-NLP-Workflow/blob/master/LaLaLand.txt"
                             ,"Sample English input file"),   
                           br(),
                           p("Please refer to the link below for sample Hindi text file."),
                           a(href="https://github.com/shob4ya/Shiny-App---UDPipe-NLP-Workflow/blob/master/Hindi.txt"
                             ,"Sample Hindi input file"),   
                           br(),
                           p("Please refer to the link below for sample Spanish text file."),
                           a(href="https://github.com/shob4ya/Shiny-App---UDPipe-NLP-Workflow/blob/master/Espanol.txt"
                             ,"Sample Spanish input file"),   
                           br(),
                           p("Please refer to the link below for sample Tamil text file."),
                           a(href="https://github.com/shob4ya/Shiny-App---UDPipe-NLP-Workflow/blob/master/Thamizh.txt"
                             ,"Sample Tamil input file"),   
                           br(),
                           p("Please refer to the link below for sample German text file."),
                           a(href="https://github.com/shob4ya/Shiny-App---UDPipe-NLP-Workflow/blob/master/German.txt"
                             ,"Sample German input file"),   
                           br(),
                           h4('How to use this App'),
                           p('To use this app, click on', 
                             span(strong("Upload Sample Text File for Analysis in .txt format:"),
                             'and upload the text file, and also click on',
                             span(strong("Upload Trained UDPipe Model:"), 'and upload the UDPipe file.')))),
                  tabPanel("Co-Occurence Plot",plotOutput('plot1')),
                  tabPanel("Word Cloud",plotOutput('plot2')),
                  tabPanel("Data",p(span(strong('Unable to display Indian Regional Languages data unfortunately!!'))),textOutput('Text_Data'))
      ) # end of tabsetPanel
    )# end of main panel
  ) # end of sidebarLayout
)  # end of fluidPage
) # end of UI