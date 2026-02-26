#!/bin/bash
# submit_rfdiffusion_job.slurm 	

#SBATCH --job-name=rf3_ex # Job name in SLURM	
#SBATCH --output=%j_output_rf3.txt   # Output file
#SBATCH --error=%j_error_rf3.txt     # Error file
#SBATCH --gres=gpu:1	# Number of GPUs
#SBATCH --mem=32G	# Memory allocation, recommended 12-40G for RFDiffusion
#SBATCH --cpus-per-task=8	#Number of GPUs
#SBATCH --partition=gpu # Must use this or gpu_quad (only if pre-clinically affiliated PI, see O2 documentation) partition 
#SBATCH --time=2:00:00 # Runtime for job 

# Initializing environments
module purge
conda init bash
source ~/.bashrc
conda activate foundry


# Optional troubleshooting lines to check GPU availability 

echo "CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES"
python - << 'EOF'
import torch
print("CUDA available:", torch.cuda.is_available())
if torch.cuda.is_available():
    print("Device:", torch.cuda.get_device_name(0))
    print("CUDA version:", torch.version.cuda)
EOF


# RoseTTAFold run inference commands
rf3 fold inputs='/n/data1/hms/wyss/collins/lab/users/jiajia/3_rf3/hiv_ex/input/pmpnn_hiv_seq.json' ckpt_path='/n/data1/hms/wyss/collins/lab/software/1_backbone_design/foundry/checkpoints/rf3_foundry_01_24_latest.ckpt' out_dir='/n/data1/hms/wyss/collins/lab/users/jiajia/3_rf3/hiv_ex/output' ->change input, output
