# Wyss-Institute-LCD-Protein-Design-Guide
This repo will walk you through how to access the HMS O2 Cluster, access our protein design tools, activate the necessary dependencies and finally how to design de novo mini binders! Protein design work uses some basic syntax. You can refer to the commands you need to be familiar with [here](./command_cheatsheet.md). 

# Accessing the Cluster

1. Lab members will first need to complete the [RC PPMS Billing Account form](https://tinyurl.com/request-PPMS-account) before they can request an O2 account 
2. Lab members will then need an O2 account to request an O2 account on the [Research Computing website](https://tinyurl.com/request-O2-account)

Once complete, open your Terminal and login to your user-specific login node:
<pre> ssh Your_HMS_ID@o2.hms.harvard.edu </pre>

You can then navigate to our software folder located at this directory:

<pre> cd /n/data1/hms/wyss/collins/lab/software </pre>

Start by requesting an interactive session on the O2 cluster. The following command allocates 8 CPUs and 32G of memory for a 2 hour session. Any computationally intensive activity like setup or debugging should be done in one of these!

<pre> srun --pty -p interactive -t 2:00:00 -c 8 --mem=32G bash </pre>

# Setup Conda Before Running Pipeline 

Conda is a python-based package management system. It runs "environments" which are essentially directories with isolated software packages. We need to setup your cluster account to be able to access the shared conda and create different conda environments to run different protein design software. You only need to run the setup steps <b>once</b>!

1. Initialize conda for your account (do this only once when you are setting this up for the first time)
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


# Loading Conda Environments 
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


# Running the Protein Design Pipeline
For some context on what this pipeline looks like, [here](https://hu-my.sharepoint.com/:p:/g/personal/dawningjiaxi_fu_wyss_harvard_edu/EVwylZ5jwstJlKK3unATEh4BOkJ3t_kOPiGjVQT0rVE__A?e=bCCi2G) are some overview slides explaining each tool and target applications protein design can tackle. The official Github with documentation for each software used in the pipeline are linked in the header if you want download and adjust the models yourself. 

To keep your work organized and prevent accidental issues with the shared software folder, please make your own folder to store inputs and outputs.

1. Navigate to the users folder
<pre> cd /n/data1/hms/wyss/collins/lab/users </pre>

2. Create a personal directory for each step of the workflow.
You can duplicate my folder or just cd into it to see a setup structure you can use.

<pre> cp -r jiajia {your_name} </pre>

These are the pipeline components we will be utilizing for each step of the pathway:

<img width="865" height="609" alt="image" src="https://github.com/user-attachments/assets/2a8b2178-7ffd-4f73-8587-e5721da5b795" />

1. [RFDiffusion3 (part of Rosetta Common's Foundry)](https://github.com/RosettaCommons/foundry/blob/production/models/rfd3/README.md) - Backbone Design
a.  Load the environment, after which it should say (foundry) instead of (base) in your command line 
 <pre> conda activate foundry  </pre>
b. Create input and output folders in your personal directory 
<pre> mkdir /input  </pre> 
<pre> mkdir /output </pre> 
c. Adjust SLURM script
<pre> yo  </pre> 



 d. <pre> cd env/SE3Transformer  </pre> 
 e. Install the packages in the requirements file
 <pre> pip install --no-cache-dir -r requirements.txt </pre> 
 f. Setup the NVIDIA SE3nv transformer
 <pre>  python setup.py install </pre> 
 g. Return to the root directory of the repository
 <pre>  cd ../..</pre> 
 h. Install the RFdiffusion module at the root of the directory
 <pre> pip install -e </pre> 

Each time you run RFDiffusion, first activate the environment by running:  <pre> conda activate rfdiff  </pre>
You can deactivate it with: <pre> conda deactivate </pre>




If you need to run GPU-dependent tools quickly (for example, your RFdiffusion SLURM job is stuck in queue for hours or days!) run the following line:
<pre> srun --pty -t 1:0:0 --mem 32G -p gpu --gres=gpu:1 bash </pre>
and run the scripts directly (without a .slurm file). If this also queues for a long time, reducing the time (-t) and memory allocation (--mem) may get you allocated compute faster. -> note the lowest recommended range 











