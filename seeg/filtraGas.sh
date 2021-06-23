#!/bin/bash

file=SEEG8-Brasil-2020.11.05.csv.gz
gas="CO2e (t) GWP-AR5"
newFile=$(basename $file .csv.gz).co2e-ar5.csv

echo === Header
header=$( zcat $file | head -n 1 )

echo === Filtrando $gas em $file para $newFile
echo $header > $newFile
zcat $file \
	| grep "^.*;.*;.*;.*;.*;.*;.*;${gas};" \
	>> $newFile 
gzip -f9 $newFile
