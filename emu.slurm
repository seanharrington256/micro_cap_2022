#!/bin/bash

#SBATCH --job-name=emu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=10G
#SBATCH --time=2:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=seanharrington256@gmail.com
#SBATCH --account=inbreh
#SBATCH -e errs_outs/err_emu_%A_%a.err
#SBATCH -o errs_outs/std_emu_%A_%a.out
#SBATCH --array=1-9



## Slurm script for running emu on the ONT data for the micro capstone class

# set the working directory
cd /home/sharrin2/inbreh/erins_nanopore/capstone_ont/SoilLib/20221108_1533_MN34633_FAO61894_853a1875/GuppyOutFastqs


# load up miniconda 
module load miniconda3/4.10.3

# if you have not already created an emu environment and installed it with conda, uncomment and run these lines (recommend doing it interactively on the command line, not in this script)
#conda create --name emu python=3.7 
#conda config --add channels defaults
#conda config --add channels bioconda
#conda config --add channels conda-forge
#conda install emu

# wget https://gitlab.com/treangenlab/emu/-/archive/v3.0.0/emu-v3.0.0.tar.gz   # get the emu database:
# tar -xvz --strip-components=2 emu-v3.0.0/emu_database/       # extract it  - in the next command --db will need to point to this directory


# activate emu environment
conda activate emu

# get a list of the barcodes directories and then pick out just one based on the slurm ID
for x in barcode*  # get a bash array that has the names of all of the barcodes dirs - skip the unclassified because I don't think we can use it
do   
  dirs=(${dirs[@]} "${x}")
done


barcode=/home/sharrin2/inbreh/erins_nanopore/capstone_ont/SoilLib/20221108_1533_MN34633_FAO61894_853a1875/GuppyOutFastqs/${dirs[($SLURM_ARRAY_TASK_ID-1)]}/pass  # variable for the passed reads in the current barcode

# concatenate all the fastqs together
cd $barcode
cat fastq_runid*.fastq > ${dirs[($SLURM_ARRAY_TASK_ID-1)]}_all_.fastq

# get a variable of the fastq for emu
in_fastq=$barcode/${dirs[($SLURM_ARRAY_TASK_ID-1)]}_all_.fastq

cd /home/sharrin2/inbreh/erins_nanopore/capstone_ont/SoilLib # move up so the results go here


# Run emu
emu abundance --type map-ont $in_fastq --keep-counts --keep-read-assignments --threads 10 --db /home/sharrin2/inbreh/erins_nanopore/emu_test/database





