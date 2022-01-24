
read_file_by_line <- function(dir_input, file_input){
  
  data_lines = ""
  
  if(dir.exists(dir_input)){
    input_fullname = paste0(dir_input,file_input)
    if(file.exists(input_fullname)){
      con = file(input_fullname, "r", blocking = FALSE)
      data_lines = readLines(con)
      close(con)
    }else{
      print("Le fichier n'existe pas dans le répertoire donné en entrée.")
    }
  }else{
    print("Le répertoire donné en entrée n'existe pas.")
  }
  
  return(data_lines)
}


write_file_by_line <- function(data, dir_output, file_output){
  
  if(dir.exists(dir_output)){
    output_fullname = paste0(dir_output,file_output)
    con = file(output_fullname, "w", blocking = FALSE)
    writeLines(data, con = con, sep = "", useBytes = FALSE)
    close(con)
  }
  
}

generate_pairs <- function(d_lines,BLOCK_SIZE,TAG_TO_DETECT){
  
  consecutive_pairs = list()
  
  len_d_lines = length(d_lines)
  # Détection de la balise TAG_TO_DETECT
  idx_start_tag = which(d_lines %in% TAG_TO_DETECT)
  len_start_tag = length(idx_start_tag)
  
  if(len_start_tag >= BLOCK_SIZE){
    idx_start_tag_by_block = c(idx_start_tag[seq(1,len_start_tag,BLOCK_SIZE)],len_d_lines)
  }else if(len_start_tag < BLOCK_SIZE && len_start_tag > 0){
    idx_start_tag_by_block = c(min(idx_start_tag), len_d_lines)
  }
  
  consecutive_pairs = Map(c,idx_start_tag_by_block[-length(idx_start_tag_by_block)], idx_start_tag_by_block[-1])
  
  return(consecutive_pairs)
}


generate_xml_splitted <- function(d_lines, pair, dir_output, file_output,HEADER_TAG,FOOTER_TAG){
  
  unlist_pair = unlist(pair)
  from = unlist_pair[1]
  to = unlist_pair[2] - 1
  d_lines_filtered = d_lines[from:to]
  xml_data = paste(HEADER_TAG, paste(d_lines_filtered, collapse = '\n'), FOOTER_TAG, sep = "\n")
  write_file_by_line(xml_data, dir_output, file_output)
  
}


generate_xml_splitted_by_loop <- function(d_lines, del_pairs, dir_output,HEADER_TAG,FOOTER_TAG){
  
  lapply(1:length(del_pairs), 
         FUN = function(i){
           print(paste("Fichier :",i))
           generate_xml_splitted(d_lines, del_pairs[i], dir_output, paste0("split_part_",i,".xml"),HEADER_TAG,FOOTER_TAG)
         }
  )
  
}


run_xml_splitter <- function(dir_input, file_input, dir_output,BLOCK_SIZE,TAG_TO_DETECT,HEADER_TAG,FOOTER_TAG){
  
  print("Lecture des données")
  xml_lines = read_file_by_line(dir_input, file_input)
  
  print("Génération des paires")
  delimiter_pairs = generate_pairs(xml_lines,BLOCK_SIZE,TAG_TO_DETECT)
  
  print(paste(length(delimiter_pairs),"fichiers à générer"))
  print("Split des données et écriture dans un .xml spécifique")  
  generate_xml_splitted_by_loop(xml_lines, delimiter_pairs, dir_output,HEADER_TAG,FOOTER_TAG)
  
}
