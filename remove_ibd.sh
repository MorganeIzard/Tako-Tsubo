#!/bin/bash
plink --file NEW_SC --genome
LC_NUMERIC=C awk '($10 > 0.125)' plink.genome > ibd.txt
sed '1d' ibd.txt > tmp.txt
awk '!($5="")' tmp.txt > tempo.txt
awk '!($5="")' tempo.txt > ibd.txt
awk '!($5="")' ibd.txt > tempo.txt
awk '!($5="")' tempo.txt > ibd.txt
awk '!($5="")' ibd.txt > tempo.txt
awk '!($5="")' tempo.txt > ibd.txt
awk '!($5="")' ibd.txt > tempo.txt
awk '!($5="")' tempo.txt > ibd.txt
awk '!($5="")' ibd.txt > tempo.txt
awk '!($5="")' tempo.txt > ibd.txt
rm tempo.txt
rm tmp.txt

