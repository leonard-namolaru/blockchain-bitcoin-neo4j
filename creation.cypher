// Added 7214 labels, created 7214 nodes, set 43284 properties, created 3607 relationships, completed after 1006 ms.
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

// Added 10000 labels, created 10000 nodes, set 149993 properties, created 10000 relationships, completed after 20832 ms.
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

// Added 29589 labels, created 29589 nodes, set 178318 properties, created 29589 relationships, completed after 401933 ms.
LOAD CSV WITH HEADERS FROM "file:/inputs_202210.csv" as inputs_csv
MERGE (transaction:Transaction {hash: inputs_csv.transaction_hash})
CREATE (input :Input {index: toInteger(inputs_csv.index),
                         spent_transaction_hash: inputs_csv.spent_transaction_hash,   
                          sent_output_index: toInteger(inputs_csv.sent_output_index),         
                          required_signatures: toInteger(inputs_csv.required_signatures),         
                          type: inputs_csv.type,         
                          value: toFloat(inputs_csv.value)        
                        }
                      ) 
CREATE (input)-[:in {script_asm: inputs_csv.script_asm, script_hex: inputs_csv.script_hex, sequence: toInteger(inputs_csv.sequence)}]->(transaction)

// Added 64062 labels, created 64062 nodes, set 192186 properties, created 64062 relationships, completed after 354477 ms.
LOAD CSV WITH HEADERS FROM "file:/outputs_202210.csv" as outputs_csv
MERGE (transaction:Transaction {hash: outputs_csv.transaction_hash})
CREATE (output :Output {index: toInteger(outputs_csv.index), 
                        required_signatures: toInteger(outputs_csv.required_signatures), 
                        type: outputs_csv.type,
                        value: toFloat(outputs_csv.value),
                        script_asm: outputs_csv.script_asm,
                        script_hex: outputs_csv.script_hex
                       }
                      )
CREATE (transaction)-[:out]->(output)
// Les outputs apparaissent sous le format ['yyyxx'], c'est-à-dire sous un format de tableau, 
// bien qu'au moins dans notre jeu de données il n'y ait qu'une seule valeur dans le tableau,
// nous utilisons donc la fonction split(original, splitDelimiter) pour extraire l'adresse elle-même du tableau
CREATE (address :Address {address: split(outputs_csv.addresses, "'")[1]}) 
CREATE (output)-[:locked]->(address)
