#!/bin/bash
#SBATCH --partition=SkylakePriority                   	# Name of partition
#SBATCH --nodes=1
#SBATCH --ntasks=20                           	# Request 4 CPU cores

module load singularity/3.0
cd /home/sna18003/CFDEM/myCases/capiPackedBed
/apps2/singularity/images/3.0/cfdem/cfdem.sif ./Allrun.sh
