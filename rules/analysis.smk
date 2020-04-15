rule analyze_all:
    input:
        "analysis/Mele02.pdf"




rule notebook2pdf:
    input:
        "analysis/{name}.ipynb"
    output:
        "analysis/{name}.pdf"
    conda: '../envs/analysis.yaml'
    shell:
        "jupyter nbconvert --to pdf {input}"




rule mele02_analysis:
    input:
        expand("mapped/{barcode}.bed",
               barcode = config['barcodes'])
    log:
        notebook = 'analysis/Mele02.ipynb'
    conda: '../envs/analysis.yaml'
    output:
        read_count='analysis/read_count.png',
        read_length='analysis/read_length.png',
        read_length_sample='analysis/read_length_sample.png',
        edges_full='analysis/edges_full.png',
        edges_zoom='analysis/edges_zoom.png'
    notebook:
        "../notebooks/Mele02_analysis.ipynb"
        
    
        