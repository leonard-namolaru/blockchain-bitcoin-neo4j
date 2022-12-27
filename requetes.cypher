MATCH n=(start:Address{address:'bc1qhekuaxsq7ps2w7fzw9qwun2x2yacsd6ev4csf6'})-[*]-(end:Address) 
RETURN n 

MATCH n=(start:Address{address:'bc1qhekuaxsq7ps2w7fzw9qwun2x2yacsd6ev4csf6'})-[*]-(end:Address{address:'3NmuUsUNAbnuGoSTR47sJ3YLD1q7tc7YxC'}) 
RETURN n 

MATCH p= (start_output:Output)-[*]-(end_output:Output)
RETURN p
LIMIT 5

MATCH (transaction:Transaction)
OPTIONAL MATCH (transaction{output_count: 2})-[:out]->(output:Output)
RETURN transaction.hash, output.value

MATCH (block:Block)
WHERE NOT EXISTS ((block)<-[:inc]-({is_coinbase: false}))
RETURN block.hash

CALL {
    MATCH (block: Block) WHERE block.transaction_count IS NOT NULL
    RETURN block ORDER BY block.transaction_count ASC LIMIT 1
        UNION
    MATCH (block: Block) WHERE block.transaction_count IS NOT NULL
    RETURN block ORDER BY block.transaction_count DESC LIMIT 1
}
RETURN block.hash, block.transaction_count ORDER BY block.hash

