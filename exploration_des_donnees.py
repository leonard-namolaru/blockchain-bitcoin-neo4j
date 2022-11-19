from pandas import read_csv
def csv_exemple_ligne(csv : str) -> None :
    """
    """
    fichier_csv = open(csv, "r")
    lignes = fichier_csv.readlines()

    noms_colonnes = lignes[0].split(',')
    noms_colonnes[ len(noms_colonnes) - 1 ] = noms_colonnes[ len(noms_colonnes) - 1 ].split('\n')[0] # Suppression du caractere \n du nom de la derniere colonne

    ligne_1 = lignes[1].split(',')
    ligne_1[ len(ligne_1) - 1 ] = ligne_1[ len(ligne_1) - 1 ].split('\n')[0] # Suppression du caractere \n de la valeur de la derniere colonne

    ligne_2 = lignes[2].split(',')
    ligne_2[ len(ligne_2) - 1 ] = ligne_2[ len(ligne_2) - 1 ].split('\n')[0] # Suppression du caractere \n de la valeur de la derniere colonne
    
    for i in range(0, len(ligne_1)) :
        if i < len(noms_colonnes) :
            print(noms_colonnes[i], " : ", ligne_1[i])
        else :
            print("\t", ligne_1[i])

    print()
    print()
    
    for i in range(0, len(ligne_2)) :
        if i < len(noms_colonnes) :
            print(noms_colonnes[i], " : ", ligne_2[i])
        else :
            print("\t", ligne_2[i])
    
    fichier_csv.close()

def csv_data(csv : str) -> None :
    fichier_csv = open(csv, "r")
    lignes = fichier_csv.readlines()

    noms_colonnes = lignes[0].split(',')
    noms_colonnes[ len(noms_colonnes) - 1 ] = noms_colonnes[ len(noms_colonnes) - 1 ].split('\n')[0] # Suppression du caractere \n du nom de la derniere colonne
    fichier_csv.close()

    donnees = read_csv(csv)

    for nom_colonne in noms_colonnes[0:len(noms_colonnes)] :
        print( donnees.groupby([nom_colonne]).size() )
        print("\n")


if __name__ == '__main__' :
    csv_exemple_ligne('blocks_202210.csv')
    csv_data('blocks_202210.csv')
