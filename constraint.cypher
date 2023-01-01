// DROP CONSTRAINT constraint_name [IF EXISTS]

CREATE CONSTRAINT unique_block_hash
FOR (block :Block)
REQUIRE block.hash IS UNIQUE

CREATE CONSTRAINT unique_transaction_hash
FOR (transaction :Transaction)
REQUIRE transaction.hash IS UNIQUE 

CREATE CONSTRAINT exist_block_hash
FOR (block :Block)
REQUIRE (block.hash) IS NOT NULL

CREATE CONSTRAINT exist_transaction_hash
FOR (transaction :Transaction)
REQUIRE (transaction.hash) IS NOT NULL

CREATE CONSTRAINT exist_address
FOR (addr :Address)
REQUIRE (addr.address) IS NOT NULL



