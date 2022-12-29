COPY block
FROM '/Users/erwan/Documents/Cours/Master/M2/db_spe/bitcoin-blockchain-neo4j/blocks_202210.csv'
DELIMITER ','
CSV HEADER;

COPY transaction
FROM '/Users/erwan/Documents/Cours/Master/M2/db_spe/bitcoin-blockchain-neo4j/transactions_202210.csv'
DELIMITER ','
CSV HEADER;

COPY input
FROM '/Users/erwan/Documents/Cours/Master/M2/db_spe/bitcoin-blockchain-neo4j/inputs_202210.csv'
DELIMITER ','
CSV HEADER;

COPY output
FROM '/Users/erwan/Documents/Cours/Master/M2/db_spe/bitcoin-blockchain-neo4j/outputs_202210.csv'
DELIMITER ','
CSV HEADER;

-- CREATE INDEX hash_id ON transaction USING HASH (hash);