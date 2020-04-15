# An example collection of Snakemake rules imported in the main Snakefile.


rule basecall_all:
    input:
        expand("fastq_pass/{bc}/{bc}.merged.fastq.gz",
               bc = config['barcodes'])



rule merge_barcodes:
    input:
        "fastq_pass/{barcode}/calling.done"
    output:
        "fastq_pass/{barcode}/{barcode}.merged.fastq.gz"
    shell:
        "cat fastq_pass/{wildcards.barcode}/*.fastq | gzip -9 > {output}"


rule guppy_basecall:
    input:
        "fast5_pass/{barcode}/files.list",
    output:
        "fastq_pass/{barcode}/calling.done"
    singularity:
        "docker://genomicpariscentre/guppy-gpu"
    threads: 8
    resources:
        gpu=1
    shell:
        "guppy_basecaller --device cuda:0 --cpu_threads_per_caller {threads} --num_callers 1 --input_file_list {input} -s fastq_pass/{wildcards.barcode} -c dna_r9.4.1_450bps_hac.cfg; "
        "touch {output}"
       
    
rule make_file_list:
    output:
        temp("fast5_pass/{barcode}/files.list")
    shell:
        "ls fast5_pass/{wildcards.barcode}/*.fast5 > {output}"
        
        
        
        
        
        