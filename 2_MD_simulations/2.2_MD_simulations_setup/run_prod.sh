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
# your choice. "${BD}/INPUT.parm7" is the parameters file generated  #
# for the MD simulations.                                            #
# Also you should replace "REPLICA" by the id of the current replica.#                                            #
######################################################################

module load amber/20_cuda
BD=$(pwd)
PAR=${BD}/INPUT.parm7
PROD=${BD}/3_Production

cd ${BD}/3_Production
rm -Rf ${BD}/3_Production/REPLICA
mkdir -p ${BD}/3_Production/REPLICA

pmemd.cuda -O -i ${PROD}/run_npt.in -o ${PROD}/REPLICA/run_npt.out -p ${PAR} -c ${PROD}/INPUT_NPT_REPLICA.ncrst -r ${PROD}/REPLICA/INPUT_NPT_REPLICA_prod.ncrst -x ${PROD}/REPLICA/INPUT_NPT_REPLICA_prod.nc -inf ${PROD}/REPLICA/INPUT_NPT_REPLICA_prod.mdinfo
