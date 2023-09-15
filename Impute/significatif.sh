#!/bin/bash

cat Model/Tako*new.tri.model | awk '($10 != "NA") && ($10+0 < 1e-05)' | grep -v "CHR\|TREND" > TopSNP.txt
