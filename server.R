#reactive means that shiny app is always waiting and listening for user input.
#render works for processing while reactive works for data
#ui.r, server.r and app.r all need to be in the same folder location.


shinyServer(function(input, output) {
  set.seed=2092014  
  options(shiny.maxRequestSize=30*1024^2)
  TxtFil <- reactive({
    
    if (is.null(input$txtfl)) {   # locate 'txtfl' from ui.R
      
                  return(NULL) } else{
      Data1 <- readLines(input$txtfl$datapath,encoding = "UTF-8")
      return(Data1)
    }
  })
  ANText <- reactive({
    
    if (is.null(input$udpipfl)) {   # locate 'udpipfl' from ui.R
      
      return(NULL) } else{
        
        modelfl <- udpipe_load_model(file = input$udpipfl$datapath)
        antxt <- udpipe_annotate(modelfl, x = as.character(TxtFil()))
        antxt <- as.data.frame(antxt)
        return(antxt)
      }
  })
# Calc and render plot    
  output$plot1 = renderPlot({
    inputText <-  as.character(TxtFil())
    model = udpipe_load_model(file=input$udpipfl$datapath)
    x <- udpipe_annotate(model, x = inputText, doc_id = seq_along(inputText))
    x <- as.data.frame(x)
    if (input$Language == "English"){
      co_occ <- cooccurrence(   	# try `?cooccurrence` for parm options
        x = subset(x, x$xpos %in% input$checkGroup), term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
    }
    else{
      checkOpt <- input$checkGroup
      for(i in seq_len(length(input$checkGroup))){
        if (input$checkGroup[i] == "JJ"){
          checkOpt[i] <- "ADJ"
        }
        else if (input$checkGroup[i] == "NN"){
          checkOpt[i] <- "NOUN"
        }
        else if (input$checkGroup[i] == "NNP"){
          checkOpt[i] <- "PROPN"
        }
        else if (input$checkGroup[i] == "RB"){
          checkOpt[i] <- "ADV"
        }
        else{
          checkOpt[i] <- "VB"
        }
      }
      co_occ <- cooccurrence(   	# try `?cooccurrence` for parm options
        x = subset(x, x$upos %in% checkOpt), term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
    }
    wordnetwork <- head(co_occ, 75)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
    windowsFonts(devanew=windowsFont("Devanagari new normal"))
    suppressWarnings(ggraph(wordnetwork, layout = "fr") +  
                       
                       geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
                       geom_node_text(aes(label = name), col = "darkgreen", size = 6) +
                       
                       theme_graph(base_family = "Arial Unicode MS") +  
                       theme(legend.position = "none") +
                       
                       labs(title = "Cooccurrence Plot", subtitle = "Speech TAGS as chosen"))
  })
  output$plot2 = renderPlot({
    inputText <-  as.character(TxtFil())
    model = udpipe_load_model(file=input$udpipfl$datapath)
    x <- udpipe_annotate(model, x = inputText, doc_id = seq_along(inputText))
    x <- as.data.frame(x)
    if (input$Language == "English"){
      all_words = x %>% subset(., xpos %in% input$checkGroup);
    }
    else{
      checkOpt <- input$checkGroup
      for(i in seq_len(length(input$checkGroup))){
        if (input$checkGroup[i] == "JJ"){
          checkOpt[i] <- "ADJ"
        }
        else if (input$checkGroup[i] == "NN"){
          checkOpt[i] <- "NOUN"
        }
        else if (input$checkGroup[i] == "NNP"){
          checkOpt[i] <- "PROPN"
        }
        else if (input$checkGroup[i] == "RB"){
          checkOpt[i] <- "ADV"
        }
        else{
          checkOpt[i] <- "VB"
        }
      }
      all_words = x %>% subset(., upos %in% checkOpt);
    }
    top_words = txt_freq(all_words$lemma)
    wordcloud(words = top_words$key, 
              freq = top_words$freq, 
              min.freq = 2, 
              max.words = 100,
              random.order = FALSE, 
              colors = brewer.pal(6, "Dark2"))
  })
  output$Text_Data = renderText({
    inputText <-  as.character(TxtFil())
    inputText
  })
})
