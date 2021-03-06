#!/bin/bash

DATIN=$1
DATOUT=$2
DATINBASE=$(basename $DATIN)

function template {
	cat <<EOF
#!/bin/bash

#SBATCH -p realtime
#SBATCH -N 1
#SBATCH -A als
#SBATCH -t 00:15:00
#SBATCH -J fast_tomopy_%j
#DW jobdw capacity=1GB access_mode=striped type=scratch
#DW stage_in source=$DATIN destination=\$DW_JOB_STRIPED/$DATINBASE type=file
#DW stage_out source=\$DW_JOB_STRIPED\outputdir destination=$DATOUT type=directory

module load python/2.7-anaconda
source activate bl832

mkdir \$DW_JOB_STRIPED\outputdir

srun -N 1 -n 1 -- python fast_tomopy.py -i \$DW_JOB_STRIPED/$DATINBASE -o \$DW_JOB_STRIPED/outputdir/
EOF
}

template > `pwd`/$DATINBASE.temp
sbatch `pwd`/$DATINBASE.temp
rm `pwd`/$DATINBASE.temp
