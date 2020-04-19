# Without log
WORKDIR="/home/mhassan/covid19"
VINA_CMD="$WORKDIR/software/qvina/bin/qvina02"
#VINA_CMD="$WORKDIR/software/autodock_vina_1_1_2_linux_x86/bin/vina"
for protein in "$WORKDIR/proteins/"*.pdbqt; do
   PROTEIN=$(basename -- "$protein")
   PROTEIN_DIR=$PWD/${PROTEIN%.*}
   mkdir $PROTEIN_DIR
   for dir in $(ls -d "$WORKDIR"/data/part*); do
      PART=$(basename -- $dir)
      OUTPUT_DIR=$PROTEIN_DIR/docked/$PART; mkdir -p $OUTPUT_DIR
      LOG_DIR=$PROTEIN_DIR/logs/$PART; mkdir -p $LOG_DIR
      SCORES=$PROTEIN_DIR/$PART.csv
      for file in "$dir"/*.pdbqt; do
         outputfile="$OUTPUT_DIR/$(basename -- ${file%.*}).docked"
         logfile="$LOG_DIR/$(basename -- ${file%.*}).log"
         echo "timeout 300s $VINA_CMD --receptor $protein --ligand $file --center_x 8.5 --center_y -3.6 --center_z 18.7 --size_x 22 --size_y 22 --size_z 22 --out $outputfile --log $logfile"
         # Write score
         #echo "timeout 300s $VINA_CMD --receptor $protein --ligand $file --center_x 8.5 --center_y -3.6 --center_z 18.7 --size_x 42 --size_y 24 --size_z 62 --out $outputfile --log $logfile | grep -m 1 '   1   ' | awk '{ print \"$(basename -- ${file%.*})\", \$2 }' >> $SCORES"
         #echo "timeout 300s $VINA_CMD --receptor $protein --ligand $file --center_x 12.21 --center_y 1.81 --center_z 23.51 --size_x 20 --size_y 20 --size_z 20 --out $outputfile --log $logfile | grep -m 1 '   1   ' | awk '{ print \"$(basename -- ${file%.*})\", \$2 }' >> $SCORES"
      done > $PROTEIN_DIR/run_${PART}.sh
   done
done
~