EXPLAIN ANALYSE SELECT number, transaction_count 
FROM block 
WHERE transaction_count = ( SELECT transaction_count
                            FROM block
                            WHERE transaction_count IS NOT NULL
                            ORDER BY transaction_count
                            LIMIT 1 
                            )

UNION

SELECT number, transaction_count 
FROM block 
WHERE transaction_count = ( SELECT transaction_count
                            FROM block
                            WHERE transaction_count IS NOT NULL
                            ORDER BY transaction_count DESC
                            LIMIT 1 
                            );


-- Faux si block contient 1 transaction non coinbase
select count(from_cb) = 0
from (select hash, is_coinbase from transaction where block_hash='00000000000000000005b7251fab086a1ee166cdae89ac17f706875a7ac0c74e' and is_coinbase='f') as from_cb;

-- select count(in_block) from (select b.hash from block b where (select t.is_coinbase from transaction t where t.block_hash = b.hash)) as in_block;

