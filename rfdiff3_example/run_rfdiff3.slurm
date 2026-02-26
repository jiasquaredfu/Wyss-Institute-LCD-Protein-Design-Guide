#!/bin/bash
# submit_rfdiffusion_job.slurm 	

#SBATCH --job-name=hiv_ex # Job name in SLURM	
#SBATCH --output=%j_output_rf3.txt   # Output file
#SBATCH --error=%j_error_rf3.txt     # Error file
#SBATCH --gres=gpu:1	# Number of GPUs
#SBATCH --mem=32G	# Memory allocation, recommended 12-40G for RFDiffusion
#SBATCH --cpus-per-task=8	#Number of GPUs
#SBATCH --partition=gpu
#SBATCH --job-name=rf3_inference
#SBATCH --time=2:00:00

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


# RFDiffusion run inference commands
rfd3 design n_batches=1 diffusion_batch_size=2  out_dir=./output ckpt_path=../../../../software/foundry/checkpoints/rfd3_latest.ckpt inputs=./input/hiv_binder.json skip_existing=False dump_trajectories=True prevalidate_inputs=True inference_sampler.step_scale=3 inference_sampler.gamma_0=0.2
