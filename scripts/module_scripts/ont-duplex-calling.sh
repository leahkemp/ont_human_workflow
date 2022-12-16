#!/bin/bash -l

# duplex calling
# set up
python3 -m venv venv --prompt duplex
. venv/bin/activate
pip install duplex_tools
# source the environment
source /public-data/software/venv/bin/activate

# make directory for duplex data
mkdir "${OUTPUTDIR}"/duplex

# identify pairs
duplex_tools pairs_from_summary "${OUTPUTDIR}"/sequencing_summary.txt "${OUTPUTDIR}"/duplex/
# filter pairs
duplex_tools filter_pairs "${OUTPUTDIR}"/duplex/pair_ids.txt "${INPUTDIR}"/fastq_pass/

# duplex basecalling
"${GUPPYPATH}"./guppy_basecaller_duplex \
  -i "${INPUTDIR}" \
  -r \
  -s "${OUTPUTDIR}"/duplex/ \
  -x 'cuda:0,1' \
  -c dna_r10.4.1_e8.2_400bps_sup.cfg \
  --chunks_per_runner 412 \
  --duplex_pairing_mode from_pair_list \
  --duplex_pairing_file "${OUTPUTDIR}"/duplex/pair_ids_filtered.txt

# Notes:
# WARNING: remember to change --chunks_per_runner to fit with the GPU resources that are available
# A lot of things Nanopore this will change quickly (when Dorado becomes the new production basecaller),
# but for now this will work. The newest version (Dec 2022) of duplex-tools has increased the number
# of identified duplex reads.
