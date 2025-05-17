#!/bin/bash

#===================================================================#
# allrun script for testcase as part of test routine 
# run settlingTest CFD part
# Christoph Goniva - May. 2011
#===================================================================#

#- source CFDEM env vars
. ~/.bashrc

#- include functions
source $CFDEM_SRC_DIR/lagrangian/cfdemParticle/etc/functions.sh

#--------------------------------------------------------------------------------#
#- define variables
casePath="$(dirname "$(readlink -f ${BASH_SOURCE[0]})")"
logpath=$casePath
headerText="run_parallel_cfdemSolverPisoScalar_packedBedTemp_CFDDEM"
logfileName="log_$headerText"
solverName="cfdemSolverPisoScalar"
nrProcs="4"
machineFileName="none"   # yourMachinefileName | none
debugMode="off"          # on | off| strict
testHarnessPath="$CFDEM_TEST_HARNESS_PATH"
runOctave="false"
postproc="true"
cleanup="false"
#--------------------------------------------------------------------------------#

#- call function to run a parallel CFD-DEM case
parCFDDEMrun $logpath $logfileName $casePath $headerText $solverName $nrProcs $machineFileName $debugMode

#------------------------------#
if [ $runOctave == "true" ]
  then

    #- change path
    cd octave

    #- rmove old graph
    rm *.png

    #- run octave
    octave --no-gui totalPressureDropAndNusselt.m

    #- show plots 
    eog cfdemSolverPisoScalar_Nusselt.png &
    eog cfdemSolverPisoScalar_pressureDrop.png
    #------------------------------#

    #- copy log file to test harness
    cp ../../$logfileName $testHarnessPath
    cp cfdemSolverPisoScalar_Nusselt.png $testHarnessPath
    cp cfdemSolverPisoScalar_pressureDrop.png $testHarnessPath

fi

#-------------------------------------------------------#
if [ $postproc == "true" ]
  then

		
		cd $casePath/CFD
		reconstructPar -noLagrangian
		foamToVTK
		
		cd $casePath/DEM/post
		python -i $CFDEM_LPP_DIR/lpp.py dump*.liggghts_run
fi

#- clean up case
if [ $cleanup == "true" ]
  then
    keepDEMrestart="false"
    cleanCFDEMcase $casePath/CFD $keepDEMrestart
fi


