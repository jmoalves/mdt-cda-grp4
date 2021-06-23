#!/bin/bash

mkdir -p porAno

echo === Header
header=$( zcat operacoes-financiamento-operacoes-indiretas-automaticas.csv.gz | head -n 1 )

echo === Descobrindo anos
anos=$(
	zcat operacoes-financiamento-operacoes-indiretas-automaticas.csv.gz \
		| cut -d ';' -f 6 \
		| sed 's/^[^0-9]*\([0-9]\+\)-.*/\1/g' \
		| sort -u \
		| tail -n +2
	)
echo Anos: $anos

## 3: "uf"
## 4: "municipio"
## 5: "municipio_codigo"
## 6: "data_da_contratacao"
## 7: "valor_da_operacao_em_reais"
## 20: "setor_cnae"
## 21: "subsetor_cnae_agrupado"
## 22: "subsetor_cnae_codigo"
## 23: "subsetor_cnae_nome"
## 24: "setor_bndes"
## 25: "subsetor_bndes"
## 26: "porte_do_cliente"

echo === Separando por ano - e cortando alguns campos
for ano in $anos; do
	echo === Separa $ano

	file=porAno/$ano-operacoes-financiamento-operacoes-indiretas-automaticas.csv
	echo $header > $file
	zcat operacoes-financiamento-operacoes-indiretas-automaticas.csv.gz \
		| grep "^.*;.*;.*;.*;.*;\"${ano}-" \
		| cut -d ';' -f 3-7,20-26 \
		>> $file
	gzip -f9 $file
done


# Checa se "deu ruim..." - A data agora está em outro índice
echo
for ano in $anos; do
	echo === Checa $ano

	file=porAno/$ano-operacoes-financiamento-operacoes-indiretas-automaticas.csv.gz
	zcat $file \
		| cut -d ';' -f 4 \
		| sed 's/^[^0-9]*\([0-9]\+\)-.*/\1/g' \
		| sort -u \
		| tail -n +2
done
