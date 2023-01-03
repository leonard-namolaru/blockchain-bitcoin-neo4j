DROP TABLE IF EXISTS block CASCADE;
DROP TABLE IF EXISTS transaction CASCADE;
DROP TABLE IF EXISTS input CASCADE;
DROP TABLE IF EXISTS output CASCADE;

CREATE TABLE block (
    hash CHAR(64) PRIMARY KEY NOT NULL,
    size INT,
    stripped_size INT,
    weight INT,
    number INT NOT NULL,
    version INT,
    merkle_root CHAR(64),
    timestamp TIMESTAMP NOT NULL,
    timestamp_month DATE NOT NULL,
    nonce CHAR(8),
    bits CHAR(8),
    coinbase_param VARCHAR,
    transaction_count INT
);

CREATE TABLE transaction (
    hash CHAR(64) PRIMARY KEY NOT NULL,
    size INT,
    virtual_size INT,
    version INT,
    lock_time INT,
    block_hash CHAR(64) REFERENCES block(hash) NOT NULL,
    block_number INT NOT NULL,
    block_timestamp TIMESTAMP NOT NULL,
    block_timestamp_month DATE NOT NULL,
    input_count INT,
    output_count INT,
    input_value REAL,
    output_value REAL,
    is_coinbase BOOLEAN,
    fee REAL
);

CREATE TABLE input (
    transaction_hash CHAR(64) REFERENCES transaction(hash),
    block_hash CHAR(64) REFERENCES block(hash),
    block_number INT,
    block_timestamp TIMESTAMP,
    index INT,
    spent_transaction_hash CHAR(64),
    spent_output_index INT,
    script_asm TEXT,
    script_hex TEXT,
    sequence BIGINT,
    required_signatures INT,
    type TEXT,
    addresses TEXT,
    value REAL
);

CREATE TABLE output (
    transaction_hash CHAR(64) REFERENCES transaction(hash),
    block_hash CHAR(64),
    block_number INT,
    block_timestamp TIMESTAMP,
    index INT,
    script_asm TEXT,
    script_hex TEXT,
    required_signatures INT,
    type TEXT,
    addresses TEXT,
    value REAL
);
