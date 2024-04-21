#!/bin/bash

source $AMBERHOME/amber.sh
# Prepare the topology files for ligand, receptor and the complex
ante-MMPBSA.py -p USP7_RHA.parm7 -c COMPLEX.parm7 -r RECEPTOR.parm7 -l LIGAND.parm7 -s '!(:1-1159)' -m '!(:1083-1159)' --radii=mbondi2

rm -Rf MMGBSA_RESULTS
cd MMGBSA_RESULTS/

# Run the MMGBSA analysis
mpirun -np 32 MMPBSA.py.MPI -O -i ../mmgbsa.in -o FINAL_RESULTS_MMPBSA.dat -do FINAL_DECOMP_MMPBSA.dat -eo ENERGY_TERMS_BY_FRAME.csv -deo ENERGY_TERMS_BY_RESIDUE.csv -sp ../USP7_RHA.parm7 -cp ../COMPLEX.parm7 -rp ../RECEPTOR.parm7 -lp ../LIGAND.parm7 -y ../centered.nc
