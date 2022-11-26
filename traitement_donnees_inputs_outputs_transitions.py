from pandas import read_csv

def csv_inputs_outputs(csv : str) -> None :
    fichier_csv = open(csv, "r")
    lignes = fichier_csv.readlines()

    noms_colonnes = lignes[0].split(',')
    noms_colonnes[ len(noms_colonnes) - 1 ] = noms_colonnes[ len(noms_colonnes) - 1 ].split('\n')[0] # Suppression du caractere \n du nom de la derniere colonne
    fichier_csv.close()

    inputs = noms_colonnes[ len(noms_colonnes) - 2 ]
    outputs = noms_colonnes[ len(noms_colonnes) - 1 ]

    donnees = read_csv(csv)
    print( list( donnees[inputs].head() )[0] ) 
    print( list( donnees[outputs].head() )[0] ) 


if __name__ == '__main__' :
    csv_inputs_outputs('transactions_202210.csv')

