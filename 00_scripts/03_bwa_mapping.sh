#!/bin/bash
#PBS -N bwa__BASE__
#PBS -o bwa__BASE__.out
#PBS -l walltime=10:00:00
#PBS -l mem=20g
#PBS -m ea 
#PBS -l ncpus=8
#PBS -q omp
#PBS -r n


TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)

# Copy script as it was run
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Global variables
DATAOUTPUT="04_mapped"
DATAINPUT="03_trimmed"
GENOME="/home1/datawork/jleluyer/00_ressources/transcriptomes/Symbiodinium_sp/clade_C1/Symbiodinium-sp-C1.nt.fa"
NCPU=8

#move to present working dir
cd $PBS_O_WORKDIR

base=__BASE__


    # Align reads
    echo "Aligning $base"
    ID=$(echo "@RG\tID:$base\tSM:$base\tPL:Illumina")

    # Align reads 1 step
    bwa mem -t "$NCPU" \
        -R "$ID" \
        "$GENOME" \
	"$DATAINPUT"/"$base"_R1.paired.fastq.gz "$DATAINPUT"/"$base"_R2.paired.fastq.gz >"$DATAOUTPUT"/"$base".sam 2> "$LOG_FOLDER"/"TIMESTAMP".bwamapping.log

    

	# Create bam file
    echo "Creating bam for $base"

    samtools view -Sb -q 1 -F 4 -F 256 \
        "$DATAOUTPUT"/"$base".sam >"$DATAOUTPUT"/"$base".bam
	
     echo "Creating sorted bam for $base"
	samtools sort "$DATAOUTPUT"/"$base".bam -o "$DATAOUTPUT"/"$base".sort.bam
   	samtools index "$DATAOUTPUT"/"$base".sort.bam 
    # Clean up
    echo "Removing "$DATAOUTPUT"/"$base".sam"
    echo "Removing "$DATAOUTPUT"/"$base".bam"

   	rm "$DATAOUTPUT"/"$base".sam
   # 	rm "$DATAOUTPUT"/"$base".bam
