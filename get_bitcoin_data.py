# -*- coding: utf-8 -*- 
# Source : https://www.kaggle.com/code/nocibambi/getting-started-with-bitcoin-data

from google.cloud import bigquery # pip install google-cloud-bigquery
import pandas as pd
from time import time

def estimate_gigabytes_scanned(query : str, big_query_client : bigquery.client.Client) -> float :
    """
    Une fonction utile pour estimer la taille d'une requête.
    Sources: 
    - https://www.kaggle.com/sohier/beyond-queries-exploring-the-bigquery-api/
    - https://www.kaggle.com/code/nocibambi/getting-started-with-bitcoin-data
    - Apache 2.0 open source license.
    """
    # Nous initions un objet `QueryJobConfig`
    # Description de l'API : https://googleapis.dev/python/bigquery/latest/generated/google.cloud.bigquery.job.QueryJobConfig.html
    my_job_config = bigquery.job.QueryJobConfig()
    
    # Nous activons le "dry run" en définissant l'attribut "dry_run" de l'objet "QueryJobConfig".
    # Cela signifie que nous n'exécutons pas réellement la requête, mais estimons son coût de fonctionnement.
    my_job_config.dry_run = True # True si cette requête doit être un essai pour estimer les coûts.

    # We activate the job_config by passing the `QueryJobConfig` to the client's `query` method.
    my_job = big_query_client.query(query, job_config=my_job_config)
    
    # Les résultats se présentent sous forme d'octets que nous convertissons en gigaoctets pour une meilleure lisibilité
    BYTES_PER_GB = 2**30
    estimate = my_job.total_bytes_processed / BYTES_PER_GB
    
    return estimate # Cette requête traitera {estimate} Go (Go = GB)

# Description de l'API : https://cloud.google.com/python/docs/reference/bigquery/latest/google.cloud.bigquery.client.Client
client = bigquery.Client()

query = """
    SELECT *
    FROM `bigquery-public-data.crypto_bitcoin.transactions`
    WHERE
        EXTRACT(YEAR FROM block_timestamp) = 2022 AND
        EXTRACT(MONTH FROM block_timestamp) = 10 
        ORDER BY `hash`
    LIMIT 10000   
    """


estimate = estimate_gigabytes_scanned(query, client)
print(f"Cette requete traitera {estimate} GBs.")

bytes_in_gigabytes = 2**30

safe_config = bigquery.QueryJobConfig( maximum_bytes_billed= int(estimate + 10) * bytes_in_gigabytes )

query_job = client.query(query, job_config=safe_config)
start = time()
result = query_job.result()
df = result.to_dataframe()
duration = (time() - start) / 60

print(f"Temps ecoule : {duration:.2f} minutes")

print( df.head() )
df.to_csv('transactions_202210.csv', index=False)


query = """
    SELECT *
    FROM `bigquery-public-data.crypto_bitcoin.blocks`
    WHERE
        `hash` IN (SELECT block_hash
                 FROM `bigquery-public-data.crypto_bitcoin.transactions`
                 WHERE
                 EXTRACT(YEAR FROM block_timestamp) = 2022 AND
                 EXTRACT(MONTH FROM block_timestamp) = 10 
                 ORDER BY `hash`
                 LIMIT 10000)
    """

estimate = estimate_gigabytes_scanned(query, client)
print(f"Cette requete traitera {estimate} GBs.")

bytes_in_gigabytes = 2**30

safe_config = bigquery.QueryJobConfig( maximum_bytes_billed= int(estimate + 10) * bytes_in_gigabytes )

query_job = client.query(query, job_config=safe_config)
start = time()
result = query_job.result()
df = result.to_dataframe()
duration = (time() - start) / 60

print(f"Temps ecoule : {duration:.2f} minutes")

print( df.head() )
df.to_csv('blocks_202210.csv', index=False)
