#!/bin/bash
for f in ./docked/6w9c/AC/1/logs/*.log; do
   score=$(grep -m 1 '   1   ' $f | awk '{print $2}')
   echo $(basename $f .log),$score
   #mv $f 5r80_e/logs/part3/parsed/
done > scores.csv
# sort
sort -t, -nk2 scores.csv > sorted_scores.csv
