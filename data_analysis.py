import pandas as pd

filename = 'transactions_202210.csv'

def import_data(filename):
  raw_data = pd.read_csv(filename, header='infer', nrows=100)
  # print(raw_data)
  print(raw_data.dtypes)
  """
    NOTE : ne pas utiliser le hashs ?
    hash -> id transaction, le simplifier ?
    block_hash -> utiliser block_number pour identifier blocs ?
    timestampS -> type object le convertir en type Date ?
  """
  print(raw_data['outputs'][0])


if __name__ == '__main__':
  import_data(filename)
