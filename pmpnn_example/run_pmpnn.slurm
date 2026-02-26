!/bin/bash
 
#SBATCH --job-name=pmpnn_hiv_ex # Job name in SLURM	-> change 
#SBATCH --output=%j_output_pmpnn.txt   # Output file 
#SBATCH --error=%j_error_pmpnn.txt     # Error file 
#SBATCH --gres=gpu:1	# Number of GPUs -> do not change 
#SBATCH --mem=32G	# Memory allocation -> do not change, recommended 12-40G for RFDiffusion
#SBATCH --cpus-per-task=8	#Number of GPUs -> do not change 
#SBATCH --partition=gpu # Must use this or gpu_quad (only if pre-clinically affiliated PI, see O2 documentation) partition -> do not change 
#SBATCH --time=2:00:00 # Runtime for job -> change 

# Load cuda
module purge
#module load gcc/14.2.0
#module load cuda/12.8

# Load conda and RFdiffusion environment
source /n/data1/hms/wyss/collins/lab/software/miniconda3/etc/profile.d/conda.sh
#conda info | grep 'base environment'
conda activate pmpnn

folder_with_pdbs="./hiv_input/" # specify input folder - > change

output_dir="./hiv_outputs/hiv" # specify output folder -> change

# Create output directory if does not exist
if [ ! -d $output_dir ]
then
    mkdir -p $output_dir
fi

path_for_parsed_chains=$output_dir"/parsed_pdbs.jsonl"

python ../helper_scripts/parse_multiple_chains.py --input_path=$folder_with_pdbs --output_path=$path_for_parsed_chains

Optional troubleshooting lines to check GPU availability 
python - <<'EOF'
import torch
print("Torch:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())
print("CUDA version:", torch.version.cuda)
print("GPU:", torch.cuda.get_device_name(0) if torch.cuda.is_available() else "none")
EOF

# ProteinMPNN run inference commands
python ../protein_mpnn_run.py \
        --jsonl_path $path_for_parsed_chains \
        --out_folder $output_dir \ 
        --num_seq_per_target 1 \ -> number of output sequences per run -> change
        --sampling_temp "0.1" \
        --seed 37 \
        --batch_size 1
