#!/bin/bash
# submit_rfdiffusion_job.slurm

#SBATCH --job-name=hiv_ex 
#SBATCH --output=%j_output_rf3.txt   # Output file
#SBATCH --error=%j_error_rf3.txt     # Error file
#SBATCH --gres=gpu:1
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --partition=gpu
#SBATCH --job-name=rf3_inference
#SBATCH --time=2:00:00

module purge

conda init bash
source ~/.bashrc
conda activate foundry

echo "CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES"

python - << 'EOF' # Optional, troubleshoot line to confirm if GPUs are being accessed
import torch
print("CUDA available:", torch.cuda.is_available())
if torch.cuda.is_available():
    print("Device:", torch.cuda.get_device_name(0))
    print("CUDA version:", torch.version.cuda)
EOF

rf3 fold inputs='/n/data1/hms/wyss/collins/lab/users/jiajia/3_rf3/hiv_ex/input/pmpnn_hiv_seq.json' ckpt_path='/n/data1/hms/wyss/collins/lab/software/1_backbone_design/foundry/checkpoints/rf3_foundry_01_24_latest.ckpt' out_dir='/n/data1/hms/wyss/collins/lab/users/jiajia/3_rf3/hiv_ex/output'
