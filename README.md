# Wyss-Institute-LCD-Protein-Design-Guide
Greetings! This README will walk you through how to access the HMS O2 Cluster, access our protein design tools, activate the necessary dependencies and finally how to design de novo mini binders! 

#### :warning: Protein design work requires knowledge of basic syntax in terminal/VIM, SLURM, and Conda. If you have not heard of these before, this page contains crucial commands to reference [here](./command_cheatsheet.md)! :warning:

# Accessing the Cluster :computer:

1. Lab members will first need to complete the [RC PPMS Billing Account form](https://tinyurl.com/request-PPMS-account) before they can request an O2 account 
2. Lab members will then need an O2 account to request an O2 account on the [Research Computing website](https://tinyurl.com/request-O2-account)

Once complete, open your Terminal and login to your user-specific login node:
<pre> ssh Your_HMS_ID@o2.hms.harvard.edu </pre>

You can then navigate to our software folder located at this directory:

<pre> cd /n/data1/hms/wyss/collins/lab/software </pre>


# Setup Before Running Pipeline :satellite:

<b>
There are three setup steps needed before the pipeline can run. 
</b>

1. Initializing Conda on the Cluster <br>
 a. Adding conda to your bash <br>
 b. Loading Environments <br>
2. Creating your Personal Folder on the Cluster 
3. Downloading Pymol on your Computer 

<b> You only need to run these setup steps once! </b>


:warning: Start setup by requesting an interactive session on the O2 cluster. :warning: Setup or debugging, or <b> anything you are not submitting via SLURM job </b> should be done in one of these! Otherwise the SLURM scheduler will kill the job and send you an email saying not to run intensive jobs in the login node :) 

<pre> srun --pty -p interactive -t 2:00:00 -c 8 --mem=32G bash </pre>

The above command allocates 8 CPUs and 32G of memory for a 2 hour session.

## Conda :snake:
Conda is a python-based package management system. It runs "environments" which are essentially directories with isolated software packages. We need to setup your cluster account to be able to access the shared conda and create different conda environments to run different protein design software. 

### Adding Conda to Bash
1. Initialize conda for your account
<pre> /n/data1/hms/wyss/collins/lab/software/miniconda3/bin/conda init bash </pre>

2. Reload your shell
<pre> source ~/.bashrc </pre>
You may need to type exit and re-ssh back into the cluster for this to work. 

3. Verify installation
<pre> which conda </pre>
<pre> conda --version  </pre>

Your terminal should print something like this:

<pre>

 conda ()
{ 
    \local cmd="${1-__missing__}";
    case "$cmd" in 
        activate | deactivate)
            __conda_activate "$@"
        ;;
        install | update | upgrade | remove | uninstall)
            __conda_exe "$@" || \return;
            __conda_activate reactivate
        ;;
        *)
            __conda_exe "$@"
        ;;
    esac
}

conda 25.11.1

</pre>

If this doesn't work, we have to manually configure conda into your bash (these steps also only need to be completed once):

1. Open bashrc using the VIM editor
    <pre> vi ~/.bashrc </pre>
2. Type i, you should see --INSERT appear at the bottom of the file. 
3. Copy paste these lines at the bottom of the file:
<pre> export PATH="/n/data1/hms/wyss/collins/lab/software/miniconda3/bin:$PATH"
source /n/data1/hms/wyss/collins/lab/software/miniconda3/etc/profile.d/conda.sh </pre>
4. Save by typing :wq and enter
4. Reload with <pre> source ~/.bashrc </pre> and re-ssh if needed
5. Verify installation <pre> which conda </pre>
<pre> conda --version  </pre>


### Loading Conda Environments 
Each protein design tool needs a specific conda environment setup with necessary packages in order to run. You will load the appropriate environments from pre-made yaml files!

1. Navigate to the yaml folder

<pre> cd /n/data1/hms/wyss/collins/lab/software/miniconda3/env_ymls  </pre>

