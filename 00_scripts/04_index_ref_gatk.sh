#!/bin/bash
#PBS -N gatk_index
#PBS -o gatk_index.out
#PBS -l walltime=02:00:00
#PBS -l mem=60g
#PBS -l ncpus=1
#PBS -r n


TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)

# Copy script as it was run
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

cd $PBS_O_WORKDIR

# Global variables
reference_fa="/home1/datawork/jleluyer/00_ressources/transcriptomes/Symbiodinium_sp/clade_C1/Symbiodinium-sp-C1.nt.fa"
DICT_JAR="/datawork/fsi1/bioinfo/home12-copycaparmor/softs/sources/picard/picard-tools-1.88/picard-tools-1.88/CreateSequenceDictionary.jar"
output="/home1/datawork/jleluyer/00_ressources/transcriptomes/Symbiodinium_sp/clade_C1/Symbiodinium-sp-C1.nt.dict"

java -jar $DICT_JAR REFERENCE=$reference_fa OUTPUT=$output 2>"$LOG_FOLDER"/log.index."$TIMESTAMP"


samtools faidx $reference_fa
