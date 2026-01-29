# Wyss-Institute-LCD-Protein-Design-Guide
This repo will walk you through how to access the HMS O2 Cluster, access our protein design tools, activate the necessary dependencies and finally how to design de novo mini binders! Protein design work uses some basic syntax. You can refer to the commands you need to be familiar with [here](./command_cheatsheet.md). 

# Accessing the Cluster

1. Lab members will first need to complete the [RC PPMS Billing Account form](https://tinyurl.com/request-PPMS-account) before they can request an O2 account 
2. Lab members will then need an O2 account to request an O2 account on the [Research Computing website](https://tinyurl.com/request-O2-account)

Once complete, open your Terminal and login to your user-specific login node:
<pre> ssh Your_HMS_ID@o2.hms.harvard.edu </pre>

You can then navigate to our software folder located at this directory:

<pre> cd /n/data1/hms/wyss/collins/lab/software </pre>


# Setting Up Conda

Conda runs "environments" are essentially directories with isolated software packages. Each user must configure the shared conda to be able to run it from their node on the cluster, and eventually setup different conda environments to run different protein design softwares. 

Start by requesting an interactive session on the O2 cluster. The following command allocates 8 CPUs and 32G of memory for a 2 hour session. Any computationally intensive activity like setup or debugging should be done in one of these!

<pre> srun --pty -p interactive -t 2:00:00 -c 8 --mem=32G bash </pre>


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


If this doesn't work, we have to manually configure conda into your bash:

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
Each protein design tool needs a specific conda environment setup with necessary packages in order to run. 


# Protein Design Workflow
Check out these overview slides explaning each tool and target applications protein design can tackle [here](https://hu-my.sharepoint.com/:p:/g/personal/dawningjiaxi_fu_wyss_harvard_edu/EVwylZ5jwstJlKK3unATEh4BOkJ3t_kOPiGjVQT0rVE__A?e=bCCi2G).

If you need to run GPU-dependent tools (any of the protein design tools like RFdiffusion, run the following line. If queuing takes a very long time, reducing the time and memory allocation may get you allocated compute faster. 

<pre> srun --pty -t 1:0:0 --mem 8G -p gpu --gres=gpu:1 bash </pre>



1. [RFDiffusion](https://github.com/RosettaCommons/RFdiffusion)
a. Navigate to the RFDiffusion directory
<pre> cd RFdiffusion/ </pre>
b. Create the conda environment from the provided yaml file which loads all the necessary packages
<pre> conda env create -f env/rfdiff.yml </pre>
 c. Load the environment, after which it should say (rfdiff) instead of (base) in your command line 
 <pre> conda activate rfdiff  </pre>
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
















