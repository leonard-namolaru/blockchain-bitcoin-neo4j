COPY block
FROM '/Users/erwan/Documents/Cours/Master/M2/db_spe/bitcoin-blockchain-neo4j/blocks_202210.csv'
DELIMITER ','
CSV HEADER;

COPY transaction
FROM '/Users/erwan/Documents/Cours/Master/M2/db_spe/bitcoin-blockchain-neo4j/transactions_202210.csv'
DELIMITER ','
CSV HEADER;
ALTER TABLE transaction
DROP COLUMN block_number; 
ALTER TABLE transaction
DROP COLUMN block_timestamp;
ALTER TABLE transaction
DROP COLUMN block_timestamp_month;

COPY input
FROM '/Users/erwan/Documents/Cours/Master/M2/db_spe/bitcoin-blockchain-neo4j/inputs_202210.csv'
DELIMITER ','
CSV HEADER;
ALTER TABLE input
DROP COLUMN block_hash; 
ALTER TABLE input
DROP COLUMN block_number;
ALTER TABLE input
DROP COLUMN block_timestamp;

COPY output
FROM '/Users/erwan/Documents/Cours/Master/M2/db_spe/bitcoin-blockchain-neo4j/outputs_202210.csv'
DELIMITER ','
CSV HEADER;
ALTER TABLE output
DROP COLUMN block_hash; 
ALTER TABLE output
DROP COLUMN block_number;
ALTER TABLE output
DROP COLUMN block_timestamp;

-- CREATE INDEX hash_id ON transaction USING HASH (hash);