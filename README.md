# Wyss-Institute-LCD-Protein-Design-Guide
This repo will walk you through how to access the HMS O2 Cluster, access our protein design tools, activate the necessary dependencies and finally how to design de novo mini binders! 

# Navigating with Linux

Before starting any computational work, having basic familiarity with Unix/Linux will allow you to navigate and interact with all the software you will use! Going into your Terminal and testing out these commands is a good way to get some hands-on practice. 

| Linux/VIM Command  | Function                                                |
|--------------------------|---------------------------------------------------------|
| `ls`                     | show contents of current directory                      |
| `cd <folder_name>`       | move into folder                                        |
| `cd ..`                  | move out of folder                                      |
| `pwd`                    | show current directory file path                        |
| `mv <file_name> <new_location>` | move file to new location                           |
| `mvdir <folder_name> <new_location>` | move folder to new location                     |
| `rm <file_name>`         | remove file                                             |
| `rmdir <folder_name>`    | remove folder                                           |
| `vi <file_name>`         | open VIM editor (press "i" key to enter editing mode)  |
| `:wq`                    | save and quit file                                      |
| `:q`                     | quit file without saving                                |

For more helpful resources, check out these links:
- [Here](https://www.geeksforgeeks.org/linux-unix/linux-commands-cheat-sheet/) is a comprehensive Linux cheat sheet for reference <br>
- [Here](https://gitlab.com/slackermedia/bashcrawl) is a game that helps you build up your Linux muscle memory! <br>


# Getting Access to the Cluster

1. Lab members will first need to complete the [RC PPMS Billing Account form](https://tinyurl.com/request-PPMS-account) before they can request an O2 account 
2. Lab members will then need an O2 account to request an O2 account on the [Research Computing website](https://tinyurl.com/request-O2-account)

Once complete, open your Terminal and login to your user-specific login node:
<pre> ssh Your_HMS_ID@o2.hms.harvard.edu </pre>

You can then navigate to our software folder located at this directory:

<pre> cd /n/data1/hms/wyss/collins/lab/software </pre>

# Basic SLURM Commands 

SLURM is the parallel-computing scheduling system for high performance computing (HPC) clusters. It allocates compute resources for each researcher's job requests. Instead of running scripts directly in the terminal, you have to submit a SLURM script to execute the job you want to the computer can run on a node in the computer cluster.

Check out the table for a guide to basic SLURM commands:

 SLURM Command  | Function                                                |
|--------------------------|---------------------------------------------------------|
| `sbatch <jobscript>`     | submit batch job                     |
| `srun --pty -t 0-1:0:0 -p interactive /bin/bash`       | start 1 hour interactive session (run short scripts without submitting batch job)                                         |
| `squeue -u $USER`                  | check status of your run in the queue                                    |
| `scancel <jobid>`                    | cancel job in queue                        |
| `	sinfo` | check status of node                           |

Here is a [link](https://harvardmed.atlassian.net/wiki/spaces/O2/pages/1586793632/Using+Slurm+Basic) to more detailed SLURM documentation from O2 RC. 


# Loading Conda Environments 

Conda environments are essentially directories with isolated software packages. Each user must configure conda to be able to run from their node on the cluster, and eventually setup different conda environments to run different protein design softwares. 

Start by requesting an interactive session on the O2 cluster. The following command allocates 8 CPUs and 32G of memory for a 2 hour session for any debugging or other scripts you would like to run:

<pre> srun --pty -p interactive -t 2:00:00 -c 8 --mem=32G bash </pre>

If you need to run GPU-dependent tools (any of the protein design tools like RFdiffusion, run the following line. If queuing takes a very long time, reducing the time and memory allocation may get you allocated compute faster. 

<pre> srun --pty -t 1:0:0 --mem 8G -p gpu --gres=gpu:1 bash </pre>

Configure your conda by typing the following commands in the software directory one at a time:

<pre> export PATH=/n/data1/hms/wyss/collins/lab/software/miniconda/bin:$PATH </pre>
<pre> source /n/data1/hms/wyss/collins/lab/software/miniconda/etc/profile.d/conda.sh </pre>
<pre> source ~/.bashrc </pre>

After this step, you may need to close and relaunch the cluster on Terminal. Later on if you need to rebuild conda environments or run scripts, always launch an interactive session to not clog up the login node. 
Each protein design tool needs their conda environment to be setup to load the specific packages needed. 


Here is a table of conda commands which will be needed:

| Conda Command  | Function                                                |
|--------------------------|---------------------------------------------------------|
| `conda info`             | check conda status and version                          |
| `conda install PACKAGENAME`     | add package to conda                             | 
| `conda activate ENVNAME`     | activate conda environment                            | 
| `conda deactivate`     | deactivate current conda environment                            | 
| `conda env list`          | show conda environments                            | 
| `conda list`          | show packages on current conda environment                       |
| `conda rename -n OLD_ENV_NAME NEW_ENV_NAME`          | rename conda environment                       |
| `conda env remove --name ENVNAME`          | delete conda environment                       |

[Here](https://docs.conda.io/projects/conda/en/4.6.0/_downloads/52a95608c49671267e40c689e0bc00ca/conda-cheatsheet.pdf) is a comprehensive Conda cheat sheet for reference!


# Protein Design Workflow
