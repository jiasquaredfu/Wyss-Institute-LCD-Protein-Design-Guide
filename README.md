# Wyss-Institute-LCD-Protein-Design-Guide
Greetings! This README will walk you through how to access the HMS O2 Cluster, access our protein design tools, activate the necessary dependencies and finally how to design de novo mini binders! 

<h4>
<b> Protein design work uses basic syntax in terminal/VIM, SLURM, and Conda. If you are not familiar, this page contains very helpful commands to reference [here](./command_cheatsheet.md) .</b> </h4>

# Accessing the Cluster :computer:

1. Lab members will first need to complete the [RC PPMS Billing Account form](https://tinyurl.com/request-PPMS-account) before they can request an O2 account 
2. Lab members will then need an O2 account to request an O2 account on the [Research Computing website](https://tinyurl.com/request-O2-account)

Once complete, open your Terminal and login to your user-specific login node:
<pre> ssh Your_HMS_ID@o2.hms.harvard.edu </pre>

You can then navigate to our software folder located at this directory:

<pre> cd /n/data1/hms/wyss/collins/lab/software </pre>

Start by requesting an interactive session on the O2 cluster. The following command allocates 8 CPUs and 32G of memory for a 2 hour session. Any computationally intensive activity like setup or debugging should be done in one of these!

<pre> srun --pty -p interactive -t 2:00:00 -c 8 --mem=32G bash </pre>

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
2. You should see a UI like this, and be able to load .pdb or .cif files and play around with the structures. 
<img width="1120" height="974" alt="image" src="https://github.com/user-attachments/assets/41446ea8-6a72-4c97-8a87-31c232642c56" />
3. Highly recommend reviewing basic Pymol commands in the cheat sheet [here](./command_cheatsheet.md)!


# Running the Protein Pipeline :runner:
<img width="865" height="609" alt="image" src="https://github.com/user-attachments/assets/2a8b2178-7ffd-4f73-8587-e5721da5b795" />

Finally it's time for the fun stuff!

The "standard" protein design pipeline is composed of 3 steps:

<b><h3> 1. Backbone design </b></h3>
 - Generates the 3D scaffold for your target design, such as a binder, enzyme or de novo protein 
 - Our pipeline uses the newest iteration of RFDiffusion3 through Rosetta Commons' Foundry, paper linked [here](https://www.biorxiv.org/content/10.1101/2025.09.18.676967v1)
 - <b> Input: </b> .PDB file of your target and .JSON file containing design parameters
   <b> Output: </b> .cif.gz zipped structure file containing backbone with only alpha carbons (will be a sequence of GGGGGGs)
<b> <h3> 2. Sequence design </b> </h3>
 - Assigns an amino acid sequence which folds into the bare backbone structure
 - Our pipeline uses ProteinMPNN (which has many subsets like LigandMPNN,ThermoMPNN depending on your application), paper linked [here](https://www.science.org/doi/10.1126/science.add2187)
 - <b> Input: </b> .PDB file of the backbone from RFdiffusion 
 - <b> Output: </b> .fa sequence file containing amino acid sequence (chain separated by / )
<b> <h3> 3. Structure prediction </b> </h3>
 - Validates structure by folding into final conformation, allows for computational analysis and filtering before experimental validation
 - Our pipeline uses the newest iteration of RoseTTAFold3 through Rosetta Commons' Foundry and Colabfold, paper linked [here](https://www.biorxiv.org/content/10.1101/2025.08.14.670328v2)
 - <b> Input: </b> .JSON file containing sequence(s) from the PMPNN .fa file
 - <b> Output: </b>

For additional context on each tool and target applications protein design can tackle, we have overview slides [here](https://hu-my.sharepoint.com/:p:/g/personal/dawningjiaxi_fu_wyss_harvard_edu/EVwylZ5jwstJlKK3unATEh4BOkJ3t_kOPiGjVQT0rVE__A?e=bCCi2G). The official Github with documentation for each software used in the pipeline are linked in the header if you want download and adjust the models yourself. 


## RFDiffusion3 :art:
1. [RFDiffusion3 (part of Rosetta Common's Foundry)](https://github.com/RosettaCommons/foundry/blob/production/models/rfd3/README.md) - Backbone Design
a.  Load the environment, after which it should say (foundry) instead of (base) in your command line 
 <pre> conda activate foundry  </pre>
b. Create input and output folders in your personal directory 
<pre> mkdir /input  </pre> 
<pre> mkdir /output </pre> 
c. Adjust SLURM script
<pre> yo  </pre> 



Each time you run RFDiffusion, first activate the environment by running:  <pre> conda activate foundry  </pre>
You can deactivate it with: <pre> conda deactivate </pre>




If you need to run GPU-dependent tools quickly (for example, your RFdiffusion SLURM job is stuck in queue for hours or days!) run the following line:
<pre> srun --pty -t 1:0:0 --mem 32G -p gpu --gres=gpu:1 bash </pre>
and run the scripts directly (without a .slurm file). If this also queues for a long time, reducing the time (-t) and memory allocation (--mem) may get you allocated compute faster. -> note the lowest recommended range 











