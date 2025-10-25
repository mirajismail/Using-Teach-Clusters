# Parallel Programming Using the Teach Clusters

For compilation, run ```make```.

## Problem #1
Solution is in ```make_thumbs.sh```

Consider ```foo.jpg```, ```bar.jpg``` and ```baz.jpg```. Running the ```make_thumbs.sh``` script, ```./make_thumbs.sh``` will resize the pictures in parallel, and the output will have the ```thumb_``` prefix (i.e. ```thumb_foo.jpg```, ```thumb_bar.jpg```, ```thumb_baz.jpg```).

## Problem #2
Solution is in ```download_URL.sh``` it reads through the URLs in ```URLsFile.txt``` and lists out the URLs that fail to download.

## Problem #3
Solution is in ```check_missing_files.sh``` and the list of files is in ```file_list```

## Problem #4
Solution is in ```download_images.sh```.

## Problem #5
${1} and ${2} are placeholders used by GNU Parallel for the first and second arguments passed into the command template. In this case, they refer to the tile row and tile column indices. These placeholders allow us to generate and download each tile in parallel without manually writing all possible coordinate combinations.

## Problem #6
```bash
(for x in $(cat xlist); do
  for y in $(cat ylist); do
    do_something "$x" "$y"
  done
done) | process_output
```

Corresponds to 

```parallel do_something {1} {2} ::: $(cat xlist) ::: $(cat ylist) | process_output```

## Problem #7
This problem is in the ```/lissajous_with_args``` directory and is to be run with 2 arguments. The respective submission scripts are in ``` submit_lissajous.sh``` ```submit_lissajous_ramdisk.sh``` and they write to all_results.txt.

# Problem #8
<img width="954" height="134" alt="image" src="https://github.com/user-attachments/assets/e64702e4-9dcc-4c19-8fab-9905b3f17ab2" />

- the queues configured are debug and compute
- they each share the same 64 nodes
  
```text
sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
debug        up    4:00:00      1  down* teach37
debug        up    4:00:00      1   comp teach38
debug        up    4:00:00      2  alloc teach[39-40]
debug        up    4:00:00     60   idle teach[01-36,41-64]
compute*     up 1-00:00:00      1  down* teach37
compute*     up 1-00:00:00      1   comp teach38
compute*     up 1-00:00:00      2  alloc teach[39-40]
compute*     up 1-00:00:00     60   idle teach[01-36,41-64]
```

- debug's timelimit - 4 hours. compute's time limit - 1 day
- for both queues, nodes 1, 1, 2, 60 are in states down*, comp, alloc and idle respectively

## Problem 9

The solutions to this problem are located in the ```/hmmer_project``` directory.

1. Each split file is a subset of the UniProt protein database. Each entry is a protein sequence, and files are roughly hundreds of MB in size. The splitting of the data is likely so different parts of the total dataset can be analyzed/processed in parallel.

2. 
   a) hmmsearch compares a sequence database, like the split files from the UniProt database, against a library of profile Hidden Markov Models (hence Pfam*.hmm). Given an HMM profile set, hmmsearch finds which sequences in the FASTA file match any of them.

   b) Reads all protein categories from ```Pfam-A.hmm```, scans all the protein sequences from ```input.fasta```. ```--cpu 8``` refers to the use of 8 threads ```--noali``` suppresses alignment. The output is written to ```output.txt```

   c) The script is in ```hmmer_parallel.sh```. ```--cpu 8``` can run a single FASTA file (or 1 job) with multiple threads. With ```GNU parallel```, can run the 256 FASTA chunks simultaneously. Together, ```GNU parallel``` provides multi-process parallelism and ```-cpu 8``` provides multi-thread parallelism (within a process).

   d) The solution is in ```submit_hmmsearch.sh```.

   Here is a comparison between ```top -u $USER``` and ```jobperf -j 49 -i 5s```

   <img width="749" height="300" alt="image" src="https://github.com/user-attachments/assets/75137bec-9dda-49f8-b769-bb2ad4942131" />
   

   <img width="1930" height="250" alt="image" src="https://github.com/user-attachments/assets/5f2b0867-a51d-4708-ba18-88b450528ef1" />

   from the in-situ real-time monitoring, each thread uses more than 100% of CPU, and the memory statistics are: ```MiB Mem : 193076.2 total, 155406.3 free, 4146.1 used, 33523.8 buff/cache```. The system's total CPU utilization is 92%.

   From ```jobperf``` it tells us 32 concurrent hmmsearch processes are occurring, but since the command catches the job discretely, it tells us the momentary CPU, RAMDISK and Memory usage is 0.

   Hence, the in-situ statistics are more descriptive.

   d) The solution is in ```submit_hmmsearch_multinode.sh```

   <img width="764" height="301" alt="image" src="https://github.com/user-attachments/assets/4184d038-1afb-463d-a63d-b6f14d75c3f6" />

   <img width="2060" height="278" alt="image" src="https://github.com/user-attachments/assets/a77d1b33-5316-456d-89ff-d867a755209d" />

    CPU utilization significantly dropped to 6.6%.

   e) A possible solution would be to load copies of the Pfam DB into memory - this way each hmmsearch process reads the database from RAM rather than from storage. This would be a good solution because reading from RAM is orders of magnitude faster than reading from disk. This would be a problem if we have limited RAM however.


