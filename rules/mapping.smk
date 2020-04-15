# An example collection of Snakemake rules imported in the main Snakefile.


rule map_all:
    input:
        expand("mapped/{barcode}.bed",
               barcode = config['barcodes'])


rule make_bed:
    input:
        "mapped/{barcode}.sorted.bam"
    output:
        "mapped/{barcode}.bed"
    conda: "../envs/mapping.yaml"
    shell:
        "bedtools bamtobed -i {input} > {output}"

rule filter_and_sort:
    input:
        reads="mapped/{barcode}.sam",
        fa_index=config['reference'] + '.fai'
    output:
        bam="mapped/{barcode}.sorted.bam",
        index="mapped/{barcode}.sorted.bam.bai"
    conda: "../envs/mapping.yaml"
    threads: 8
    shell:
        "samtools view -bt {input.fa_index} {input.reads} | samtools sort --threads {threads} -o {output.bam}; samtools index {output.bam}"

  
rule map_genome:
    input:
        reads="fastq_pass/{barcode}/{barcode}.merged.fastq.gz",
        ref=ancient(config['reference'])
    output:
        temp("mapped/{barcode}.sam")
    conda: "../envs/mapping.yaml"
    shell:
        "lastal -s 2 -q 1 -b 1 -a 1 -e 45 -T 0 -Q 0 -a 1 {input.ref} {input.reads} | maf-convert sam > {output}"
        
        
rule index_genome:
    input:
        ancient(config['reference'])
    output:
        expand(config['reference']+'{ext}', ext=[".bck", ".des", ".prj", 
        ".sds", ".ssp", ".suf", ".tis", ".fai"])
    conda: "../envs/mapping.yaml"
    shell:
        "lastdb {input} {input}; samtools faidx {input}; touch ref/REF"
    
        
        
        
        