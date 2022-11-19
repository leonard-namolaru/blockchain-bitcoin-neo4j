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

LOAD CSV WITH HEADERS FROM "file:/transactions_202210.csv" as transactions_csv
MERGE (block:Block {hash:transactions_csv.block_hash})
CREATE (transaction:Transaction {  hash: transactions_csv.hash,
                                   size: toInteger(transactions_csv.size),
                                   virtual_size: toInteger(transactions_csv.virtual_size),
                                   version: toInteger(transactions_csv.version),
                                   lock_time: toInteger(transactions_csv.lock_time),
                                   block_hash: transactions_csv.block_hash,
                                   block_number: toInteger(transactions_csv.block_number),
                                   block_timestamp: transactions_csv.block_timestamp,
                                   block_timestamp_month: date(transactions_csv.block_timestamp_month),
                                   input_count: toInteger(transactions_csv.input_count),
                                   output_count: toInteger(transactions_csv.output_count),
                                   input_value: toFloat(transactions_csv.input_value),
                                   output_value: toFloat(transactions_csv.output_value),
                                   is_coinbase: toBoolean(transactions_csv.is_coinbase),
                                   fee: toFloat(transactions_csv.fee)
                                }
                              )
CREATE (transaction)-[:inc]->(block)  


// APOC Full installation : https://neo4j.com/labs/apoc/4.1/installation/
//LOAD CSV WITH HEADERS FROM "file:/transactions_202210.csv" as transactions_csv
//MERGE (transaction:Transaction {hash: transactions_csv.hash})

//WITH apoc.convert.toList(transactions_csv.inputs ) AS inputs
//FOREACH (input_csv in inputs |
//         CREATE (input :Input {index: toInteger(apoc.convert.toMap(input_csv).index),
//                          spent_transaction_hash: apoc.convert.toMap(input_csv).spent_transaction_hash,   
//                          sent_output_index: toInteger(apoc.convert.toMap(input_csv).sent_output_index),         
//                          required_signatures: toInteger(apoc.convert.toMap(input_csv).required_signatures),         
//                          type: apoc.convert.toMap(input_csv).type,         
//                          value: toFloat(apoc.convert.toMap(input_csv).value)        
//                         }
//                        ) 
//
//         CREATE (input)-[:in {script_asm: apoc.convert.toMap(input_csv).script_asm, script_hex: apoc.convert.toMap(input_csv).script_hex, sequence: toInteger(apoc.convert.toMap(input_csv).sequence)}]->(transaction)
//         )

// APOC Full installation : https://neo4j.com/labs/apoc/4.1/installation/
//LOAD CSV WITH HEADERS FROM "file:/transactions_202210.csv" as transactions_csv
//MERGE (transaction:Transaction {hash: transactions_csv.hash})

//WITH apoc.convert.toList( apoc.convert.toJson(transactions_csv.outputs) ) AS outputs
//FOREACH (output_csv in outputs |
//         CREATE (output :Output {index: toInteger(apoc.convert.toMap(output_csv).index), required_signatures: toInteger(apoc.convert.toMap(output_csv).required_signatures), type: apoc.convert.toMap(output_csv).type})
//         CREATE (transaction)-[:out]->(output)
//         SET
//             output.value= toFloat(apoc.convert.toMap(output_csv).value),
//             output.script_asm= apoc.convert.toMap(output_csv).script_asm,
//             output.script_hex= apoc.convert.toMap(output_csv).script_hex
//         FOREACH(ignoreMe IN CASE WHEN apoc.convert.toMap(output_csv).addresses <> '' THEN [1] ELSE [] END |
//                 CREATE (address :Address {address: apoc.convert.toMap(output_csv).addresses})
//                 CREATE (output)-[:locked]->(address)
//                )
//        )

// APOC Full installation : https://neo4j.com/labs/apoc/4.1/installation/
//LOAD CSV WITH HEADERS FROM "file:/transactions_202210.csv" as transactions_csv
//MERGE (transaction:Transaction {hash: transactions_csv.hash})

//WITH apoc.convert.toList( apoc.convert.toJson(transactions_csv.outputs) ) AS outputs
//FOREACH (output_csv in outputs |
//         MERGE (output :Output {index: toInteger(apoc.convert.toMap(output_csv).index)})
//         FOREACH(address_csv IN apoc.convert.toMap(output_csv).addresses |
//                 CREATE (address :Address {address: address_csv})
//                 CREATE (output)-[:locked]->(address)
//                )
//        )

