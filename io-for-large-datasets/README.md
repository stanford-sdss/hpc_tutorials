# Stop Waiting on I/O: Sherlock Workflows for Your Data-Heavy Pipelines
Brought to you by the [SDSS Center for Computation](https://sdss-compute.stanford.edu). \
Thursday, March 5th in Green Earth Sciences 365 from 1-2pm

In today's workshop we are going to cover how to speed up your AI and machine learning analysis pipelines on Sherlock when working with a large data store composed of many smaller files. This will help you choose where to store your data and how to create an efficient pipeline for loading your data from storage into compute. You will learn how to move data directly into compute node storage, and where to store your data at all stages of your AI workflows.

### Today's Tutorial Agenda:
1. Why does it make a difference where I store my data? [Slides](https://docs.google.com/presentation/d/1VC2e1waPwTNF0T1GiDtajMs6W5UOfuk8JONDWJVF14w/edit?usp=sharing)
2. Launch an interactive shell on Sherlock using [Open OnDemand](https://ondemand.sherlock.stanford.edu/pun/sys/shell/ssh/localhost)
3. Test I/O performance when pulling data from `/oak/`, `/scratch/`, and directly from the compute node, `/lscratch/`. [Tutorial](https://github.com/stanford-sdss/hpc_tutorials/blob/main/io-for-large-datasets/io-for-large-datasets.md)
4. Launch an interactive Jupyter Hub session on Sherlock using [Open OnDemand](https://ondemand.sherlock.stanford.edu/pun/sys/dashboard/batch_connect/sys/sh_jupyterlab/session_contexts/new)
5. See how this affects streaming data into AI pipelines in PyTorch. [Tutorial](https://github.com/stanford-sdss/hpc_tutorials/blob/main/io-for-large-datasets/io-for-large-datasets.ipynb)

Want to run your own AI pipeline from `/lscratch/`? [Here's an example Slurm submission script](https://github.com/stanford-sdss/hpc_tutorials/blob/main/io-for-large-datasets/example_workflow/run_script.submit) that copies data onto `/lscratch/` from `/scratch/` and then saves the outcomes back to `/scratch/`. Reminder! Anything saved onto `/lscratch/` is immediately purged when compute completes, so it's important to save enough time for backup.

### Do you have any questions? 
Please reach out to us on our slack channel, `#sdss-compute-users`, at [sdss-compute@stanford.edu](mailto:sdss-compute@stanford.edu).