#!/bin/bash

NOM_FICHIER="InforEmployes.xlsx"
NOM_REPERTOIRE_PARENT="lesTests"
EMPLACEMENT_FICHIER=$NOM_REPERTOIRE_PARENT/$NOM_FICHIER

FICHIER_DATA="Data_20-11-24.txt"
NOM_FICHIER_COMMENTAIRE="commentaire.log"

select option in "Sauvegarder les données des nouveaux employés", "Créer les comptes utilisateurs", "Créer les répertoires des nouveaux employés", "Sortir du menu"
do
	if [ "$REPLY" == "1" ]
	then
		if [ -f $EMPLACEMENT_FICHIER ]
		then
			echo "" > $EMPLACEMENT_FICHIER
		else
			mkdir -p $NOM_REPERTOIRE_PARENT
			touch $EMPLACEMENT_FICHIER
		fi

		while read ligne
		do
			identifiant=$(echo "$ligne" | cut -d: -f1)
			prenom=$(echo "$ligne" | cut -d: -f2)
			nom=$(echo "$ligne" | cut -d: -f3)
			dateEmbauche=$(echo "$FICHIER_DATA" | cut -d_ -f2 | cut -d. -f1)
			numTel=$(echo "$ligne" | cut -d: -f4)
			courriel=$(echo "$ligne" | cut -d: -f5)
			adresse1=$(echo "$ligne" | cut -d: -f6)
			adresse2=$(echo "$ligne" | cut -d: -f7)
			adresse3=$(echo "$ligne" | cut -d: -f8)
			adresse4=$(echo "$ligne" | cut -d: -f9)
			adresse5=$(echo "$ligne" | cut -d: -f10)
			echo -e "$identifiant\t$prenom\t$nom\$dateEmbauche\t$numTel\t$courriel\t$adresse1, $adresse2, $adresse3, $adresse4, $adresse5" >> $EMPLACEMENT_FICHIER
		done < $FICHIER_DATA

	elif [ "$REPLY" == "2" ]
	then
		dateEmbauche=$(echo "$FICHIER_DATA" | cut -d_ -f2 | cut -d. -f1)
		while read ligne
                do
			identifiant=$(echo "$ligne" | cut -d: -f1)
                        prenom=$(echo "$ligne" | cut -d: -f2)
                        nom=$(echo "$ligne" | cut -d: -f3)
			troisPremiereLettre=$(echo "$prenom" | cut -c 1-3)
			nomUtilisateur="$nom$troisPremiereLettre$identifiant"
			motDePasse="$dateEmbauche$nom"
			sudo useradd "$nomUtilisateur"
			echo "$nomUtilisateur:$motDePasse" | sudo chpasswd
		done


	elif [ "$REPLY" == "3" ]
        then
                dateEmbauche=$(echo "$FICHIER_DATA" | cut -d_ -f2 | cut -d. -f1)
		repertoireDateEmbauche=$NOM_REPERTOIRE_PARENT/$dateEmbauche

		if [ ! -d $repertoireDateEmbauche ]
		then
			mkdir -p $NOM_REPERTOIRE_PARENT/$dateEmbauche
		fi

		while read ligne
                do
                        prenom=$(echo "$ligne" | cut -d: -f2)
                        nom=$(echo "$ligne" | cut -d: -f3)
			echo "$prenom $nom"
			if [ ! -d $NOM_REPERTOIRE_PARENT/$dateEmbauche/$prenom$nom ]
			then
				mkdir -p "$NOM_REPERTOIRE_PARENT/$dateEmbauche/$prenom$nom"
			fi

			echo -e "Bonjour $nom $prenom !\nSi vous avez des questions, veuillez communiquer au poste 2025." > "$NOM_REPERTOIRE_PARENT/$dateEmbauche/$prenom$nom/$NOM_FICHIER_COMMENTAIRE"

		done < $FICHIER_DATA

	elif [ "$REPLY" == "4" ]
        then
                echo "Fin du programme - Ubert Guertin"
		break
	else
		echo "Choix '$REPLY' invalide!"
	fi
done
