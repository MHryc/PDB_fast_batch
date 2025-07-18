# PDB_fast_batch

PDB batch download, faster than [one shared by RCSB PDB](https://www.rcsb.org/docs/programmatic-access/batch-downloads-with-shell-script)

1. Instead of downloading each file individually it first creates a list of
   URLs and passes it to `wget -i`, making it much faster.
2. Instead of passing file with PDB IDs separated by comas you pass a file with
   one PDB ID per line, making it easier to create input data from tabular (eg.
   csv and tsv) files.

## Speed comparison

Both scripts were tested on a list of 54 PDB IDs

Scripts' download speed was measured for cif.gz, pdb.gz, pdb1.gz,
assembly1.cif.gz and xml.gz for a list of 54 PDB IDs (270 files in total) using
linux `time`.

In this test `PDB_fast_batch.sh` was around 50 times faster.

### RCSB PDB original

```
$ time ./batch_download.sh -f abc5_pdbid.csv -cpaAx
```

```
real    6m59.701s
user    0m3.143s
sys     0m2.035s
```

### wget based fork

```
$ time ./PDB_fast_batch.sh -f abc5_pdbid.txt -cpaAx -o test_out
```

```
real    0m7.495s
user    0m0.680s
sys     0m0.585s
```
