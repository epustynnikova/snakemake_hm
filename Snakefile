species_res = [".bionj", ".iqtree", ".mldist", ".treefile", ".ckp.gz", ".log", ".model.gz"]

def get_file_names(wildcards):
    checkpoint_output = checkpoints.copy.get(**wildcards).output[0]
    samples = glob_wildcards(os.path.join(checkpoint_output, "{sample}.fna")).sample
    return expand("results/mafft/{sample}.fna", sample=samples)

rule all:
    input:
        expand("results/iqtree/species{species_res}", species_res=species_res)

checkpoint copy:
    input:
        "Files"
    output:
        directory("results/genes")
    conda:
        "conda.yaml"
    shell:
        "bash scripts/cp.sh {input} {output}"

rule maffts:
    input:
        "results/genes/{sample}"
    output:
        "results/mafft/{sample}"
    conda:
        "conda.yaml"
    shell:
        "mafft --auto {input} > {output}"

rule iqtree:
    input:
        get_file_names
    output:
        expand("results/iqtree/species{species_res}", species_res=species_res)
    params:
        prefix="results/iqtree/species"
    conda:
        "conda.yaml"
    shell:
        "iqtree -s results/mafft --prefix {params.prefix}"
