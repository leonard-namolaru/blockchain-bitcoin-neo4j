from neo4j import GraphDatabase, ManagedTransaction

class DonneesHistoriquesBlockchainBitcoin(object) :

    def __init__(self, uri : str, utilisateur : str, mdp : str):
        self.driver = GraphDatabase.driver(uri, auth=(utilisateur, mdp))

    def close(self):
        self.driver.close()

    def print_end_addresses(self, hash : str):
        def get_end_addresses(managed_transaction : ManagedTransaction, hash : str) -> list :
            addresses = []
            result = managed_transaction.run("MATCH p=(start:Address)-[*]-(end:Address) "
                                             "WHERE start.address = $hash "
                                             "RETURN end.address AS address ", hash=hash)
            for record in result:
                addresses.append(record['address'])
            return addresses

        with self.driver.session() as session:
            addresses_list = session.execute_read(get_end_addresses, hash)
        for address in addresses_list:
            print(address)

if __name__ == "__main__":
    uri = "bolt://localhost:7687"
    utilisateur = "neo4j"
    mdp = "lmirceas"

    donneesHistoriquesBlockchainBitcoin = DonneesHistoriquesBlockchainBitcoin(uri, utilisateur, mdp)
    donneesHistoriquesBlockchainBitcoin.print_end_addresses("bc1qhekuaxsq7ps2w7fzw9qwun2x2yacsd6ev4csf6")
    donneesHistoriquesBlockchainBitcoin.close()


    