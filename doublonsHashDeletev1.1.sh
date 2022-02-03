#!/bin/bash
########################################################################################################
#                                                                                                      #
#                                  RECHERCHE DE DOUBLONS DANS UN DOSSIER                               #
#                                         SUPPRESSION DES DOUBLONS                                     #
#                                                                                                      #
#                                                                                                      #
########################################################################################################
# 
VERSION="V_1.1"
MAJ="2019/04/11"
AUTHOR="By_yakisyst3m"
#
###################################   NOTICE d'Uutilisation  ###########################################
#
# Lancer le script de cette façon : ./doublonsHash.sh <chemin du dossier contenant les photos>
# exemple : 
#			./doublonsHash.sh /home/user/Images/A_trier/
#
#####################################   LA CONFIGURATION  ##############################################

# Chemins d'accès des fichiers temporaires
PATHVERSTMP="/tmp"
LI_F_SCANNES=$PATHVERSTMP"/scannedfiles.tmp"
LI_D_SCANNES=$PATHVERSTMP"/scanneddir.tmp"

# Séparateur la Tabulation
SEP="\t"

# Compteur de fichiers supprimés
COMPTEUR_FICHIERS=0

# Création des fichiers temporaires et leurs droits
touch $LI_F_SCANNES
chmod 777 $LI_F_SCANNES
touch $LI_D_SCANNES
chmod 777 $LI_D_SCANNES

############################   FONCTIONS : TRAITEMENT DFES FICHIERS   ##################################

function supprimerTMP() 
{
	rm -f "$PATHVERSTMP/"*.tmp
}

function verifierFichier() 
{	
	FichierEnCours="$(pwd)/$i" # Chemin du fichier analysé
		
	if [[ -f "$FichierEnCours" ]] # Si le fichier existe
	then
		HASH=$(md5sum $FichierEnCours) # Faire le Hash du fichier
		
		if [[ ! -z "$(grep $HASH $LI_F_SCANNES)" ]] # Si le hash existe dans le fichier qui liste les hash et chemin
		then 
			rm -f $FichierEnCours					# Supprimer le fichier
			echo -e "-------------------\n[ Suppression du fichier : ] $FichierEnCours \n-------------------"
			((COMPTEUR_FICHIERS++))
		else
			echo "$HASH$SEP$FichierEnCours" >> $LI_F_SCANNES # Sinon lister le hash et son chemin dans le fichier
		fi
	fi
}

#####################################   DEBUT DU PROGRAMME  ##########################################

# On appelle un argument après l'appelle du script, celui-ci représente le dossier de recherche
cd $1

##### On remplace tous les espaces des noms de fichiers par des underscore
find ./ -name "* *" -type f -exec rename -v 's/\ /_/g' {} \;

# Parcourir les fichiers du répertoire 1 à 1
ListeFichiersEtDossiers=$(ls)

for i in $ListeFichiersEtDossiers
do
	verifierFichier $i
	echo "$i"
done 

# On supprime les fichiers temporaires
supprimerTMP

#######################################      MEMO     #################################################

	
# IFS=';' read -r -a monArray <<< "tonton;marraine;maman"; echo "${monArray[2]}"

#############################  RESULTATS DANS TERMLINAL ########################################

echo -e "o=======================================================================================o"
echo -e "|\t\t\t\t |\   /| 						|"
echo -e "|\t\t\t\t  \|_|/  						|"
echo -e "|\t\t\t\t  /. .\ 						|"
echo -e "|\t\t\t\t =\_Y_/= 						|"
echo -e "|\t\t\t\t  {>o<}  				---------------------------------\n|"
echo -e  "o========================     VOS RESULTATS   =========================	$MAJ $VERSION $AUTHOR\n|"
echo -e  "| Nombre de Fichiers supprimés :		$COMPTEUR_FICHIERS.\n|"
echo -e  "o======================================================================\n"
