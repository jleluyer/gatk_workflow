#!/bin/bash
#PBS -N gatk
#PBS -o gatk_variant.out
#PBS -l walltime=02:00:00
#PBS -l mem=60g
#PBS -l ncpus=8
#PBS -q omp
#PBS -r n


cd $PBS_O_WORKDIR

# Global variables
reference_fa="/home1/datawork/jleluyer/00_ressources/transcriptomes/Symbiodinium_sp/clade_C1/Symbiodinium-sp-C1.nt.fa"
output_variants="03_results/raw_variants.vcf"
output_snp="03_results/raw_snps.vcf"
GATK_JAR="/datawork/fsi1/bioinfo/home12-copycaparmor/softs/sources/GATK/GenomeAnalysisTK.jar"

java -jar $GATK_JAR \
	-T HaplotypeCaller \
	-R $reference_fa \
	-I 02_data/SRR1300433.reorder.bam \
	--genotyping_mode DISCOVERY \
	-stand_emit_conf 10 \
	-stand_call_conf 30 \
	--out $output 2> log.haplotypecaller.txt
exit
java -jar $GATK_JAR \ 
    -T SelectVariants \ 
    -R $reference_fa \ 
    -V $output_variants \ 
    -selectType SNP \ 
    -o $output_snp 2> log.selectvariants.txt
