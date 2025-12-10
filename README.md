# Wyss-Institute-LCD-Protein-Design-Guide
This repo will walk you through how to access the HMS O2 Cluster, access our protein design tools, activate the necessary dependencies and finally how to design de novo mini binders! 



# Getting Access to the Cluster

1. Lab members will first need to complete the [RC PPMS Billing Account form](https://tinyurl.com/request-PPMS-account) before they can request an O2 account 
2. Lab members will then need an O2 account to request an O2 account on the [Research Computing website](https://tinyurl.com/request-O2-account)

Once complete, open Terminal and login to your user-specific login node:
<pre> ssh Your_HMS_ID@o2.hms.harvard.edu </pre>

You can then navigate to our software folder located at this directory:

<pre> cd /n/data1/hms/wyss/collins/lab/software </pre>

# Loading Conda Environments 

Conda environments are essentially directories with isolated software packages. Each user must configure conda to be able to run from their node on the cluster, and eventually setup different conda environments to run different protein design softwares. 

Start by requesting an interactive session on the O2 cluster. The following command allocates 8 CPUs and 32G of memory for a 2 hour session for any expensive commands you would like to run:

<pre> srun --pty -p interactive -t 2:00:00 -c 8 --mem=32G bash </pre>

Configure your conda by typing the following commands in the software directory one at a time:

<pre> export PATH=/n/data1/hms/wyss/collins/lab/software/miniconda/bin:$PATH </pre>
<pre> source /n/data1/hms/wyss/collins/lab/software/miniconda/etc/profile.d/conda.sh </pre>
<pre> source ~/.bashrc </pre>

After this step, you may need to close and relaunch the cluster on Terminal. Later on if you need to rebuild conda environments or run scripts, always launch an interactive session to not clog up the login node. 

# Protein Design Workflow
