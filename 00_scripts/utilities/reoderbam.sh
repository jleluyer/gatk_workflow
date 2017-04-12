#!/bin/bash
#PBS -N gatk_reorder
#PBS -o gatk_reorder.out
#PBS -l walltime=02:00:00
#PBS -l mem=20g
#PBS -l ncpus=1
#PBS -r n


cd $PBS_O_WORKDIR

# Global variables
reference_fa="/home1/datawork/jleluyer/00_ressources/transcriptomes/Symbiodinium_sp/clade_C1/Symbiodinium-sp-C1.nt.fa"
REOR_JAR="/datawork/fsi1/bioinfo/home12-copycaparmor/softs/sources/picard/picard-tools-1.88/picard-tools-1.88/ReorderSam.jar"

for i in $(ls 04_mapped/*.bam|sed 's/.bam//g')
do

java -jar $REOR_JAR I="$i".bam O="$i".reorder.bam  R=$reference_fa CREATE_INDEX=true  2> log.reord
done



# sort and build index
SORT_JAR="/datawork/fsi1/bioinfo/home12-copycaparmor/softs/sources/picard/picard-tools-1.88/picard-tools-1.88/SortSam.jar"

for i in $(ls 04_mapped/*.bam|sed 's/.bam//g')
do

java -jar $SORT_JAR I="$i".bam O="$i".sortgatk.bam  SORT_ORDER=coordinate CREATE_INDEX=true 2>log.sort
done

