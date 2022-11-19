import pandas as pd

def import_data(filename):
  raw_data = pd.read_csv(filename, header='infer', nrows=100)
  # print(raw_data)
  print(raw_data.dtypes) 
  return raw_data


if __name__ == '__main__':
  transaction = 'transactions_202210.csv'
  blocks = 'blocks_202210.csv'

  transaction_data = import_data(transaction)
  print(transaction_data['inputs'][0])
  print(transaction_data['outputs'][0])
  """
    NOTE : ne pas utiliser le hashs ?
    hash -> id transaction, le simplifier ?
    block_hash -> utiliser block_number pour identifier blocs ?
    timestampS -> type object le convertir en type Date ?
  """

  blocks_data = import_data(blocks)
