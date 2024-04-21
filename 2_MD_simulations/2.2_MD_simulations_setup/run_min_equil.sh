#!/bin/bash
#SBATCH --job-name=EQUIL
#SBATCH --partition=gpu
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --gres=gpu:1
#SBATCH --qos=gpu
#SBATCH --gres-flags=enforce-binding

######################################################################
# Please use sed to replace "INPUT" in this file by the base name of #
# your choice. "${BD}/INPUT.rst7" and "${BD}/INPUT.parm7" are the    #
# original input files generated for the MD simulations              #
######################################################################

module load amber/20_cuda
BD=$(pwd)
MIN=${BD}/MIN
PAR=${BD}/INPUT.parm7
CRD=${BD}/INPUT.rst7
cd ${MIN}/
srun pmemd.cuda_DPFP -O -i ${MIN}/min.in -o ${MIN}/min.out -p ${PAR} -c ${CRD} -r ${MIN}/INPUT_min.ncrst

cd ${BD}/1_EquilNVT/
NVT=${BD}/1_EquilNVT
srun pmemd.cuda -O -i ${NVT}/run_nvt.in -o ${NVT}/run_nvt.out -p ${PAR} -c ${MIN}/INPUT_min.ncrst -r ${NVT}/INPUT_NVT.ncrst -ref ${MIN}/INPUT_min.ncrst -x ${NVT}/INPUT_NVT.nc

cd ${BD}/2_EquilNPT/
NPT=${BD}/2_EquilNPT
srun pmemd.cuda -O -i ${NPT}/run_npt.in -o ${NPT}/run_npt.out -p ${PAR} -c ${NVT}/INPUT_NVT.ncrst -r ${NPT}/INPUT_NPT.ncrst -ref ${NVT}/INPUT_NVT.ncrst -x ${NPT}/INPUT_NPT.nc

