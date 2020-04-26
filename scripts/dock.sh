#!/bin/bash
if [ ! $# -eq 3 ]; then
   echo "Usage: dock.sh <output_dir> <config> <ligands>"
   echo "Example: dock.sh ./output proteins/5r80.config ./ligands"
   exit 1
fi
# Without log
WORKDIR=$PWD
OUTPUTDIR=$1
CONFIG=$(realpath $2)
LIGANDS=$3
#LIGANDS="/scratch/02875/docking/ligands/Enamine-HTSC"
#LIGANDS="/scratch/02875/docking/ligands/Enamine-PC"
DOCKDIR=$OUTPUTDIR/docked; mkdir -p $DOCKDIR
RESULTS=$OUTPUTDIR/results; mkdir -p $RESULTS
#LOGDIR=$OUTPUTDIR/logs; mkdir -p $LOGDIR
VINA="/scratch/03864/suman1/COVID19/qvina/bin/qvina02"

my_grep=`which grep`
my_awk=`which awk`


for ligand in "$LIGANDS"*.pdbqt; do
#for ligand in "$LIGANDS"/"$PART"/*.pdbqt; do
   outputfile="$DOCKDIR"/$(basename -- ${ligand%.*}).docked
   #logfile="$LOGDIR"/$(basename -- ${ligand%.*}).log
   vina="timeout 120s $VINA --ligand $ligand --config $CONFIG --out $outputfile ;"
   parse="echo \"$( basename ${outputfile} .docked ),\$($my_grep -m 1 \"REMARK VINA RESULT:\" ${outputfile} | $my_awk '{ print \$4 }')\" >>  ${RESULTS}/run_\$LAUNCHER_TSK_ID "
   echo "$vina $parse"
   
   #echo "timeout 300s $VINA_CMD --receptor $PROTEIN --ligand $file --center_x 8.5 --center_y -3.6 --center_z 18.7 --size_x 22 --size_y 22 --size_z 22 --out $outputfile --log $logfile"
   done > "$OUTPUTDIR"/dock_"$(basename ${LIGANDS})".sh
