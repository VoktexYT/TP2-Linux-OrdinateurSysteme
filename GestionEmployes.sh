#!/bin/bash

####################################
# PROGRAMME CRÉÉ PAR UBERT GUERTIN #
# 2024-12-5			   #
# CE SCRIPT PERMET DE GÉRER DES    #
# EMPLOYÉS À L'AIDE D'UN MENU      #
####################################


# Création de variables
NOM_FICHIER="InforEmployes.xlsx"
NOM_REPERTOIRE_PARENT="lesTests"
EMPLACEMENT_FICHIER="$NOM_REPERTOIRE_PARENT/$NOM_FICHIER"
FICHIER_DATA="Data_20-11-24.txt"
NOM_FICHIER_COMMENTAIRE="commentaire.log"

# Récupérer la première parti du nom du fichier
# 'data'. Extraction de la date d'embauche.
DATE_EMBAUCHE=$(echo "$FICHIER_DATA" | cut -d_ -f2 | cut -d. -f1)


# Création d'un menu de choix avec des puces numérotées
select option in "Sauvegarder les données des nouveaux employés", "Créer les comptes utilisateurs", "Créer les répertoires des nouveaux employés", "Sortir du menu"
do
	# Si l'utilisateur entre le choix #1
	if [ "$REPLY" == "1" ]
	then
		# Vérifier si le fichier Excel existe
		if [ -f $EMPLACEMENT_FICHIER ]
		then
			# Écraser le contenu
			echo "" > $EMPLACEMENT_FICHIER
		else
			# Créer un nouveau fichier
			mkdir -p $NOM_REPERTOIRE_PARENT
			touch $EMPLACEMENT_FICHIER
		fi

		# Lire le fichier data ligne par ligne
		while read ligne
		do
			# Récupérer chaque information avec les ':'
			identifiant=$(echo "$ligne" | cut -d: -f1)
			prenom=$(echo "$ligne" | cut -d: -f2)
			nom=$(echo "$ligne" | cut -d: -f3)
			numTel=$(echo "$ligne" | cut -d: -f4)
			courriel=$(echo "$ligne" | cut -d: -f5)
			adresse1=$(echo "$ligne" | cut -d: -f6)
			adresse2=$(echo "$ligne" | cut -d: -f7)
			adresse3=$(echo "$ligne" | cut -d: -f8)
			adresse4=$(echo "$ligne" | cut -d: -f9)
			adresse5=$(echo "$ligne" | cut -d: -f10)

			# Insertion d'une nouvelle rangée dans le fichier
			# Excel
			echo -e "$identifiant\t$prenom\t$nom\$DATE_EMBAUCHE\t$numTel\t$courriel\t$adresse1, $adresse2, $adresse3, $adresse4, $adresse5" >> $EMPLACEMENT_FICHIER
		done < $FICHIER_DATA

		# Afficher un message dans le terminal
                 echo "Le fichier '$NOM_FICHIER' a été créé avec succès!"

	# Si le choix est #2
	elif [ "$REPLY" == "2" ]
	then
		# Lecture du fichier 'data' ligne par ligne
		while read ligne
                do
			# Récupérer chaque information de la ligne avec
			# le délimiteur ':'
			identifiant=$(echo "$ligne" | cut -d: -f1)
                        prenom=$(echo "$ligne" | cut -d: -f2)
                        nom=$(echo "$ligne" | cut -d: -f3)

			# Récupérer les 3 premiers caractères du prénom
			troisPremiereLettre=$(echo "$prenom" | cut -c 1-3)

			# Concaténation des chaines de caractères pour
			# former le nom d'utilisateur et le mot de passe
			nomUtilisateur="$nom$troisPremiereLettre$identifiant"
			motDePasse="$DATE_EMBAUCHE$nom"

			# Ajouter un nouvel utilisateur avec le nom d'
			# utilisateur
			sudo useradd "$nomUtilisateur"

			# Changer le mot de passe de l'utilisateur créé
			# précedament
			echo "$nomUtilisateur:$motDePasse" | sudo chpasswd

			# Afficher un message dans le terminal
			echo "L'utilisateur \"$prenom $nom\" a été créé avec succès!"
		done < $FICHIER_DATA

	# Si le choix est le #3
	elif [ "$REPLY" == "3" ]
        then
		# Concaténation des chaines de caractère
		repertoireDateEmbauche="$NOM_REPERTOIRE_PARENT/$DATE_EMBAUCHE"

		# Vérifier si le répertoire est inexistant
		if [ ! -d $repertoireDateEmbauche ]
		then
			# Création d'un répertoire
			mkdir -p $NOM_REPERTOIRE_PARENT/$DATE_EMBAUCHE
		fi

		# Lecture du fichier 'data' ligne par ligne
		while read ligne
                do
			# Extraction de données avec le séparateur ':'
                        prenom=$(echo "$ligne" | cut -d: -f2)
                        nom=$(echo "$ligne" | cut -d: -f3)

			# Vérifier si le répertoire est inexistant
			if [ ! -d $NOM_REPERTOIRE_PARENT/$DATE_EMBAUCHE/$prenom$nom ]
			then
				# Création d'un répertoire
				mkdir -p "$NOM_REPERTOIRE_PARENT/$DATE_EMBAUCHE/$prenom$nom"

				# Afficher un message dans le terminal
                        	echo "Le répertoire \"$prenom $nom\" à été créé avec succès!"
			fi

			# Création d'un fichier "commande.log"
			# Écrire un message personalisé dans ce fichier
			echo -e "Bonjour $nom $prenom !\nSi vous avez des questions, veuillez communiquer au poste 2025." > "$NOM_REPERTOIRE_PARENT/$DATE_EMBAUCHE/$prenom$nom/$NOM_FICHIER_COMMENTAIRE"

		done < $FICHIER_DATA

	# Si c'est le choix #4
	elif [ "$REPLY" == "4" ]
        then
		# Afficher un message de fin de programme dans le terminal
                echo "Fin du programme - Ubert Guertin"

		# Briser la boucle du menu
		break

	# Si le choix n'est pas valide alors affiche un message d'erreur
	else
		echo "Choix '$REPLY' invalide!"
	fi
done
