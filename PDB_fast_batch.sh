#!/bin/bash

# Script to download files from RCSB http file download services.
# Use the -h switch to get help on usage.

if ! command -v wget &> /dev/null; then
	echo "'wget' could not be found. You need to install 'wget' for this script to work."
	exit 1
fi

PROGNAME=$0
BASE_URL="https://files.rcsb.org/download/"

usage() {
	cat << EOF >&2
Usage: $PROGNAME -f <file> [-o <dir>] [-c] [-p]

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
EOF
	exit 1
}

listfile=""
outdir="."
cif=false
pdb=false
pdb1=false
cifassembly1=false
xml=false
sf=false
mr=false
mrstr=false
while getopts f:o:cpaAxsmrh o; do
	case $o in
		(f) listfile=$OPTARG;;
		(o) outdir=$OPTARG;;
		(c) cif=true;;
		(p) pdb=true;;
		(a) pdb1=true;;
		(A) cifassembly1=true;;
		(x) xml=true;;
		(s) sf=true;;
		(m) mr=true;;
		(r) mrstr=true;;
		(h) usage ;;
		(*) usage
	esac
done
shift "$((OPTIND - 1))"

if [ "$listfile" == "" ]; then
	echo "Parameter -f must be provided"
	exit 1
fi

# create output directory if it doesn't exists
[[ -d $outdir ]] || mkdir -p $outdir

# used to generate temporary files for pasting final URLs
length=$(wc -l $listfile | cut -d ' ' -f 1)

# make list of URLs for wget -i
make_list() {
	size=$1
	base_url=$2
	extension=$3

	for i in $(seq $size); do
		echo $base_url >> base.tmp
		echo $extension >> extensions.tmp
	done

	paste -d '' base.tmp $listfile extensions.tmp

	# delete temporary files
	rm base.tmp extensions.tmp
}

formats=($cif $pdb $pdb1 $cifassembly1 $xml $sf $mr $mrstr)
extensions=(
	".cif.gz" ".pdb.gz" ".pdb1.gz" "-assembly1.cif.gz" 
	".xml.gz" "-sf.cif.gz" ".mr.gz" "_mr.str.gz"
)

# loop over file formats and downloads ones picked by the user
for idx in {0..7}; do
	if [[ ${formats[$idx]} == true ]]; then
		extension="${extensions[$idx]}"
		echo "Downloading *$extension to $outdir"
		wget -nv -i <(make_list $length $BASE_URL $extension)
		mv *$extension $outdir
	fi
done
