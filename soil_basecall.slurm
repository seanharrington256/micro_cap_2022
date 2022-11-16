#!/bin/bash

#SBATCH --job-name=guppy
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=32G
#SBATCH --time=72:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=seanharrington256@gmail.com
#SBATCH --account=inbreh
#SBATCH -e err_guppy_cpu_%A_%a.err
#SBATCH -o std_guppy_cpu_%A_%a.out
#SBATCH --array=1-20



# Set the working directory
cd /home/sharrin2/inbreh/erins_nanopore/capstone_ont/SoilLib/20221108_1533_MN34633_FAO61894_853a1875

# Load up the basecaller
module load guppy-cpu/6.0.1

# move into the fast5
cd fast5_pass

# loop to get the barcode directories
for x in barcode*  # get a bash array that has the names of all of the barcodes dirs - skip the unclassified because I don't think we can use it
do   
  dirs=(${dirs[@]} "${x}")
done

cd ..

barcode=${dirs[($SLURM_ARRAY_TASK_ID-1)]}


guppy_basecaller -i fast5_pass/$barcode -s GuppyOutFastqs/$barcode --flowcell FLO-MIN106 --kit SQK-16S024 --cpu_threads_per_caller 32 cuda:all



