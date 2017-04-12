#!/bin/bash
#PBS -N gatk
#PBS -o gatk_variant.out
#PBS -l walltime=02:00:00
#PBS -l mem=60g
#PBS -l ncpus=8
#PBS -q omp
#PBS -r n

cd $PBS_O_WORKDIR


TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"


# Global variables
reference_fa="/home1/datawork/jleluyer/00_ressources/transcriptomes/Symbiodinium_sp/clade_C1/Symbiodinium-sp-C1.nt.fa"
output_variants="05_results/raw_variants.vcf"
output_snp="05_results/raw_snps.vcf"
GATK_JAR="/datawork/fsi1/bioinfo/home12-copycaparmor/softs/sources/GATK/GenomeAnalysisTK.jar"
tmp="/home1/scratch/jleluyer/"

java -jar -Djava.io.tmpdir=$tmp $GATK_JAR \
	-T HaplotypeCaller \
	-R $reference_fa \
	-I 04_mapped/pooled.sort.bam \
	--min_base_quality_score 10 \
	#--num_threads 8 \
	--num_cpu_threads_per_data_thread 8 \
	--genotyping_mode DISCOVERY \
	-stand_emit_conf 10 \
	-stand_call_conf 30 \
	--out $output 2>"$LOG_FOLDER"/"$TIMESTAMP".haplotypecaller.log
exit
java -jar $GATK_JAR \ 
    -T SelectVariants \ 
    -R $reference_fa \ 
    -V $output_variants \ 
    -selectType SNP \ 
    -o $output_snp 2>"$LOG_FOLDER"/"$TIMESTAMP".selectvariant.log
