# Exploring I/O Performance Across Storage Systems

In the SDSS research computing environments, data storage is distributed across multiple tiers. Each tier offers different tradeoffs between:

- Performance
- Capacity
- Persistence
- Accessibility

Today, we're going to go over three places you can store and move your data to while computing:

| Storage Location | Typical Use | Performance |
|---|---|---|
| [Elm Storage](https://uit.stanford.edu/service/elm-storage) | Archival data preservation on tape | Retrieve only when necessary |
| [Oak Storage](https://uit.stanford.edu/service/oak-storage) | Data Repository for data still in active use | Slow |
| [Sherlock `/scratch/` Storage](https://www.sherlock.stanford.edu/docs/storage/) | 100TB of near compute storage that deletes after 90 days | Fast |
| [Sherlock Compute Node `$L_SCRATCH` storage](https://www.sherlock.stanford.edu/docs/storage/) | Temporary immediate compute storage deletes at end of compute session | Fast |

In this tutorial, we will explore **how which storage location you are accessing your data from during compute affects the overall speed of your analysis pipeline** by measuring the time required to read a dataset of Landsat satellite imagery from different storage systems.

Our goal is to understand how moving data closer to compute can noticably improve performance, but different workflows need different pipelines.

---

Before running the experiments, we need to allocate a compute node on the Sherlock cluster. We'll be working from the [Sherlock interactive shell](https://ondemand.sherlock.stanford.edu/pun/sys/shell/ssh/localhost).

The following `salloc` command requests 1 compute node with 100 GB memory for 1 hour of runtime on `serc`. If you don't have access to `serc`, ask for this on the `normal` queue.

```bash
salloc --partition=serc --nodes=1 --mem=100G --time=01:00:00
```

Once the allocation is granted, you will be placed inside a shell running on the compute node. All subsequent commands will run on that node.

---

# Measure read time from Sherlock `/scratch/`

Our first test measures how long it takes to read the dataset directly from `/scratch/` on Sherlock. Your Sherlock `/scratch/` space is located at `/scratch/users/<your-sunet-id>`.

The `time` command records how long the operation takes, giving us an indication of I/O performance when streaming data from `/scratch/` into your compute memory.

```bash
time cat /scratch/groups/jfreshwa/workshops/io-for-large-datasets/landsat_images/* > /dev/null
```

This command reads all files in the dataset, streams their contents, and discards the verbose output, ultimately printing out how long the whole command took to run.

Here we'll pause to hear what times everyone in the room got for reading in these data to their compute node. In a test before this workshop, this took 0m23.795s.

---

# Measure read time from local storage on the compute node, `$L_SCRATCH`

Sherlock provides node-local scratch storage backed by fast SSDs on the compute node itself. These are accessible by using the predefined environmental variable, `$L_SCRATCH`. This storage can be faster than `/scratch/` but is only available while the job is running. The amount of space on `$L_SCRATCH` varies from compute node to compute node, and is shared by all the users on that node. As such, we only recommend using `$L_SCRATCH` for large amounts of data when you have booked an entire node.

## How big is `$L_SCRATCH`?

Before copying any data into `$L_SCRATCH`, let's check how much space is available.

```bash
df -h $L_SCRATCH
```

This command returns total disk capacity, used space, and available space. Before copying in data, make sure there is enough space available to hold the dataset.

Here we'll pause to hear how large everyone's `$L_SCRATCH` is. In a test before this workshop, `$L_SCRATCH` had a total storage size of 3TB and 130GB were in use before copying in data.

## Measure read time when the data is not yet on `$L_SCRATCH`

Now we test the performance when the dataset must first be copied to `$L_SCRATCH` before being read.

This command measures the entire time it takes to both copy in the dataset from `/scratch/` and read the data from `$L_SCRATCH` into memory.

```bash
time (cp -r /scratch/groups/jfreshwa/workshops/io-for-large-datasets/landsat_images  $L_SCRATCH/ && cat $L_SCRATCH/landsat_images/* > /dev/null)
```

This provides the total staging cost including the time to transfer data from /scratch/ and the time to then read that data from `$L_SCRATCH` into memory. This workflow can be common in HPC pipelines where data is staged locally before compute-heavy processing begins, and the same data will need to be pulled into compute many times. While this might not be be necessary for a file that only ever gets one read, some AI pipelines train with replacement, pulling in a file multiple times over the training cycle. When training for many epochs, saving 0.25s on duplicated reads can add up quickly.

Here we'll pause to hear what times everyone in the room got for copying in these data and reading them to memory. In a test before this workshop, this took 0m54.570s.

---

## Measure read time when the data is already on `$L_SCRATCH`

We can imagine a scenario in which we would need to read some files many times over our compute session and it would make sense to copy them onto `$L_SCRATCH` one time. Once the dataset has been copied, we can measure the read performance when the data is already locally stored on the compute node.

```bash
time cat $L_SCRATCH/landsat_images/* > /dev/null
```

This test isolates pure local disk performance without the overhead of network storage. You will typically observe a significant speed improvement compared to reading directly from shared storage.

Here we'll pause to hear what times everyone in the room got for reading these data directly from `$L_SCRATCH`. In a test before this workshop, this took 0m19.775s.

---

# What about reading the data directly from `/oak/` storage?

Finally, we'll test the performance of a reading the data directly from Oak storage, which is mounted onto Sherlock via the `/oak/`path. Oak prioritizes large capacity, persitent, cost efficient storage for any data that you or your lab group is actively using. (See Elm storage to archive data that you aren't using anymore!) Unlike `/scratch/` which deletes after 90 days and `$L_SCRATCH` which deletes as soon as your computing allocation completes, `/oak/` is persistent and data remains there until you move it off. If you are in SDSS, your `/oak/` data is automatically backed up for disaster mitigation. 

For all these reasons it could seem ideal to just pull your data directly from `/oak/` while you are computing. This way you wouldn't need to make any temporary copies. But let's see why this appraoch can slow down your compute, especially when you're working with many files.

Run the following command and allow it to execute in the background while you continue working.

```bash
time cat /oak/stanford/schools/ees/workshops/io-for-large-datasets/landsat_images/* > /dev/null
```

This command takes much longer to run, but let's check back in at the end of the tutorial to compare it to the other run times. In a test before this workshop, this took 8m9.003s, or ~20x longer! It's easy to see how this could add up quickly when pulling many files or images into compute in an AI pipeline.

Kevin Tully, the Oak Storage Administrator offers [a great description](https://doerr-sustainability.slack.com/archives/C0192KNKYSU/p1770326634995669?thread_ts=1770152400.584439&cid=C0192KNKYSU) on the #sherlock-users slack as to why Oak is slower than `/scratch/`. In short, due to the way data moves between Oak and Sherlock, for data-heavy, file-heavy pipelines, making the switch to `/scratch/` is a much more efficient and effective workflow that will speed up your analysis times. We just recommend that you make sure to back up any important files regularly to Oak because `/scratch/` files that haven't been touched in 90 days are deleted.