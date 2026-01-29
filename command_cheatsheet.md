# Navigating Terminal with Linux

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



# Accessing Packages with Conda 

Conda runs "environments" are essentially directories with isolated software packages. Each user must configure the shared conda to be able to run it from their node on the cluster, and eventually setup different conda environments to run different protein design softwares. 

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




# Submitting Cluster Jobs with SLURM

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
