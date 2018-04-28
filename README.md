# gatk_workflow
test

## Under contruction ##

## Trimming

```
00_scripts/datarmor_jobs/01_trimmomatic_pe_jobs.sh
```

## Indexing

```
qsub 00_scripts/02_bwa_index.sh
```
`

## Mapping

```
00_scripts/datarmor_jobs/03_bwa_mapping_jobs.sh
```

## Indexing GATK

```
qsub 00_scripts/04_index_ref_gatk.sh
```

## SNP calling

```
qsub 00_scripts/05_haplotypecaller.sh
```


## Prerequisites

