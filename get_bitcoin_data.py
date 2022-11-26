# -*- coding: utf-8 -*- 
# Un article qui nous a ete tres utile dans le cadre de la redaction de ce code : https://www.kaggle.com/code/nocibambi/getting-started-with-bitcoin-data
# (tout en apportant des modifications et des ajustements selon les besoins de notre projet)

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

def query_execution(query : str, big_query_client : bigquery.client.Client, csv_file_name : str) -> None :
    """
    Une fonction qui recoit une requete et cree un fichier csv avec les donnees demandees.
    """
    estimate = estimate_gigabytes_scanned(query, big_query_client)
    print(f"Cette requete traitera {estimate} GBs.")

    bytes_in_gigabytes = 2**30
    safe_config = bigquery.QueryJobConfig( maximum_bytes_billed= int(estimate + 10) * bytes_in_gigabytes )

    query_job = client.query(query, job_config=safe_config)
    start = time()

    result = query_job.result()
    data_frame = result.to_dataframe()

    duration = (time() - start) / 60
    print(f"Temps ecoule : {duration:.2f} minutes")

    print( data_frame.head() )
    data_frame.to_csv(csv_file_name, index=False)


if __name__ == '__main__' :
    # Description de l'API : https://cloud.google.com/python/docs/reference/bigquery/latest/google.cloud.bigquery.client.Client
    client = bigquery.Client()

    common_part_for_all_queries = 'FROM `bigquery-public-data.crypto_bitcoin.transactions` '\
                                   'WHERE '\
                                   'EXTRACT(YEAR FROM block_timestamp) = 2022 AND '\
                                   'EXTRACT(MONTH FROM block_timestamp) = 10 '\
                                   'ORDER BY `hash` '\
                                   'LIMIT 10000'   
 

    query_1 = 'SELECT `hash`,size,virtual_size,version,lock_time,block_hash,'\
            'block_number,block_timestamp,block_timestamp_month,input_count,output_count,'\
            'input_value,output_value,is_coinbase,fee ' + common_part_for_all_queries

    query_execution(query_1, client, 'transactions_202210.csv')


    query_2 = 'SELECT * '\
            'FROM `bigquery-public-data.crypto_bitcoin.blocks` '\
            'WHERE '\
            '`hash` IN (SELECT block_hash ' + common_part_for_all_queries + ') '

    query_execution(query_2, client, 'blocks_202210.csv')

    query_3 = 'SELECT * '\
            'FROM `bigquery-public-data.crypto_bitcoin.inputs` '\
            'WHERE '\
            'transaction_hash IN (SELECT `hash` ' + common_part_for_all_queries + ') '

    query_execution(query_3, client, 'inputs_202210.csv')

    query_4 = 'SELECT * '\
            'FROM `bigquery-public-data.crypto_bitcoin.outputs` '\
            'WHERE '\
            'transaction_hash IN (SELECT `hash` ' + common_part_for_all_queries + ') '

    query_execution(query_4, client, 'outputs_202210.csv')