2. Create the needed environments
<pre> conda env create -f foundry.yml </pre>
<pre> conda env create -f pmpnn.yml </pre>

3. Verify loaded environments

<pre> conda env list </pre>

The output should look like this:
<pre> 
# conda environments:
#
# * -> active
# + -> frozen
base                 *   /n/data1/hms/wyss/collins/lab/software/miniconda3
foundry                  /n/data1/hms/wyss/collins/lab/software/miniconda3/envs/foundry
pmpnn                    /n/data1/hms/wyss/collins/lab/software/miniconda3/envs/pmpnn </pre>


To test any software with their respective environments, you can activate the environment this way:

<pre> conda activate {env_name} </pre>

If you get this error: 

<pre> CondaToSNonInteractiveError: Terms of Service have not been accepted for the following channels. Please accept or remove them before proceeding:
    - https://repo.anaconda.com/pkgs/main
    - https://repo.anaconda.com/pkgs/r </pre>

Just type:
<pre> conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r  </pre>
 and retry. 


 ## Creating your Personal Folder :open_file_folder:
To keep your work organized and prevent accidental conflicts with the shared software folder, please make your own folder on the cluster to store inputs and outputs.

1. Navigate to the users folder
<pre> cd /n/data1/hms/wyss/collins/lab/users </pre>

2. Create a personal directory for each step of the workflow. You can duplicate my folder or make your own and cd into my folder to see an example setup structure

<pre> cp -r jiajia {your_name} </pre>
or 
<pre> mkdir {your_name} </pre>


 ## Pymol :tv:
Pymol is a protein structure visualization software. This allows you to visually inspect the structure you design throughout the pipeline steps and conduct preliminary analyses and filtering. Pymol is downloaded off the cluster, on your laptop. <b> You only need to run these setup steps once </b>!

