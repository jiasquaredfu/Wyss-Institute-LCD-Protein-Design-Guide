#!/bin/bash

#SBATCH --job-name=pmpnn_hiv_ex
#SBATCH --partition=gpu
#SBATCH --mem=64g
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4        
#SBATCH --time=2:30:00 
#SBATCH --output=%j_output_rf3.txt   # Output file
#SBATCH --error=%j_error_rf3.txt  # Error file


# Check GPU utilization
/n/cluster/bin/job_gpu_monitor.sh &

# Load cuda
module purge
#module load gcc/14.2.0
#module load cuda/12.8

# Load conda and RFdiffusion environment
source /n/data1/hms/wyss/collins/lab/software/miniconda3/etc/profile.d/conda.sh
#conda info | grep 'base environment'
conda activate pmpnn

folder_with_pdbs="./hiv_input/"

output_dir="./hiv_outputs/hiv"
if [ ! -d $output_dir ]
then
    mkdir -p $output_dir
fi

path_for_parsed_chains=$output_dir"/parsed_pdbs.jsonl"

python ../helper_scripts/parse_multiple_chains.py --input_path=$folder_with_pdbs --output_path=$path_for_parsed_chains

python - <<'EOF'
import torch
print("Torch:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())
print("CUDA version:", torch.version.cuda)
print("GPU:", torch.cuda.get_device_name(0) if torch.cuda.is_available() else "none")
EOF


python ../protein_mpnn_run.py \
        --jsonl_path $path_for_parsed_chains \
        --out_folder $output_dir \
        --num_seq_per_target 1 \
        --sampling_temp "0.1" \
        --seed 37 \
        --batch_size 1
