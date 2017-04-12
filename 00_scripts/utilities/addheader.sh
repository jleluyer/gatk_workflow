#!/bin/bash
#PBS -N gatk_addheader
#PBS -o gatk_addheader.out
#PBS -l walltime=02:00:00
#PBS -l mem=20g
#PBS -l ncpus=1
#PBS -r n


TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"


cd $PBS_O_WORKDIR

# Global variables
reference_fa="/home1/datawork/jleluyer/00_ressources/transcriptomes/Symbiodinium_sp/clade_C1/Symbiodinium-sp-C1.nt.fa"
HEAD_JAR="/datawork/fsi1/bioinfo/home12-copycaparmor/softs/sources/picard/picard-tools-1.88/picard-tools-1.88/AddOrReplaceReadGroups.jar"


nb=1

for i in $(ls 04_mapped/*.sort.bam|sed 's/.sort.bam//g')
do

java -jar $HEAD_JAR I="$i".sort.bam O="$i".header.bam ID=$nb LB=$nb PL=illumina PU=$nb SM=$nb  2>"$LOG_FOLDER"/"$TIMESTAMP".header.log

nb=$(echo $nb + 1|bc)

done

# Merge and prepare bam

samtools merge 04_mapped/pooled.bam 04_mapped/*header.bam

samtools sort 04_mapped/pooled.bam -o 04_mapped/pooled.sort.bam

samtools index 04_mapped/pooled.sort.bam


# Clean up 

rm 04_mapped/pooled.bam
