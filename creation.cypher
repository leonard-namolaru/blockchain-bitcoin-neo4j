LOAD CSV WITH HEADERS FROM "file:/blocks_202210.csv" AS blocks_csv
CREATE (block:Block{ hash: blocks_csv.hash,
                            size:toInteger(blocks_csv.size), 
                            stripped_size:toInteger(blocks_csv.stripped_size), 
                            weight:toInteger(blocks_csv.weight), 
                            number:toInteger(blocks_csv.number), 
                            version:toInteger(blocks_csv.version), 
                            markle_root: blocks_csv.markle_root,
                            timestamp: blocks_csv.timestamp,
                            timestamp_month: date(blocks_csv.timestamp_month),
                            nonce: blocks_csv.nonce,
                            bits: blocks_csv.bits,
                            transaction_count:toInteger(blocks_csv.transaction_count)
                          })-[:coinbase]->(coinbase:Coinbase{value: blocks_csv.coinbase_param})


    


