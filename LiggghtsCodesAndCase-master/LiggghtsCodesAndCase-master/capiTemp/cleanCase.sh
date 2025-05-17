#!/bin/bash



#- clean up case
echo "deleting data at: . ?"
#read
rm -r ./*.e*
rm -r ./*.o*
rm -r ./log*
rm -r ./CFD/0.0*
rm -r ./CFD/log.*
rm -r ./CFD/averageProps
rm -r ./CFD/*.OpenFOAM
rm -r ./CFD/*.restart*
rm -r ./CFD/clockData
rm -r ./CFD/*.dat
rm -r ./CFD/octave/*.dat
rm -r ./CFD/octave/*.eps
rm -r ./CFD/octave/octave-workspace
rm -r ./CFD/processor*
rm -r ./CFD/VTK
rm -r ./CFD/volAvU
rm -r ./CFD/couplingFiles
rm -r ./CFD/particles
rm -r ./CFD/probe*
rm -r ./CFD/postProcess*
rm -r ./CFD/particleProbes
rm -r ./CFD/*Restart*
rm -r ./CFD/*restart*
rm -r ./CFD/fluidFlowStats.res
rm -r ./CFD/constant/polyMesh/*.gz
rm -r ./CFD/constant/polyMesh/faces
rm -r ./CFD/constant/polyMesh/neighbour
rm -r ./CFD/constant/polyMesh/owner
rm -r ./CFD/constant/polyMesh/points
rm -r ./CFD/constant/polyMesh/boundary
rm -r ./CFD/processor*
rm -r ./DEM/postParticles/*
rm -r ./DEM/postGlobal/*
rm -r ./DEM/post/*.*
rm -r ./DEM/post/restart/*.*
rm -r ./DEM/log.*
rm -r ./DEM/post/Restart*
rm -r ./DEM/post/restart*

rm -r ./CFD/0.*
rm -r ./CFD/1*
rm -r ./CFD/2*
rm -r ./CFD/codeInfo.*
rm -r ./CFD/*.dat

echo "done"


