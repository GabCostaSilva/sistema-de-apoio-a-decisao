import requests
import time
import os
import json
import csv

FOLDER_DIR = os.listdir('.')
CURL_URL = 'http://api.portaldatransparencia.gov.br/api-de-dados/auxilio-emergencial-por-municipio?codigoIbge={' \
           'cdg_ibge}&mesAno={ano_mes}&pagina=1 '
PERIODO_RECEBIMENTO = [202004, 202005, 202006, 202007, 202008, 202009, 202010, 202011, 202012, 202101]
CDGS_IBGE = open('cdg_ibge_BRASIL.txt', 'r')
cdgs_ibge = CDGS_IBGE.read().strip('\n').split('\n')

for cdg in cdgs_ibge:
    with open('csv_data/dados_auxilio.csv', mode='a') as f:
        auxilio_csv = csv.writer(f, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        request = ''
        for periodo in PERIODO_RECEBIMENTO:
            time.sleep(0.7)
            request_ok = False
            try:
                print(f'Getting data for ibge code: {cdg} in the year and month {periodo}')
                request = requests.get(CURL_URL.format(cdg_ibge=cdg, ano_mes=periodo),
                                       headers={"chave-api-dados": "TOKEN_AQUI"})
                if request.status_code != 200:
                    raise Exception

            except Exception:
                while not request_ok:
                    print('.', end='')
                    time.sleep(120)
                    request = requests.get(CURL_URL.format(cdg_ibge=cdg, ano_mes=periodo),
                                           headers={"chave-api-dados": "TOKEN_AQUI"})
                    if request.status_code == 200:
                        request_ok = True

            json_request = json.loads(request.text)
            if json_request:
                auxilio_csv.writerow(
                    [cdg, periodo, json_request[0]['valor'], json_request[0]['quantidadeBeneficiados']])
            else:
                auxilio_csv.writerow([cdg, periodo, 0, 0])
