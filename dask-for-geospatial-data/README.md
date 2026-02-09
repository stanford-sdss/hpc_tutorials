# Dask for Geospatial Analysis: Efficient Parallel Workflows for Satellite Imagery in Sherlock
Brought to you by the [SDSS Center for Computation](https://sdss-compute.stanford.edu) and [Love Data Week at the Stanford Libraries](https://lovedataweek.stanford.edu/). \
Thursday, Feb. 12th in the Branner Earth Sciences Library from 1-2pm ([Please RSVP](https://appointments.library.stanford.edu/event/15881415))

In today's workshop we are going to cover how to interact with satellite data that is larger than the onboard memory of a single core in distributed HPC environments such as Sherlock. This will provide you with a reliable framework to query for only the pixels that you are interested in from open satellite imagery datasets like Landsat. You will learn how to build and run custom functions on these images, and how to process targeted, machine-learning ready datasets.

### Today's Tutorial Agenda:
1. Launch an interactive Jupyter Lab session on Sherlock using [Open OnDemand](https://ondemand.sherlock.stanford.edu/pun/sys/dashboard/batch_connect/sys/sh_jupyterlab/session_contexts/new)
2. Install a Custom Jupyter Lab Kernel from a Containerized Environment
3. What is `dask` and how does it distribute data? [[tutorial](https://github.com/stanford-sdss/hpc_tutorials/blob/main/dask-for-geospatial-data/dask_for_geospatial.ipynb)]
4. Interacting with large satellite imagery using `dask` [[tutorial](https://github.com/stanford-sdss/hpc_tutorials/blob/main/dask-for-geospatial-data/dask_for_geospatial.ipynb)]
5. Running custom functions on select pixels using `dask` + `xarray` [[tutorial](https://github.com/stanford-sdss/hpc_tutorials/blob/main/dask-for-geospatial-data/dask_for_geospatial.ipynb)]

### Do you have any questions? 
Please reach out to us on our slack channel, `#sdss-compute-users`, at [sdss-compute@stanford.edu](mailto:sdss-compute@stanford.edu).

---

# How to Install a Custom Jupyter Lab Kernel from a Containerized Environment
Installing Python packages with specific versions and dependencies can be challenging in an HPC workspace like Sherlock. One potential solution is to containerize your coding environment (See our [workshop on package management](https://github.com/stanford-sdss/package-management/) to learn how to build your own containers!). We took this approach and containerized our custom Python environment in [NEED A PLACE TO STORE CONTAINER]() which you can use to follow along with this tutorial using the following steps. 

1. Upload `geospatial_dask.sif` into your `/home/` directory in Sherlock.
2. Change directory into this directory. This might be `/scratch/users/<your-sunet>`.
3. Run `chmod +x update-kernel.sh` from the command line.
4. Next, run `source update-kernel.sh` from the command line.
5. Verify that your new kernel, `geospatial-dask`, exists by running `ls -la ~/.local/share/jupyter/kernels/`.