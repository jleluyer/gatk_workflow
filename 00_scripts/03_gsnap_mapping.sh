#!/bin/bash
#PBS -N gsnap__BASE__
#PBS -o gsnap__BASE__.out
#PBS -e gsnap__BASE__.err
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
GENOMEFOLDER="/home1/datawork/jleluyer/00_ressources/transcriptomes/Symbiodinium_sp/clade_C1"
GENOME="gmap_symbiodiniumspC1"
platform="Illumina"
#move to present working dir
cd $PBS_O_WORKDIR

base=__BASE__


    # Align reads
    echo "Aligning $base"

    gsnap --gunzip -t 8 -A sam --min-coverage=0.90 \
	--dir="$GENOMEFOLDER" -d "$GENOME" \
        -o "$DATAOUTPUT"/"$base".sam \
	--read-group-id="$base" \
	 --read-group-platform="$platform" \
	"$DATAINPUT"/"$base"_R1.paired.fastq.gz "$DATAINPUT"/"$base"_R2.paired.fastq.gz 2>"$LOG_FOLDER"/log.gsnap."TIMESTAMP"

    # Create bam file
    echo "Creating bam for $base"

    samtools view -Sb -q 1 -F 4 -F 256 \
        "$DATAOUTPUT"/"$base".sam >$DATAOUTPUT/"$base".bam
	
     echo "Creating sorted bam for $base"
	samtools sort -n "$DATAOUTPUT"/"$base".bam -o "$DATAOUTPUT"/"$base".sorted
    
    # Clean up
    echo "Removing "$DATAOUTPUT"/"$base".sam"
    echo "Removing "$DATAOUTPUT"/"$base".bam"

   	rm "$DATAOUTPUT"/"$base".sam
    	rm "$DATAOUTPUT"/"$base".bam
