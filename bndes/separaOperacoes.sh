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

for ano in $anos; do
	echo === Separa $ano

	file=porAno/$ano-operacoes-financiamento-operacoes-indiretas-automaticas.csv
	echo $header > $file
	zcat operacoes-financiamento-operacoes-indiretas-automaticas.csv.gz \
		| grep "^.*;.*;.*;.*;.*;\"${ano}-" \
		>> $file
	gzip -9 $file
done


# Checa se "deu ruim..."
echo
for ano in $anos; do
	echo === Checa $ano

	file=porAno/$ano-operacoes-financiamento-operacoes-indiretas-automaticas.csv.gz
	zcat $file \
		| cut -d ';' -f 6 \
		| sed 's/^[^0-9]*\([0-9]\+\)-.*/\1/g' \
		| sort -u \
		| tail -n +2
done
