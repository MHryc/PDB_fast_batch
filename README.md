# PDB_fast_batch

PDB batch download, faster than [one shared by RCSB PDB](https://www.rcsb.org/docs/programmatic-access/batch-downloads-with-shell-script)

1. Instead of downloading each file individually it first creates a list of
   URLs and passes it to `wget -i`, making it much faster.
2. Instead of passing file with PDB IDs separated by comas you pass a file with
   one PDB ID per line, making it easier to create input data from tabular (eg.
   csv and tsv) files.

## Usage

```
Usage: ./PDB_fast_batch.sh -f <file> [-o <dir>] [-c] [-p]

 -h       : get this help message
 -f <file>: the input file containing one PDB ID per line
 -o  <dir>: the output dir, default: current dir
 -c       : download a cif.gz file for each PDB id
 -p       : download a pdb.gz file for each PDB id (not available for large structures)
 -a       : download a pdb1.gz file (1st bioassembly) for each PDB id (not available for large structures)
 -A       : download an assembly1.cif.gz file (1st bioassembly) for each PDB id
 -x       : download a xml.gz file for each PDB id
 -s       : download a sf.cif.gz file for each PDB id (diffraction only)
 -m       : download a mr.gz file for each PDB id (NMR only)
 -r       : download a mr.str.gz for each PDB id (NMR only)
```

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
