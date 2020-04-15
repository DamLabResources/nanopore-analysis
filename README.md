# Snakemake workflow: CRISPR nanopore analysis

[![Snakemake](https://img.shields.io/badge/snakemake-≥3.12.0-brightgreen.svg)](https://snakemake.bitbucket.io)
[![Build Status](https://travis-ci.org/snakemake-workflows/crispr-nanopore-analysis.svg?branch=master)](https://travis-ci.org/snakemake-workflows/crispr-nanopore-analysis)

This is the base repository for Nanopore analyses from the Dampier lab. It includes `docker` containers, conda environments, analysis scripts, and results notebooks. All data is kept separate place to avoid overloading git. 
## Authors

* Will Dampier (@judowill)

## Start-up

Create a new [environment file](https://docs.docker.com/compose/env-file/) that defines full paths to this directory, to the formatted data directory, and the port you would like Jupyter to listen to. Here is mine:

     JUPYTER_PORT=8888
     NANOPORE_DATA=/deepdata/nanopore
     NANOPORE_CODE=/home/will/DamLabResources/nanopore-projects

Once properly set and saved in as `.env` in the directory. You can use:

     docker-compose build
     
To fully create this environment. Then use:

     docker-compose up -d
     
To create a running Jupyter lab environment setup at `JUPYTER_PORT`.

If you are intending to run with the GPU, `docker-compose` currently does not support starting nvidia-containers. If you need GPU capacity you'll need to use the original docker commands.

`docker run nanopore/develop -p 8888:8888 -v /deepdata/nanopore:/home/jovyan/data -v /home/will/DamLabResources/nanopore-projects:/home/jovyan/`

## Dev Environment

Development is setup as a fully functional data-science notebook with GPU libraries already installed as well as most scientific/ML packages pre-installed. I have also loaded `docker` and `singularity` so you should be able to run singularity snakemake runs.  
     
It also has git installed as well as jupyterlab-git ... but that doesn't seem to be working right now.


More stuff to follow.


## Usage

### Simple

#### Step 1: Install workflow

If you simply want to use this workflow, download and extract the [latest release](https://github.com/snakemake-workflows/crispr-nanopore-analysis/releases).
If you intend to modify and further extend this workflow or want to work under version control, fork this repository as outlined in [Advanced](#advanced). The latter way is recommended.

In any case, if you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this repository and, if available, its DOI (see above).

#### Step 2: Configure workflow

Configure the workflow according to your needs via editing the file `config.yaml`.

#### Step 3: Execute workflow

Test your configuration by performing a dry-run via

    snakemake --use-conda -n

Execute the workflow locally via

    snakemake --use-conda --cores $N

using `$N` cores or run it in a cluster environment via

    snakemake --use-conda --cluster qsub --jobs 100

or

    snakemake --use-conda --drmaa --jobs 100

If you not only want to fix the software stack but also the underlying OS, use

    snakemake --use-conda --use-singularity

in combination with any of the modes above.
See the [Snakemake documentation](https://snakemake.readthedocs.io/en/stable/executable.html) for further details.

# Step 4: Investigate results

After successful execution, you can create a self-contained interactive HTML report with all results via:

    snakemake --report report.html

This report can, e.g., be forwarded to your collaborators.

### Advanced

The following recipe provides established best practices for running and extending this workflow in a reproducible way.

1. [Fork](https://help.github.com/en/articles/fork-a-repo) the repo to a personal or lab account.
2. [Clone](https://help.github.com/en/articles/cloning-a-repository) the fork to the desired working directory for the concrete project/run on your machine.
3. [Create a new branch](https://git-scm.com/docs/gittutorial#_managing_branches) (the project-branch) within the clone and switch to it. The branch will contain any project-specific modifications (e.g. to configuration, but also to code).
4. Modify the config, and any necessary sheets (and probably the workflow) as needed.
5. Commit any changes and push the project-branch to your fork on github.
6. Run the analysis.
7. Optional: Merge back any valuable and generalizable changes to the [upstream repo](https://github.com/snakemake-workflows/crispr-nanopore-analysis) via a [**pull request**](https://help.github.com/en/articles/creating-a-pull-request). This would be **greatly appreciated**.
8. Optional: Push results (plots/tables) to the remote branch on your fork.
9. Optional: Create a self-contained workflow archive for publication along with the paper (snakemake --archive).
10. Optional: Delete the local clone/workdir to free space.


## Testing

Tests cases are in the subfolder `.test`. They are automtically executed via continuous integration with Travis CI.
