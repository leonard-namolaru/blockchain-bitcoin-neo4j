SELECT number, transaction_count 
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