1. Download the educational Pymol [here](https://pymol.org/edu/) using your Wyss or HMS email
2. You should see a UI like this, and be able to load .pdb or .cif files and play around with the structures.<img width="1120" height="974" alt="image" src="https://github.com/user-attachments/assets/41446ea8-6a72-4c97-8a87-31c232642c56" />
3. Learn basic Pymol commands in the cheat sheet [here](./command_cheatsheet.md)!


# Running the Pipeline :runner:
<img width="865" height="609" alt="image" src="https://github.com/user-attachments/assets/2a8b2178-7ffd-4f73-8587-e5721da5b795" />

<b> Finally it's time for the fun stuff! </b>

The "standard" protein design pipeline is composed of 3 steps:

### 1. Backbone design (User Parameters → Structure)

- Generates the 3D scaffold for your target design, such as a binder, enzyme, or *de novo* protein  
- The cluster setup has RFDiffusion2 (CPU-only) and RFDiffusion3 through Rosetta Commons' Foundry  
- Our recommended pipeline uses **RFDiffusion3**, paper linked [here](https://www.biorxiv.org/content/10.1101/2025.09.18.676967v1)

---

### 2. Sequence design (Structure → Sequence)

- Assigns an amino acid sequence which folds into the bare backbone structure  
- The cluster setup has LigandMPNN and ProteinMPNN  
- Our recommended pipeline uses **ProteinMPNN**, paper linked [here](https://www.science.org/doi/10.1126/science.add2187)

---

### 3. Structure prediction (Sequence → Structure)

- Validates structure by folding into final conformation, allowing for computational analysis and filtering before experimental validation  
- The cluster setup has Boltz, BindCraft, ColabFold, and RoseTTAFold3 through Rosetta Commons' Foundry  
- Our recommended pipeline uses **RoseTTAFold3**, paper linked [here](https://www.biorxiv.org/content/10.1101/2025.08.14.670328v2)

 Here's a little table which summarizes what goes in and out for all 3 steps:

| Step | Input | Output |
|------|-------|--------|
| RFDiffusion3 | `.pdb` file of target structure<br>`.json` file containing design parameters | `.cif.gz` structure file containing backbone with alpha carbons only |
| ProteinMPNN | `.pdb` file of backbone from RFdiffusion | `.fa` sequence file (chains separated by `/`) |
| RoseTTAFold3 | `.json` file containing sequence(s) from the ProteinMPNN `.fa` file | `.cif` structure file(s) |

For additional context on each tool and target applications protein design can tackle, we have overview slides [here](https://hu-my.sharepoint.com/:p:/g/personal/dawningjiaxi_fu_wyss_harvard_edu/EVwylZ5jwstJlKK3unATEh4BOkJ3t_kOPiGjVQT0rVE__A?e=bCCi2G). Each software's official Github documentation are linked in the headers below if you want download the models locally and adjust them yourself. 

:warning:
Before you embark on a design campaign, ensure you know what your target is! These newer tools like RFDiffusion3 and RoseTTAFold3 are atomistic. This means instead of inputs at a residue level, you need to specify exactly what side chain atoms you want to diffuse or design protein-protein interactions with. You may need to provide an input template for RFDiffusion. For the example in this Github, to create a HIV minibinder, I supplied a constrained structure file of the HIV spike protein I want to bind to. I also supplied "hotspot residues" and estimated which atoms would be most relevant for binding. The input types will depend on your application, such as binders, homooligomers, enzymes, etc. I highly recommend looking at other examples in the RFDiffusion Github for different use cases. Literature review before designing is extremely important! :warning:

Now... with target established... without further ado!

## [RFDiffusion3](https://github.com/RosettaCommons/foundry/blob/production/models/rfd3/README.md) :art:

1. Load foundry conda environment

<pre> conda activate foundry  </pre>
 Your command line should say (foundry) instead of (base) to the left of your cursor
 
2. Ensure you have a SLURM script, input and output folders for each project you are completing and enter the folder. Refer to examples [here](./rfdiff3_example)

<pre> cd rfdiff3_example </pre>

3. Add your input . 
4. Open the input .JSON with a file editor. Example linked [here](./rfdiff3_example/run_rfdiff3.slurm)
<pre> vi run_rfdiff3.slurm </pre>
4.
5.
6. Open the SLURM script in file editor. Example linked [here](./rfdiff3_example/run_rfdiff3.slurm)
<pre> vi run_rfdiff3.slurm </pre>

4. Adjust batch script parameters 

<pre>
#!/bin/bash
# submit_rfdiffusion_job.slurm 	

#SBATCH --job-name=hiv_ex # Job name in SLURM	-> change 
#SBATCH --output=%j_output_rfdiff3.txt   # Output file -> change file name, optional
#SBATCH --error=%j_error_rfdiff3.txt     # Error file -> change file name, optional
#SBATCH --gres=gpu:1	# Number of GPUs -> do not change 
#SBATCH --mem=32G	# Memory allocation -> do not change, recommended 12-40G for RFDiffusion
#SBATCH --cpus-per-task=8	#Number of GPUs -> do not change 
#SBATCH --partition=gpu # Must use this or gpu_quad (only if pre-clinically affiliated PI, see O2 documentation) partition -> do not change 
#SBATCH --time=2:00:00 # Runtime for job -> change optional
</pre>

5. # RFDiffusion run inference commands
rfd3 design n_batches=1 diffusion_batch_size=2  out_dir=./output ckpt_path=../../../../software/foundry/checkpoints/rfd3_latest.ckpt inputs=./input/hiv_binder.json skip_existing=False dump_trajectories=True prevalidate_inputs=True inference_sampler.step_scale=3 inference_sampler.gamma_0=0.2
6.
7. 
3. 
 

4. 




If you need to run GPU-dependent tools quickly (for example, your RFdiffusion SLURM job is stuck in queue for hours or days!) run the following line:
<pre> srun --pty -t 1:0:0 --mem 32G -p gpu --gres=gpu:1 bash </pre>
and run the scripts directly (without a .slurm file). If this also queues for a long time, reducing the time (-t) and memory allocation (--mem) may get you allocated compute faster. -> note the lowest recommended range 











