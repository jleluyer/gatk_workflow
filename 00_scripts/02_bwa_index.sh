#!/bin/bash
#PBS -N bwa_index
#PBS -o bwa_index.out
#PBS -l walltime=24:00:00
#PBS -m ea 
#PBS -l ncpus=1
#PBS -l mem=100g
#PBS -r n

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Global variables
FASTA="/home1/datawork/jleluyer/00_ressources/transcriptomes/Symbiodinium_sp/clade_C1/Symbiodinium-sp-C1.nt.fa"

#move to present working dir
cd $PBS_O_WORKDIR

#

bwa index $FASTA  2> 98_log_files/"$TIMESTAMP".bwa.index.log
