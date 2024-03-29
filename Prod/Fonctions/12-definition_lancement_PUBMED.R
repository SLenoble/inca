
#-------------------------------------------------------#
#                                                       #
#       01-Traitements_fichiers_XML_PUBMED.R            #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#


Lancement_PUBMED <- function(stop_index_id=999999,reprise=FALSE) {
  
  ##
  # Utilisation du package {rentrez} : 
  #   1 - Recherches d'occurences de texte dans les publications
  #   2 - Telechargement des publications pubmed au format xml
  ##

  # 0 - Creation d'une log 
  journal("01-Traitements_fichiers_XML_PUBMED","01-Traitements_fichiers_XML_PUBMED")
  print(as.character(Sys.time()))
  
  # 1 - search id pubmed with NCT 
  r_search <- searchAPI(base_name= "pubmed", 
                        search_term= "(ClinicalTrials.gov[Secondary Source ID])",
                        opt_history= TRUE)
  
  saveRDS(r_search,paste0(chemin_output,"VERIFICATION/r_search",format(Sys.time(),"%Y%m%d%H%M%S"),".RDS"))
  
  # on définit la liste des id_a_charger
  if (reprise == FALSE) {
    id_a_charger <- r_search$ids
    # 6 - Suppression ----
    # suppression du fichier de suivi 
    if(file.exists(paste0(chemin_output, nom_fichier_suivi_id))){
      file.remove(paste0(chemin_output, nom_fichier_suivi_id))
    }
  } else {
    id_a_charger <- identification_id_a_charger()
  }

  print(paste0("1 - Recherche des publications pubmed : ",
               length(id_a_charger),
               " publications"))
  print(paste0("1 - Publications totales pubmed à charger : ",
               r_search$count,
               " publications"))
  
  # 2 - Telechargements des fichiers XML 
  # 3 - Traitements des fichiers XML 
  print("2 - Telechargement des publications : ")

  ## on bloque au max :
  if (stop_index_id == 999999) {stop_index_id <- length(r_search$ids)}

  full_traitements_xml(id_a_charger=id_a_charger,r_search=r_search,pos_id_start= start_index_id, pos_id_end= stop_index_id, by_nb_id= step_by_id)
  
  
  
  # 7 - Resume du suivi des telechargements ----
  # TO LOG 
  
  
  
  # # on définit récupère la liste desid chargé pour faire le bilan
  # if (reprise == FALSE) {
  #   suivi_id_fetch <- read.csv2(paste0(chemin_output, nom_fichier_suivi_id))
  #   
  # } else {
  #   suivi_id_fetch <- read.csv2(paste0(chemin_output, nom_fichier_suivi_id))
  #   #suivi_id_fetch_hist <- read.csv2(paste0(chemin_output, "Suivi_id_PUBMED_hist.csv"))
  #   
  #   #suivi_id_fetch <- rbind(suivi_id_fetch_hist,suivi_id_fetch)
  # }
  # 
  
  # [ajout]
  suivi_id_fetch <- read.csv2(paste0(chemin_output, nom_fichier_suivi_id))
  
  print("*** Suivi des téléchargements : ***")
  text <- paste0("Nombre de publications retenues : ", stop_index_id)
  print(text)
  
  
  nb_id_true_fetch <- suivi_id_fetch %>% 
    filter(fetch_id==TRUE) %>% 
    count(fetch_id) %>% 
    pull(n)
  text <- paste0("Nombre de publications téléchargées : ", nb_id_true_fetch)
  print(text)
  
  if(stop_index_id==length(suivi_id_fetch$recherche_id)){
    print("Pas de reprise à faire")
  }else{
    nb_id_false_fetch <- suivi_id_fetch %>% 
      filter(fetch_id==FALSE | is.na(fetch_id)) %>% 
      count(fetch_id) %>% 
      pull(n)
    text <- paste0("Nombre d'id PUBMED à reprendre : ", stop_index_id-nb_id_true_fetch)
    print(text)
  }
  
  
  # clean env ---- 
  rm(full_recs_xml_web)
  
  sink()

}
