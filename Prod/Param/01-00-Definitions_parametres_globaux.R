
#-------------------------------------------------------#
#                                                       #
#    01-00-Definitions_parametres_globaux.r             #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#



# LIBRAIRIES ----
library(rentrez)
library(XML)
library(xml2)
library(data.table)
library(dplyr)
library(tidyr)
library(glue)
library(stringr)


##
# GLOBAL PATH ----
##

# chemin LOG ----
chemin_log <- "Prod/Log/"

# chemin fonctions ----
chemin_fonctions <- "Prod/Fonctions/"

# pour chargement des fonctions en memoire
file_sources = list.files(pattern="*\\.R", path = chemin_fonctions, full.names = TRUE)

#  chemin OUTPUT  ----
chemin_output <- "Prod/Output/"

# chemin temps traitement ----
chemin_tps_traitment <- paste0(chemin_output, "temps_traitement/")

# chemin INPUT ----
chemin_input <- "Prod/Input/"

#  chemin scripts ----
chemin_script <- "Prod/Script/"

#-------------------------------------------------------#
#                                                       #
#                    PUBMED                             #
#                                                       #
#-------------------------------------------------------#

# PUBMED ----

# chemin output export RDS ----
chemin_pubmed_rds <- paste0(chemin_output, "pubmed_rds/")

#  03-definition_fonction_fetchAPI ----
  # nombre de publications xml par fichier en sortie (le pas)
step_by_id = 200# 999

  # index positions pour les id
start_index_id = 1
stop_index_id = 1000# 114000 ## ne pas mettre de paramètre de nombre max de fichier à récupérer


#  05-definition_fonction_test_id_fetch ----
nom_fichier_suivi_id <- "Suivi_id_PUBMED.csv"

#  07-definition_foctions_check_xml ----
nom_fichier_suivi_nct <- "Suivi_id_PUBMED_NCT.csv"


##
# BALISES
##

chemin_fonctions_balises <-  paste0(chemin_fonctions, "balises/")

# pour chargement des fonctions en memoire
fonctions_source_balises = list.files(pattern="*\\.R", path = chemin_fonctions_balises, full.names = TRUE)

# chemin output balises RDS
chemin_output_balises <- paste0(chemin_output, "balises_rds/")

## on definit le taux de présence pour que la balise soient significatives
tx_balise_NS <- 0.001

#-------------------------------------------------------#
#                                                       #
#                    MESH                               #
#                                                       #
#-------------------------------------------------------#

# MESH ----
# chemin output mesh RDS ----
chemin_mesh_rds <- paste0(chemin_output, "mesh_rds/")

# 02-Traitements_fichiers_XML_MESH ----
  # nombre de fichier par lot pour export RDS
max_mesh <- 10

# fichiers mesh test ----
nom_fic_mesh <- "desc2022.xml"

# noms balises mesh ----

# lot_mesh <- readRDS("Prod/Output/mesh_rds/mesh_lot_1.RDS")
# noms_balises_simples_mesh <- lot_mesh %>% group_by(id_mesh, Nom_balise) %>% 
#   count() %>% 
#   filter(n==1) %>% 
#   pull(Nom_balise) %>% 
#   unique
# 
# noms_balises_simples_mesh <- data.frame(nom_balise= noms_balises_simples_mesh)
# write.csv2(noms_balises_simples_mesh, file = "Prod/Param/nom_balises_simples_mesh.csv", row.names = FALSE, col.names = TRUE)

noms_balises_simples_mesh <- read.csv2("Prod/Param/nom_balises_simples_mesh.csv")



#-------------------------------------------------------#
#                                                       #
#                    MESH TREES                         #
#                                                       #
#-------------------------------------------------------#

# MESH TREES ----
nom_fichier_mesh_trees <- "mtrees2022.bin"

# chemin output mesh trees ----
chemin_output_trees <- paste0(chemin_output, "mesh_trees/")


#-------------------------------------------------------#
#                                                       #
#                    REPRISE                            #
#                                                       #
#-------------------------------------------------------#

# REPRISE ----

#  chemin fonctions reprise ----
chemin_fonctions_reprise <- paste0(chemin_fonctions, "REPRISE/")

# chemin output reprise ----
chemin_output_reprise <- paste0(chemin_output, "REPRISE/")

# pour chargement des fonctions en memoire
file_sources_reprise = list.files(pattern="*\\.R", path = chemin_fonctions_reprise, full.names = TRUE)

# nom fichier suivi reprises
nom_fichier_reprises_id <- "Suivi_id_reprise.csv"
