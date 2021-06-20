#!/bin/bash

mkdir -p porAno

# Header
header=$( zcat operacoes-financiamento-operacoes-indiretas-automaticas.csv.gz | head -n 1 )

# Datas de contratação - remove o cabeçalho
anos=$(
	zcat operacoes-financiamento-operacoes-indiretas-automaticas.csv.gz \
		| cut -d ';' -f 6 \
		| sed 's/^[^0-9]*\([0-9]\+\)-.*/\1/g' \
		| sort -u \
		| tail -n +2
	)

# Filtra por ano
for ano in $anos; do
	file=porAno/$ano-operacoes-financiamento-operacoes-indiretas-automaticas.csv
	echo $header > $file
	zcat operacoes-financiamento-operacoes-indiretas-automaticas.csv.gz \
		| grep '".*";".*";".*";".*";".*";"$ano-' \
		>> $file
done

echo

# Checa se "deu ruim..."
for ano in $anos; do
	echo === $ano
	file=porAno/$ano-operacoes-financiamento-operacoes-indiretas-automaticas.csv
	cat $file \
		| cut -d ';' -f 6 \
		| sed 's/^[^0-9]*\([0-9]\+\)-.*/\1/g' \
		| sort -u \
		| tail -n +2
done
