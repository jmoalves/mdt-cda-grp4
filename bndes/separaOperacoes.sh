#!/bin/bash

# Datas de contratação - remove o cabeçalho
anos=$(
	zcat operacoes-financiamento-operacoes-indiretas-automaticas.csv.gz \
		| cut -d ';' -f 6 \
		| sed 's/^[^0-9]*\([0-9]\+\)-.*/\1/g' \
		| sort -u \
		| tail -n +2
	)

for ano in $anos; do
	zcat operacoes-financiamento-operacoes-indiretas-automaticas.csv.gz \
		| grep $ano \
		| gzip \
		> $ano-operacoes-financiamento-operacoes-indiretas-automaticas.csv.gz
done
