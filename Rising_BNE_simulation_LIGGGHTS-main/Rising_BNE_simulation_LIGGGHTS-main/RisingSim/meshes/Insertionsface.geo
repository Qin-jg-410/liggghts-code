// Gmsh project created on Tue Apr 26 18:15:31 2022
SetFactory("OpenCASCADE");
//+
Circle(1) = {0, 0, 0.18, 0.488, 0, 2*Pi};
//+
Curve Loop(1) = {1};
//+
Surface(1) = {1};
