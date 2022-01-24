#-------------------------------------------------------#
#                                                       #
#              01-MAIN_Traitements.R                    #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#



#-------------------------------------------------------#
#                                                       #
#              BLOC : INIT                              #
#                                                       #
#-------------------------------------------------------#

# 1 - Chargement des variables globales (parametres) ----
source("Prod/Param/01-00-Definitions_parametres_globaux.R")

# 2 - Chargement des fonctions externes ----
sapply(file_sources,source)
sapply(fonctions_source_balises, source)


#-------------------------------------------------------#
#                                                       #
#              BLOC : PUBMED                            #
#                                                       #
#-------------------------------------------------------#


# 3 - Traitements fichiers XML PUBMED ----
  # debut timer du programme

  # 3.1 on charge l'ensemble des balises
  ## chargement des 70k premiers dossiers car à partir de 77k on a systématiquement une erreur
    ## ==> on fait en 2 fois
  temps <- as.data.frame(Sys.time())
  write.table(temps,file=paste0(chemin_tps_traitment,'01-Chargement_fichiers_XML_PUBMED_heure_debut.txt'), col.names = TRUE, row.names = FALSE)  

  Lancement_PUBMED(stop_index_id = stop_index_id, reprise = FALSE)
  Lancement_PUBMED(stop_index_id = 999999,reprise = TRUE)

  
  # fin timer du programme
  temps <- as.data.frame(Sys.time())
  write.table(temps,file=paste0(chemin_tps_traitment,'01-Chargement_fichiers_XML_PUBMED_heure_fin.txt'), col.names = TRUE, row.names = FALSE) 
  
  # 3.2 on vérifie si on a bien intégrer toutes les publications et si certaines ont "disparu"

    # 3.2.1 : les publications non intégrées
    liste_id_a_charger <- identification_id_a_charger()
    print("Nombre de publications restant à intégrer :")
    print(length(liste_id_a_charger))
    ## si > 0 : on lance le script de relance ci-dessous :
    
    # [ajout] le test et condition si lancement
    if(length(liste_id_a_charger) >0)
      Lancement_PUBMED(stop_index_id = 999999,reprise = TRUE)
  
    # 3.2.2 : les publications qui ne sont plus présentes
    liste_plus_present <- identification_id_plus_present()
    print("Nombre de publications qui ne sont plus présentes :")
    print(length(liste_plus_present))
    ## si > 0 : on lance le script de nettoyage ci-dessous :
    suppression_id_plus_acharger()
  
    ## 3.2.3 : les publications en doublons
    liste_doublons <- identification_id_doublons()
    print("Nombre de publications chargées plusieurs fois:")
    print(nrow(liste_doublons))
    ## si > 0 : on lance le script de nettoyage ci-dessous :
    suppression_en_doublons()
  # 3.3 on sort les informations pour identifier les balises simples ou à retravailler
    comptage_balise (nom_chemin = chemin_pubmed_rds,
                     id_fic =  "id_pubmed",
                     nom_output = "cpt_balises_pubmed")
  # 3.4 on sépare les données et on les remonte sous PostGre
    




#-------------------------------------------------------#
#                                                       #
#              BLOC : MESH                              #
#                                                       #
#-------------------------------------------------------#


# 4 - Traitements fichiers XML MESH (referentiel) ----

  # 4.1 on charge l'ensemble des fichiers mesh (par paquet définit dans les paramètres)
    temps <- as.data.frame(Sys.time())
    write.table(temps,file=paste0(chemin_tps_traitment,'02-Traitements_fichiers_XML_MESH_heure_debut.txt'), col.names = TRUE, row.names = FALSE)  
    
    source(paste0(chemin_script, "02-Traitements_fichiers_XML_MESH.R"))

    temps <- as.data.frame(Sys.time())
    write.table(temps,file=paste0(chemin_tps_traitment,'02-Traitements_fichiers_XML_MESH_heure_fin.txt'), col.names = TRUE, row.names = FALSE)

  # 4.2 on vérifie si on a bien intégrer tous les mesh
    # à écrire
    
  # 4.3 on sort les informations pour identifier les balises simples ou à retravailler
    comptage_balise (nom_chemin = chemin_mesh_rds,
                     id_fic = "id_mesh",                     
                     nom_output = "cpt_balises_mesh")


  # 4.4 on sépare les données et on les remonte sous PostGre


#-------------------------------------------------------#
#                                                       #
#              BLOC : MESH TREES                        #
#                                                       #
#-------------------------------------------------------#

# 5 - Traitements MESH TREES ----
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'03-Traitements_MESH_TREES_heure_debut.txt'), col.names = TRUE, row.names = FALSE)  

source(paste0(chemin_script, "03-Traitements_MESH_TREES.R"))

temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'03-Traitements_MESH_TREES_heure_fin.txt'), col.names = TRUE, row.names = FALSE)




#-------------------------------------------------------#
#                                                       #
#              BLOC : BALISES                           #
#                                                       #
#-------------------------------------------------------#

# 6 - Traitements Balises ----
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'04-Traitements_balises_heure_debut.txt'), col.names = TRUE, row.names = FALSE)  

source(paste0(chemin_script, "05-Traitements_BALISES.R"))

temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'04-Traitements_balises_heure_fin.txt'), col.names = TRUE, row.names = FALSE)




# reset output log ----
sink()